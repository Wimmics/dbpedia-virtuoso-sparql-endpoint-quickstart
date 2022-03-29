#!/usr/bin/env bash
bin="isql-vt"
host="store"
port=$STORE_ISQL_PORT
user="dba"
if [ -z ${COMPUTE_STATS+x} ]; then COMPUTE_STATS=0; fi
#lastUpdate=`head -n 1 $current_fileUPDT`;
#echo "============== WE GET THE LAST UPDATE : $lastUpdate";

touch /opt/virtuoso-opensource/database/loader_locker.lck;

if [ -f "/opt/virtuoso-opensource/database/loader_locker.lck" ]; then  
echo "/opt/virtuoso-opensource/database/loader_locker.lck exist "  
else
echo "/opt/virtuoso-opensource/database/loader_locker.lck PB"
fi  

run_virtuoso_cmd () {
 VIRT_OUTPUT=`echo "$1" | "$bin" -H "$host" -S "$port" -U "$user" -P "$STORE_DBA_PASSWORD" 2>&1`
 VIRT_RETCODE=$?
 if [[ $VIRT_RETCODE -eq 0 ]]; then
   echo "$VIRT_OUTPUT" | tail -n+5 | perl -pe 's|^SQL> ||g'
   return 0
 else
   echo -e "[ERROR] running the these commands in virtuoso:\n$1\nerror code: $VIRT_RETCODE\noutput:"
   echo "$VIRT_OUTPUT"
   let 'ret = VIRT_RETCODE + 128'
   return $ret
 fi
}

wait_for_download() {
  sleep 100
  while [ -f "${DATA_DIR}/download.lck" ]; do
    sleep 1
  done
}

test_connection () {
   if [[ -z $1 ]]; then
       echo "[ERROR] missing argument: retry attempts"
       exit 1
   fi

   t=$1

   run_virtuoso_cmd 'status();'
   while [[ $? -ne 0 ]] ;
   do
       echo -n "."
       sleep 1
       echo $t
       let "t=$t-1"
       if [ $t -eq 0 ]
       then
           echo "timeout"
           return 2
       fi
       run_virtuoso_cmd 'status();'
   done
}
echo "[INFO] Waiting for download to finish..."
wait_for_download

echo "will use ISQL port $STORE_ISQL_PORT to connect"
echo "[INFO] Waiting for store to come online (${STORE_CONNECTION_TIMEOUT}s)"
: ${STORE_CONNECTION_TIMEOUT:=100}
test_connection "${STORE_CONNECTION_TIMEOUT}"
if [ $? -eq 2 ]; then
   echo "[ERROR] store not reachable"
   exit 1
fi


## META DATA
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_CREATE ('${DOMAIN}',1);"
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_INS ('${DOMAIN}','${DOMAIN}/graph/metadata');"
echo "[INFO] ADD META DATA"
run_virtuoso_cmd "DB.DBA.TTLP_MT (file_to_string_output ('${STORE_DATA_DIR}/meta_base/dbpedia_fr-metadata.ttl'), '', '${DOMAIN}/graph/metadata');" 


echo "[INFO] Setting 'dbp_decode_iri' registry entry to 'on'"
run_virtuoso_cmd "registry_set ('dbp_decode_iri', 'on');"

echo "[INFO] Setting dynamic !!!!"
run_virtuoso_cmd "registry_set ('dbp_DynamicLocal', 'on');"
run_virtuoso_cmd "registry_set ('dbp_lhost', ':8890');"
run_virtuoso_cmd "registry_set ('dbp_vhost', '${DOMAIN}');"

echo "[INFO] Setting 'dbp_domain' registry entry to ${DOMAIN}"
run_virtuoso_cmd "registry_set ('dbp_domain', '${DOMAIN}');"
echo "[INFO] Setting 'dbp_graph' registry entry to ${DOMAIN}"
run_virtuoso_cmd "registry_set ('dbp_graph', '${DOMAIN}');"
echo "[INFO] Setting 'dbp_lang' registry entry to ${DBP_LANG}"
run_virtuoso_cmd "registry_set ('dbp_lang', '${DBP_LANG}');"
echo "[INFO] Setting 'dbp_category' registry entry to ${DBP_CATEGORY}"
run_virtuoso_cmd "registry_set ('dbp_category', '${DBP_CATEGORY}');"

echo "[INFO] Installing VAD package 'dbpedia_dav.vad'"
run_virtuoso_cmd "vad_install('/opt/virtuoso-opensource/vad/dbpedia_dav.vad', 0);"
echo "[INFO] Installing VAD package 'fct_dav.vad'"
run_virtuoso_cmd "vad_install('/opt/virtuoso-opensource/vad/fct_dav.vad', 0);"

echo "[DATA IMPORT] HERE WE ENTERING IN THE CUSTOM PART"
# > we get the data_artefact name and we load it into a named graph based on 
# REGEXPR 
echo "============================"
echo "graph mode : ${GRAPH_MODE}"
echo "data dir : ${DATA_DIR}"
echo "============================"

pat1='.*\.(nt|nq|owl|rdf|trig|ttl|xml|gz|bz2)$' # IF ENDING BY ACCEPTED EXTENSIONS
pat2='([a-z\-]+)_'
pat3='.*\.bz2$'
pat4='metadata'

for entry in "${DATA_DIR}"/*
do
  echo "$entry";
  level1="";
  level2="";
  level3="";
  if [[ $entry =~ $pat1 ]]
  then
    fn=${entry##*/} # GET FILE NAME ONLY
    echo "$fn"
    if [[ $entry =~ $pat2 ]]; then
        level1="${BASH_REMATCH[1]}";
        entry1=$(echo $entry | sed "s+${BASH_REMATCH[0]}++g");
        if [[ $entry1 =~ $pat2 ]]; then
         level2="${BASH_REMATCH[1]}";
         entry2=$(echo $entry1 | sed "s+${BASH_REMATCH[0]}++g");

            if [[ $entry2  =~ $pat2 ]]; then
            level3="${BASH_REMATCH[1]}";
            fi;
        fi;
    fi;
  fi
  if [[ $level1 != "" ]] && [[ $level2 != "" ]] && [[ $level3 != "" ]]; then
     echo "found pattern so construct graph name";
     if [[ $level1 == "vehnem" ]] && [[ $level2 == "replaced-iris" ]]; then
        level1="dbpedia";
     fi
     if [[ $level1 == "vehnem" ]] && [[ $level2 == "yago" ]]; then
        level1="outlinks";
     fi
     if [[ $level1 == "ontologies" ]]; then
        level1="dbpedia";
        level2="ontology";
        level3="";
     fi

     if [[ "$level1" != "" ]]; then
             final_name="${level1}";
     fi
     if [[ "$level2" != "" ]]; then
             final_name="${level1}_${level2}";
     fi
     if [[ "$level3" != "" ]]; then
             final_name="${level1}_${level2}_${level3}";
     fi
     echo "> final name is : ${final_name}"
     
     run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_INS ('${DOMAIN}','${DOMAIN}/graph/${final_name}');"
     run_virtuoso_cmd "ld_dir ('${STORE_DATA_DIR}', '${fn}', '${DOMAIN}/graph/${final_name}');"
     
    if  [[ $entry =~ $pat3 ]] &&  [[ ! $entry =~ $pat4 ]]; then
        echo "count nb lines and get date of prod";
        #nb_lines=$( bzcat $entry | wc -l );
        # BEFORE WE USED DATE FROM FIRST LINE... 
        #last_line=$( bzcat $entry | tail -1 );
        #if [[  ${#date} != 10 ]];then
        
        #### NOW WE USED THE DATE FROM FILE NAME
        date=$(echo $entry  | grep -Eo '[[:digit:]]{4}.[[:digit:]]{2}.[[:digit:]]{2}');         
        echo ">>>>>>>>>>>>>> DATE : $date"; 
        resp=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?d) FROM <${DOMAIN}/graph/metadata> WHERE { ?s prov:wasGeneratedAtTime ?d . FILTER(?s = <${DOMAIN}/graph/${final_name}> )} ;")  
        echo "==========="
        echo $resp
        echo "==========="
        nb=$(echo $resp | awk '{print $4}')
        echo " INSIDE ? ${nb}"
        if [ "$nb" -eq "0" ];then
           run_virtuoso_cmd "SPARQL INSERT INTO <${DOMAIN}/graph/metadata> {  <${DOMAIN}/graph/${final_name}> prov:wasGeneratedAtTime '${date}'^^xsd:date . <${DOMAIN}/graph/${final_name}>  schema:datePublished '${date}'^^xsd:date . };"
        fi
        
        #echo [[ $nb_lines > 2 ]];
        
        #echo ">>>>>>>>>>>>> nb lines : $nb_lines";
        #if [[ $nb_lines > 2 ]];then 
        
         #   nbline=$(($nb_lines-2));
          #  resp=$(run_virtuoso_cmd "SPARQL SELECT ?nb FROM <${DOMAIN}/graph/metadata> WHERE { <${DOMAIN}/graph/${final_name}> void:triples ?nb};" )
           # echo "==========="
            #echo $resp
            #echo "==========="
            #nb=$(echo $resp |  awk '{print $5}')
            
            #echo " INSIDE ? ${nb}"
            #if [ "$nb" -eq "0" ];then
            #   nbline=$(($nb_lines-2));
            #   run_virtuoso_cmd "SPARQL INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}/graph/${final_name}> void:triples '${nbline}'^^xsd:integer };"
            #else
            #   new=$(($nbline+$nb))
            #   run_virtuoso_cmd  "SPARQL WITH <${DOMAIN}/graph/metadata> DELETE { <${DOMAIN}/graph/${final_name}> void:triples ${nb}. } INSERT { <${DOMAIN}/graph/${final_name}> void:triples ${new}. } WHERE { <${DOMAIN}/graph/${final_name}> void:triples ${nb}. };"
            #fi
        #fi
       

        
        run_virtuoso_cmd "SPARQL INSERT INTO <${DOMAIN}/graph/metadata> {  <${DOMAIN}/graph/${final_name}> void:dataDump <http://prod-dbpedia.inria.fr/dumps/lastUpdate/$fn> };"
        fi
    fi;
done

######################################################### OLD PROCESS
# > load every data inside the default graph 

#ensure that all supported formats get into the load list
#(since we have to excluse graph-files *.* won't do the trick
### COMMENTED
#echo "[INFO] registring RDF documents for import"
#for ext in nt nq owl rdf trig ttl xml gz bz2; do
# echo "[INFO] ${STORE_DATA_DIR}.${ext} for import"
 #run_virtuoso_cmd "ld_dir ('${STORE_DATA_DIR}', '*.${ext}', '${DOMAIN}');"
#done

echo "[INFO] deactivating auto-indexing"
run_virtuoso_cmd "DB.DBA.VT_BATCH_UPDATE ('DB.DBA.RDF_OBJ', 'ON', NULL);"

echo '[INFO] Starting load process...';

load_cmds=`cat <<EOF
log_enable(2);
checkpoint_interval(-1);
set isolation = 'uncommitted';
rdf_loader_run();
log_enable(1);
checkpoint_interval(60);
EOF`
run_virtuoso_cmd "$load_cmds";
echo "[STATS TIME]"
if COMPUTE_STATS == 1 : 
 echo "----GENERAL STATS"
 run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:entities ?no . } WHERE { SELECT COUNT(distinct ?s) AS ?no { ?s a [] } };"
 run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:classes ?no . } WHERE { SELECT COUNT(distinct ?o) AS ?no { ?s rdf:type ?o } };"
 run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:triples ?no . } WHERE { SELECT (COUNT(*) AS ?no) { ?s ?p ?o } };"
 run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:properties ?no . } WHERE { SELECT COUNT(distinct ?p) AS ?no  { ?s ?p ?o } };"

 echo "---->>> ASK FIRST THE LIST OF NAMED GRAPH"
 get_named_graph='SPARQL SELECT DISTINCT(?graphName) WHERE {GRAPH ?graphName {?s ?p ?o } } GROUP BY ?graphName ;'
 resp=$(run_virtuoso_cmd "$get_named_graph");
 graph_list=$(echo $resp | tr " " "\n" | grep -E "\/graph\/");
 echo "---->>> COMPUTE FOR EACH GRAPH STATS"
 pat4='metadata'
 pat5='wikidata'
 for graph in ${graph_list[@]}; do
     echo "<$graph>"
     echo "----  GRAPH STATS";
     run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:triples ?no . } WHERE { SELECT (COUNT(*) AS ?no)  FROM <$graph>  { ?s ?p ?o } };"
     run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:entities ?no .} WHERE { SELECT COUNT(distinct ?s) AS ?no  FROM <$graph> { ?s a [] } };"
     run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:classes ?no .} WHERE { SELECT COUNT(distinct ?o) AS ?no  FROM <$graph> { ?s rdf:type ?o } };"
     run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:properties ?no .} WHERE { SELECT COUNT(distinct ?p) AS ?no  FROM <$graph> { ?s ?p ?o } };"

      if [[ ! $graph =~ $pat4 ]] &&  [[ ! $graph =~ $pat5 ]]; then

         echo "---- CLASS PARTITIONS stats";
         echo "- classes";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?c ] . } WHERE {SELECT DISTINCT(?c) FROM <$graph>  { ?s a ?c . } };"
         echo "- nb entities per classes";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?class ; void:entities ?count ] . } WHERE {{ SELECT ?class (count(?instance) AS ?count) WHERE {SELECT DISTINCT ?class ?instance FROM <$graph> WHERE {?instance a ?class } } GROUP BY ?class } };"
         echo "- nb triplet per classes";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?c ; void:triples ?x ] . } WHERE {{ SELECT (COUNT(?p) AS ?x) ?c FROM <$graph> WHERE { ?s a ?c ; ?p ?o } GROUP BY ?c } };"
         echo "- nb prop by class";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?c ; void:properties ?x ] . } WHERE {{ SELECT (COUNT(DISTINCT ?p) AS ?x) ?c FROM <$graph> WHERE { ?s a ?c ; ?p ?o } GROUP BY ?c } };"
         echo "- besoin d'explications";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?c ; void:classes ?x ] . } WHERE {{ SELECT (COUNT(DISTINCT ?d) AS ?x) ?c  FROM <$graph> WHERE { ?s a ?c , ?d } GROUP BY ?c } };"
         echo "- distinct subject per classes";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?c ; void:distinctSubjects ?x ] . } WHERE {{ SELECT (COUNT(DISTINCT ?s) AS ?x) ?c FROM <$graph> WHERE { ?s a ?c } GROUP BY ?c } };"
         echo "- distinct object per classes";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph>  void:classPartition [void:class ?c ; void:distinctObjects ?x ] . } WHERE {{ SELECT (COUNT(DISTINCT ?o) AS ?x) ?c FROM <$graph> WHERE { ?s a ?c ; ?p ?o } GROUP BY ?c } };"
         echo "- nb triples by prop";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:classPartition [void:class ?c ; void:propertyPartition [void:property ?p ; void:triples ?x ] ] . } WHERE {{ SELECT ?c (COUNT(?o) AS ?x) ?p FROM <$graph> WHERE { ?s a ?c ; ?p ?o } GROUP BY ?c ?p } };"
         echo "- nb subj distinct by prop";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph>  void:classPartition [void:class ?c ; void:propertyPartition [void:property ?p ; void:distinctSubjects ?x ] ] . } WHERE {{ SELECT (COUNT(DISTINCT ?s) AS ?x) ?c ?p FROM <$graph>  WHERE { ?s a ?c ; ?p ?o } GROUP BY ?c ?p } };"
         echo "---- Property PARTITIONS";
         echo "-nb triples by property";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:propertyPartition [void:property ?p ; void:triples ?x ] . } WHERE {{ SELECT (COUNT(?o) AS ?x) ?p FROM <$graph> WHERE { ?s ?p ?o } GROUP BY ?p } };" 
         echo "- nb distinct Subject by prop";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:propertyPartition [void:property ?p ; void:distinctSubjects ?x ] . } WHERE {{ SELECT (COUNT(DISTINCT ?s) AS ?x) ?p FROM <$graph> WHERE { ?s ?p ?o } GROUP BY ?p } };"
         echo "- nb distinct Objects by prop";
         run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> {<$graph> void:propertyPartition [void:property ?p ; void:distinctObjects ?x ] . } WHERE {{ SELECT (COUNT(DISTINCT ?o) AS ?x) ?p FROM <$graph> WHERE { ?s ?p ?o } GROUP BY ?p } };"

      fi
 done
 echo ">>>>>>>>> END NAMED GRAPH STATS COMPUTATION"
fi
echo "[INFO] making checkpoint..."
run_virtuoso_cmd 'checkpoint;'
echo "[INFO] re-activating auto-indexing"
run_virtuoso_cmd "DB.DBA.RDF_OBJ_FT_RULE_ADD (null, null, 'All');"
run_virtuoso_cmd 'DB.DBA.VT_INC_INDEX_DB_DBA_RDF_OBJ ();'
echo "[INFO] making checkpoint..."
run_virtuoso_cmd 'checkpoint;'
echo "[INFO] update/filling of geo index"
run_virtuoso_cmd 'rdf_geo_fill();'
echo "[INFO] making checkpoint..."
run_virtuoso_cmd 'checkpoint;'
echo "[INFO] bulk load done; terminating loader"
echo "[INFO] update of lookup tables"
run_virtuoso_cmd 'urilbl_ac_init_db();'
run_virtuoso_cmd 's_rank();'
echo "[INFO] End of process"
rm "/opt/virtuoso-opensource/database/loader_locker.lck";

echo "[INFO] LOCKER DELETED... SEE YOU !"

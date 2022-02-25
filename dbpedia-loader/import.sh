#!/usr/bin/env bash
bin="isql-vt"
host="store"
port=$STORE_ISQL_PORT
user="dba"

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
  sleep 10
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
: ${STORE_CONNECTION_TIMEOUT:=60}
test_connection "${STORE_CONNECTION_TIMEOUT}"
if [ $? -eq 2 ]; then
   echo "[ERROR] store not reachable"
   exit 1
fi

echo "[INFO] Setting 'dbp_decode_iri' registry entry to 'on'"
run_virtuoso_cmd "registry_set ('dbp_decode_iri', 'on');"

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



echo "[CUSTOM PART IMPORT] HERE WE ENTERING IN THE CUSTOM PART"
# > we get the data_artefact name and we load it into a named graph based on 
# REGEXPR 
echo "============================"
echo "graph mode : ${GRAPH_MODE}"
echo "data dir : ${DATA_DIR}"
echo "============================"
echo "delete old metadata"
rm -rf ${DATA_DIR}/dbpedia_fr-metadata.ttl 

pat1='.*\.(nt|nq|owl|rdf|trig|ttl|xml|gz|bz2)$' # IF ENDING BY ACCEPTED EXTENSIONS
pat2='([a-z\-]+)_'
pat3='.*\.bz2$'

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
     run_virtuoso_cmd "ld_dir ('${STORE_DATA_DIR}', '${fn}', '${DOMAIN}/graph/${final_name}');"
     
     if  [[ $entry =~ $pat3 ]]; then
     	echo "count nb lines and get date of prod";
        nb_lines=$( bzcat $entry | wc -l );
        last_line=$( bzcat $entry | tail -1 );
        date=$(echo $last_line  | grep -Eo '[[:digit:]]{4}.[[:digit:]]{2}.[[:digit:]]{2}');  
        
        echo "NB CHAR date  ${#date}";
        echo ">>>>>>>>>>>> last line :";
        echo $last_line;
        echo ">>>>>>>>>>>>>> DATE : $date"; 
        echo ">>>>>>>>>>>>> nb lines : $nb_lines";
	if [[  ${#date} == 10 ]];then
		query_wasGeneratedAtTime="SPARQL INSERT { GRAPH <${DOMAIN}/graph/${final_name}> {  <${DOMAIN}/graph/${final_name}> prov:wasGeneratedAtTime \"$date\"^^xsd:date . <${DOMAIN}/graph/${final_name}>  schema:datePublished \"$date\"^^xsd:date . } };"
		run_virtuoso_cmd "$query_wasGeneratedAtTime"
    	fi 
	if [[ $nb_lines > 2 ]];then 
		nbline=$nb_lines-2;
		query_nbtriples="SPARQL INSERT { GRAPH <${DOMAIN}/graph/${final_name}> {  <${DOMAIN}/graph/${final_name}> void:triples \"$nbline\"^^xsd:integer . } };"
		run_virtuoso_cmd "$query_nbtiples"
	fi
	query_datadump="SPARQL INSERT { GRAPH <${DOMAIN}/graph/${final_name}> {  <${DOMAIN}/graph/${final_name}> void:dataDump <http://prod-dbpedia.inria.fr/dumps/lastUpdate/$fn> } };"
        run_virtuoso_cmd "$query_datadump"
     fi
  fi;
done

echo "=======> IMPORT LAST META DATA DESC"
cp -rf /dbpedia_fr-metadata.ttl ${DATA_DIR}
run_virtuoso_cmd "ld_dir ('${DATA_DIR}', 'dbpedia_fr-metadata.ttl', '${DOMAIN}/graph/metadata');"
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


#!/usr/bin/env bash

. ./virtuoso_fct.sh --source-only

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


############## VIRTUOSO CONFIG
echo "[INFO] Setting 'dbp_decode_iri' registry entry to 'on'"
run_virtuoso_cmd "registry_set ('dbp_decode_iri', 'on');"
echo "[INFO] Setting dynamic !!!!"
run_virtuoso_cmd "registry_set ('dbp_DynamicLocal', 'off');"
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

################ INSTALL LAST DBPEDIA VAD
echo "[INFO] Installing VAD package 'dbpedia_dav.vad'"
run_virtuoso_cmd "vad_install('/opt/virtuoso-opensource/vad/dbpedia_dav.vad', 0);"
echo "[INFO] Installing VAD package 'fct_dav.vad'"
run_virtuoso_cmd "vad_install('/opt/virtuoso-opensource/vad/fct_dav.vad', 0);"

#################### ADD DATA

## CREATE SUBGRAPHS
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_CREATE ('${DOMAIN}',1);"
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_INS ('${DOMAIN}','${DOMAIN}/graph/metadata');"
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_INS ('${DOMAIN}','${DOMAIN}/graph/statistics');"
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_INS ('${DOMAIN}','${DOMAIN}/graph/metadata_stats');"
run_virtuoso_cmd "DB.DBA.RDF_GRAPH_GROUP_INS ('${DOMAIN}','${DOMAIN}/tag');"


echo "[INFO] ADD META DATA STATS "
run_virtuoso_cmd "DB.DBA.TTLP_MT (file_to_string_output ('${STORE_DATA_DIR}/lastUpdate/meta_base/statistics_metadata.ttl'), '', '${DOMAIN}/graph/metadata_stats');"


echo "[INFO] ADD META DATA WITH DYNAMICS VALUES FROM LAST COMPUTED DUMPS "
fn_meta=$(find ${DATA_DIR}/lastUpdate/computed_dumps/ -name "metadata_used*.ttl.gz" -exec basename {} .po \;)
run_virtuoso_cmd "ld_dir ('${STORE_DATA_DIR}/lastUpdate/computed_dumps/', '${fn_meta}', '${DOMAIN}/graph/metadata'');"

echo "[INFO] ADD STATISTICS VALUES FROM LAST COMPUTED DUMPS "
fn_stats=find ${DATA_DIR}/lastUpdate/computed_dumps/ -name "statistics*.ttl.gz" -exec basename {} .po \;)
run_virtuoso_cmd "ld_dir ('${STORE_DATA_DIR}/lastUpdate/computed_dumps/', '${fn_stats}', '${DOMAIN}/graph/statistics');"


echo "[INFO] ADD CUSTOM PREFIXES"
run_virtuoso_cmd "DB.DBA.XML_SET_NS_DECL ('tag-fr', 'http://fr.dbpedia.org/tag/', 2);"
run_virtuoso_cmd "DB.DBA.XML_SET_NS_DECL ('oa', 'http://www.w3.org/ns/oa#', 2);"
run_virtuoso_cmd "DB.DBA.XML_SET_NS_DECL ('graph-fr', 'http://fr.dbpedia.org/graph/', 2);"
run_virtuoso_cmd "DB.DBA.XML_SET_NS_DECL ('abstract_graph', 'http://fr.dbpedia.org/abstract_graph/', 2);"



################# CREATE NAMED GRAPHS
echo " >>>>>> structure_process : last fix 06/06/2022"
pat1='.*\.(nt|nq|owl|rdf|trig|ttl|xml|gz|bz2)$' # IF ENDING BY ACCEPTED EXTENSIONS
pat2='([a-z\-]+)_'
pat3='.*\.(bz2|gz)$'
pat4='metadata'
echo "DATA DIR >>> ${DATA_DIR}"
for entry in "${DATA_DIR}/lastUpdate"/*
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
     run_virtuoso_cmd "ld_dir ('${STORE_DATA_DIR}/lastUpdate', '${fn}', '${DOMAIN}/graph/${final_name}');"
     echo "ADD FILE : ${STORE_DATA_DIR}/lastUpdate/${fn}";
  fi
done


##### HERE WE CHANGE THE DEFAULT BEHAVIOR OF THE DESCRIBE
# see https://community.openlinksw.com/t/how-to-change-default-describe-mode-in-faceted-browser/1691/3
run_virtuoso_cmd "INSERT INTO DB.DBA.SYS_SPARQL_HOST VALUES ('*',null,null,null,'DEFINE sql:describe-mode \"CBD\"');"

#### DATA IMPORT PLACE

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

echo "XXXXXXXXXXXXXX PROCESS TAGS BEGIN XXXXXXXXXXXXXXXXXX"
/bin/bash ./process/addProcessTags.sh
echo "XXXXXXXXXXXXXX PROCESS TAGS END XXXXXXXXXXXXXXXXXX"


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
run_virtuoso_cmd 'log_enable(1)';
run_virtuoso_cmd 'checkpoint_interval(60)';
replaceInFileAfterProcess "GLOBAL" "${process_log_file}"
echo "[INFO] LOCKER DELETED... SEE YOU !"

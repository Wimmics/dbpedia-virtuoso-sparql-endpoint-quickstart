#!/usr/bin/env bash

. ./virtuoso_fct.sh --source-only

#### PROCESS LIST
declare -a process_list=("PROCESS_INIT" "PROCESS_GEOLOC" "PROCESS_INTERLINKSAMEAS" "PROCESS_WIKIDATA" "CLEAN_WIKIDATA" "PROCESS_MULTILANG" "CLEAN_MULTILANG" "COMPUTE_STATS_MULTILANG" "PROCESS_STATS" "PROCESS_DUMPS")
# CREATE IF NOT SETED
for process in ${process_list[@]};
do
echo "$process : ${!process}"
if [ -z ${!process+x} ] ; then 
 declare  "$process=0"
 echo "$process : ${!process}"
fi   
done

echo "==========================================";
echo " DBPEDIA LOADERTEST VERSION04";
echo "==========================================";
echo "------------ Current config ------------";
echo "> PROCESS_INIT: ${PROCESS_INIT}";
echo "> PROCESS_GEOLOC : ${PROCESS_GEOLOC}";
echo "> PROCESS_INTERLINKSAMEAS : ${PROCESS_INTERLINKSAMEAS}";
echo "> PROCESS_WIKIDATA : ${PROCESS_WIKIDATA}";
echo "> CLEAN_WIKIDATA : ${CLEAN_WIKIDATA}";
echo "> PROCESS_MULTILANG : ${PROCESS_MULTILANG}";
echo "> COMPUTE_STATS_MULTILANG : ${COMPUTE_STATS_MULTILANG}";
echo "> CLEAN_MULTILANG : ${CLEAN_MULTILANG}";
echo "> PROCESS_STATS : ${PROCESS_STATS}";
echo "> PROCESS_DUMPS : ${PROCESS_DUMPS}";
echo "==========================================";

# ADD A LOCKER FOR MONITORING THE PROCESS
touch /opt/virtuoso-opensource/database/loader_locker.lck;

if [ -f "/opt/virtuoso-opensource/database/loader_locker.lck" ]; then  
echo "/opt/virtuoso-opensource/database/loader_locker.lck exist "  
else
echo "/opt/virtuoso-opensource/database/loader_locker.lck PB"
fi  


## CREATE IF NOT EXIST FORGERY FOR THIS RELEASE
fileUPDT=${DATA_DIR}/last_update.txt;
lastUpdate=`head -n 1 $fileUPDT`;
mkdir -p ${DATA_DIR}/${lastUpdate}_${VERSION}
process_log_file=${DATA_DIR}/${lastUpdate}_${VERSION}/process_log.txt
if [ ! -f $process_log_file ]
then
    touch $process_log_file
    current_time=$(date)
    echo "process_name;nb_restart;time_begin;time_end" >> "${process_log_file}"
    echo "GLOBAL;0;$current_time;" >> "${process_log_file}"
    for i in ${!process_list[@]};
    do
       process=${process_list[$i]}
       echo "$process;0;;" >> "${process_log_file}"
    done
fi

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

############## CREATE NAMED GRAPH STRUCTURE AND LOAD DATA 
if [ $PROCESS_INIT == 1 ] ; then
   echo ">>> PROCESS_INIT unabled"
   replaceInFileBeforeProcess "PROCESS_INIT" "${process_log_file}"
   /bin/bash ./process/virtuoso_init.sh
   replaceInFileAfterProcess "PROCESS_INIT" "${process_log_file}"
else
   echo ">>> PROCESS_INIT disabled"
fi
run_virtuoso_cmd "log_enable(2)";
run_virtuoso_cmd "checkpoint_interval(-1)";


############## CHANGE GEOLOC COORD FROM TRIPLE TO BLANK NODE
if [ $PROCESS_GEOLOC == 1 ] ; then
   echo ">>> PROCESS_GEOLOC unabled"
   replaceInFileBeforeProcess "PROCESS_GEOLOC" "${process_log_file}"
   /bin/bash ./process/geoloc_changes.sh
   replaceInFileAfterProcess "PROCESS_GEOLOC" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> PROCESS_GEOLOC disabled"
fi

############## DUPLICATE INTERLINK AS SAMEAS
if [ $PROCESS_INTERLINKSAMEAS == 1 ] ; then
   echo ">>> PROCESS_INTERLINKSAMEAS unabled"
   replaceInFileBeforeProcess "PROCESS_INTERLINKSAMEAS" "${process_log_file}"
   /bin/bash ./process/interlink_to_sameAs.sh
   replaceInFileAfterProcess "PROCESS_INTERLINKSAMEAS" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> PROCESS_INTERLINKSAMEAS disabled"
fi

############## PROCESS WIKIDATA
if [ $PROCESS_WIKIDATA == 1 ] ; then
   echo ">>> PROCESS_WIKIDATA unabled"
   replaceInFileBeforeProcess "PROCESS_WIKIDATA" "${process_log_file}"
   /bin/bash ./process/process_wikidata.sh
   replaceInFileAfterProcess "PROCESS_WIKIDATA" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> PROCESS_WIKIDATA disabled"
fi

############## MIGRATE EVERY LANGUAGES LABELS TO FR RESOURCES
if [ $PROCESS_MULTILANG == 1 ] ; then
   echo ">>> PROCESS_MULTILANG unabled"
   replaceInFileBeforeProcess "PROCESS_MULTILANG" "${process_log_file}"
   /bin/bash ./process/multilingual_labels.sh
   replaceInFileAfterProcess "PROCESS_MULTILANG" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> PROCESS_MULTILANG disabled"
fi

############## MIGRATE EVERY LANGUAGES LABELS TO FR RESOURCES
if [ $COMPUTE_STATS_MULTILANG == 1 ] ; then
   echo ">>> COMPUTE_STATS_MULTILANG unabled"
   replaceInFileBeforeProcess "COMPUTE_STATS_MULTILANG" "${process_log_file}"
   /bin/bash ./process/computeStatsLang.sh
   replaceInFileAfterProcess "COMPUTE_STATS_MULTILANG" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> COMPUTE_STATS_MULTILANG  disabled"
fi
############## DELETE RESSOURCES THAT HAVEN'T FR EQUIVALENT RESSOURCE
if [ $CLEAN_MULTILANG == 1 ] ; then
   echo ">>> CLEAN_MULTILANG unabled"
   replaceInFileBeforeProcess "CLEAN_MULTILANG" "${process_log_file}"
   /bin/bash ./process/clean_multilang.sh
   replaceInFileAfterProcess "CLEAN_MULTILANG" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> CLEAN_MULTILANG disabled"
fi


############## DELETE WIKIDATA RESOURCES THAT HAVN'T FR EQUIV
if [ $CLEAN_WIKIDATA == 1 ] ; then
   echo ">>> CLEAN_WIKIDATA unabled"
   replaceInFileBeforeProcess "CLEAN_WIKIDATA" "${process_log_file}"
   #/bin/bash ./process/process_wikidata2.sh
   replaceInFileAfterProcess "CLEAN_WIKIDATA" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> CLEAN_WIKIDATA disabled"
fi

############## COMPUTE STATS
if [ $PROCESS_STATS == 1 ] ; then
   echo ">>> PROCESS_STATS unabled"
   replaceInFileBeforeProcess "PROCESS_STATS" "${process_log_file}"
   /bin/bash ./process/stats_process.sh
   replaceInFileAfterProcess "PROCESS_STATS" "${process_log_file}"
   echo "---checkpoint"
   run_virtuoso_cmd 'checkpoint;'
else
   echo ">>> PROCESS_STATS disabled"
fi


############## EXPORT NEW DATASETS
if [ $PROCESS_DUMPS == 1 ] ; then
   echo ">>> PROCESS_DUMPS unabled"
   replaceInFileBeforeProcess "PROCESS_DUMPS" "${process_log_file}"
   /bin/bash ./process/dumps_export.sh
   replaceInFileAfterProcess "PROCESS_DUMPS" "${process_log_file}"
else
   echo ">>> PROCESS_DUMPS disabled"
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
run_virtuoso_cmd 'log_enable(1)';
run_virtuoso_cmd 'checkpoint_interval(60)';
replaceInFileAfterProcess "GLOBAL" "${process_log_file}"
echo "[INFO] LOCKER DELETED... SEE YOU !"

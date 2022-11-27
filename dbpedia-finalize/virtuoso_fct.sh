#!/usr/bin/env bash

bin="isql-vt"
host="store"
port=$STORE_ISQL_PORT
user="dba"

run_virtuoso_cmd () {
 NB_TRY=3
 for i in {1..$NB_TRY}
  do
   VIRT_OUTPUT=`echo "$1" | "$bin" -H "$host" -S "$port" -U "$user" -P "$STORE_DBA_PASSWORD" 2>&1`
   VIRT_RETCODE=$?
   if [[ $VIRT_RETCODE -eq 0 ]]; then
     echo "$VIRT_OUTPUT" | tail -n+5 | perl -pe 's|^SQL> ||g'
     i=$NB_TRY
     return 0
   else
     echo -e "[ERROR] running the these commands in virtuoso:\n$1\nerror code: $VIRT_RETCODE\noutput:"
     echo "$VIRT_OUTPUT"
     #let 'ret = VIRT_RETCODE + 128'
     #return 0
   fi
  done
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
get_answer_nb() {

   nb_resp_=$1;
   if [[ "$nb_resp_" =~ $nl ]] && [[ "$nb_resp_" == *'INTEGER'* ]]; then
       echo "$nb_resp_" | grep -Po '^[0-9]+$'
   else
        echo 0   
   fi
}


replaceInFileBeforeProcess(){
 process_name=$1
 file=$2
 start_time=$(date)
 to_replace=$(awk -v pat="${process_name}" '$0~pat' ${file})
 actual_value=$(awk -v pat="${process_name}" '$0~pat' ${file} | awk -F ';' '{print $3}')
 echo "actual date begin : $actual_value"
 if [ -z "$actual_value" ]; then
  replace_by=$(awk -v pat="${process_name}" '$0~pat' ${file} |  awk 'BEGIN{FS=OFS=";"} {sub($3, st, $3)} 1' st="${start_time}")
  echo "REPLACE BY : $replace_by"
  sed -i "s/$to_replace/$replace_by/" ${file}
 else
   actual_value=$(awk -v pat="${process_name}" '$0~pat' ${file} | awk -F ';' '{print $2}')
   echo "actual val : $actual_value"
   new_val=$((actual_value+1))
   echo "new_val : $new_val"
   replace_by=$(awk -v pat="${process_name}" '$0~pat' ${file} | awk 'BEGIN{FS=OFS=";"} {sub($2, nv, $2)} 1' nv="${new_val}")
   sed -i "s/$to_replace/$replace_by/" ${file}
 fi
}

replaceInFileAfterProcess(){
 process_name=$1
 file=$2
 end_time=$(date)
 to_replace=$(awk -v pat="${process_name}" '$0~pat' ${file})
 actual_value=$(awk -v pat="${process_name}" '$0~pat' ${file} | awk -F ';' '{print $4}')
 replace_by=$(awk -v pat="${process_name}" '$0~pat' ${file} | awk 'BEGIN{FS=OFS=";"} {sub($4, nv, $4)} 1' nv="${end_time}")
 sed -i "s/$to_replace/$replace_by/" ${file}
}

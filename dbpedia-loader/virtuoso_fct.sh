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
   re='^[0-9]+$'
   resp=$1;
   nb_resp_=$resp;
   if ! [[ $nb_resp_ =~ $re ]] ; then
       nb_resp_=$(echo $resp | awk '{print $4}')
   fi       
   if ! [[ $nb_resp_ =~ $re ]] ; then
        nb_resp_=$(echo $resp |  awk '{print $5}')
   fi
   if ! [[ $nb_resp_ =~ $re ]] ; then
        nb_resp_=$(echo $resp | grep -o -P '(?<=_\s)\d*(?=\s)');
   fi
   if ! [[ $nb_resp_ =~ $re ]] ; then
        nb_resp_=$(echo $resp | grep -o -P '(?<=\n\s)\d*(?=\n\s)');
   fi
   if ! [[ $nb =~ $re ]] ; then
     echo "$resp";
   fi
   echo "$nb_resp_";
}

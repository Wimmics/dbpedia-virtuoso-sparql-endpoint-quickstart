#!/usr/bin/env bash

wikidata_files=`ls ${DATA_DIR}/lastUpdate/dbpedia_wikidata_*`
today=$(date +'%m_%d_%Y')

for file in $wikidata_files
do
   echo $file
   filename=$(basename -- "$file")
   extension="${filename##*.}"
   filename2="${filename%.*}"
   if [[ "$extension" ==  'gz' ]]; then
      filename3="${filename%.*.*}"
      cp $file ${DATA_DIR}/lastUpdate/derived_data/${filename3}_bfr_pfx_rnm.ttl.gz
      gunzip -d ${file}
   elif [[ "$extension" ==  'bz2' ]]; then
      filename3="${filename%.*.*}"
      cp $file ${DATA_DIR}/lastUpdate/derived_data/${filename3}_bfr_pfx_rnm.ttl.bz2
      bzip2 -d ${file}
   else   
      cp $file ${DATA_DIR}/lastUpdate/derived_data/${filename2}_bfr_pfx_rnm.ttl
      filename2=$filename
   fi
   
   sed -i -e 's/dbpedia-wikidata:Q/wikidata:Q/g' ${DATA_DIR}/lastUpdate/${filename2}
   sed -i -e 's/<http:\/\/wikidata\.dbpedia\.org\/resource\/Q/wikidata:Q/g' ${DATA_DIR}/lastUpdate/${filename2}
   sed -i -e 's,\(wikidata:Q[0-9]*\)>,\1,g' ${DATA_DIR}/lastUpdate/${filename2}
   #sed -i -e 's/@base < ./@base <> ./'  ${DATA_DIR}/lastUpdate/${filename2}
   sed -i  '2i\# Revised by Wimmics at '$today' - change of wikiprefix' test2
   ${DATA_DIR}/lastUpdate/${filename2}
   bzip2 ${filename2}
   echo "end of replacements in file" 
done

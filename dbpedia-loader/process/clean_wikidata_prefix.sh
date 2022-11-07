#!/usr/bin/env bash

wikidata_files=`ls ${DATA_DIR}/lastUpdate/dbpedia_wikidata_*`
for file in $wikidata_files
do
   cp $file ${DATA_DIR}/lastUpdate/derived_data/
   filename=$(basename -- "$file")
   extension="${filename##*.}"
   if [[ "$extension" ==  'gz' ]]; then
      gunzip -d ${file}
      filename2="${filename%.*}"
   else
      filename2=$filename
   fi
   sed -i -e 's/dbpedia-wikidata:Q/wikidata:Q/g' ${filename2}
   sed -i -e 's/<http:\/\/wikidata\.dbpedia\.org\/resource\/Q/wikidata:Q/g' ${filename2}
   gzip  -f ${filename2}
     
done

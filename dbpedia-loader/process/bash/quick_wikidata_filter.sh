#!/usr/bin/env bash

wikidata_files=`ls ${DATA_DIR}/lastUpdate/dbpedia_wikidata_*`
for file in $wikidata_files
do
   echo $file
   cp --backup=numbered $file ${DATA_DIR}/lastUpdate/derived_data/
   filename=$(basename -- "$file")
   extension="${filename##*.}"
   if [[ "$extension" ==  'gz' ]]; then
      gunzip -d ${file}
      filename2="${filename%.*}"
   if [[ "$extension" ==  'bz2' ]]; then
      bzip2 -d ${file}
      filename2="${filename%.*}"
   else
      filename2=$filename
   fi
   echo $filename2
   awk '!/wikidata:/' $filename2
   bzip2 ${filename2}
   echo "end of replacements in file"
     
done

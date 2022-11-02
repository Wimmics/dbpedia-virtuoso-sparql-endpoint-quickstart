#!/usr/bin/env bash
## UNZIP FILE WITH WIKILABELS
wiki_labels_file_base=($(find  ${DATA_DIR}/lastUpdate/ -maxdepth 1 -name 'dbpedia_wikidata_labels*'))
gunzip -d ${wiki_labels_file_base}
wiki_labels_file_2=($(find  ${DATA_DIR}/lastUpdate/   find . -maxdepth 1 -name 'dbpedia_wikidata_labels*.ttl' ))
awk '/@fr ./' ${wiki_labels_file_2} >> ${DATA_DIR}/lastUpdate/dbpedia_wikidata_labels_corrected_onlyfrench.ttl

mkdir ${DATA_DIR}/lastUpdate/derived_data
mv ${wiki_labels_file_2} ${DATA_DIR}/lastUpdate/derived_data/
wiki_labels_file_used=($(find  ${DATA_DIR}/lastUpdate/derived_data/ -maxdepth 1 -name 'dbpedia_wikidata_labels*'))
sudo gzip  -f ${wiki_labels_file_used}
## ZIP FILES

sudo gzip  -f '${DATA_DIR}/lastUpdate/computed_dumps/dbpedia_wikidata_labels_corrected_onlyfrench.ttl'

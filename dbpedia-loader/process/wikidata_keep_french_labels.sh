#!/usr/bin/env bash
## UNZIP FILE WITH WIKILABELS
wiki_labels_file_base=($(find  ${STORE_DATA_DIR} -maxdepth 1 -name 'dbpedia_wikidata_labels*'))
gunzip -d ${wiki_labels_file}
wiki_labels_file_2=($(find  ${STORE_DATA_DIR}  find . -maxdepth 1 -name 'dbpedia_wikidata_labels*.ttl' ))
sudo awk '/@fr/' ${wiki_labels_file_2} >> '${STORE_DATA_DIR}/dbpedia_wikidata_labels_corrected_onlyfrench.ttl'

mkdir '${STORE_DATA_DIR}/derived_data'
mv ${wiki_labels_file} '${STORE_DATA_DIR}/derived_data/'
wiki_labels_file_used=($(find  '${STORE_DATA_DIR}/derived_data/' -maxdepth 1 -name 'dbpedia_wikidata_labels*'))
sudo gzip  -f ${wiki_labels_file_used}
## ZIP FILES

sudo gzip  -f '${STORE_DATA_DIR}/computed_dumps/dbpedia_wikidata_labels_corrected_onlyfrench.ttl'

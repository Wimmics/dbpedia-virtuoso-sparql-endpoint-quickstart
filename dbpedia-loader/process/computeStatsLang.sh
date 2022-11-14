#!/usr/bin/env bash

. ../virtuoso_fct.sh --source-only

cd $DATA_DIR
mkdir -p computed_stats
cd ${DATA_DIR}/computed_stats
mkdir dbpedia_dumps_lang_fr_related
rm -f ./dbpedia_dumps_lang_fr_related/*

### MAYBE CHANGE IT FROM FILE USE IN LOADING
query=$(curl -k -H "Accept:text/sparql" https://databus.dbpedia.org/cringwald/collections/dbpediabylang)
files=$(curl -k -H "Accept: text/csv" --data-urlencode "query=${query}" https://databus.dbpedia.org/repo/sparql | tail -n+2 | sed 's/"//g')
while IFS= read -r file ; do wget --no-check-certificate -P ./dbpedia_dumps_lang_fr_related $file; done <<< "$files"


date=$(date '+%Y-%m-%d')
title="cross_wiki_stats_of_Fr_${date}.csv"
rm -f "./${title}"

echo "lang;nb_pages;page_in_Fr" > "./${title}"

pat2='page_lang=(\w*)_ids'
FILES="./dbpedia_dumps_lang_fr_related/*"
nb_fr=0
declare -A dict_lang_values
for f in $FILES
do
  echo "Processing $f files..."
  if [[ $f =~ $pat2 ]]; then
  	lang="${BASH_REMATCH[1]}";
  	Lang="${lang[@]^}"
  	nb=$( bzcat $f | wc -l );
    
	if [[ lang == "fr" ]]; then
    	   nb_in_fr=$nb
    	   nb_fr=$nb
        else
	   resp_base=$(run_virtuoso_cmd "SPARQL PREFIX oa: <http://www.w3.org/ns/oa#> \
	    PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
            SELECT count(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> \
	    WHERE {?s oa:hasTarget tag-fr:${Lang}FrResource};");
	   nb_in_fr=$(get_answer_nb "${resp_base}");
  	fi
    echo "${lang};${nb};${nb_in_fr}" >> "./${title}"
  fi;
done

#resp_base=$(run_virtuoso_cmd "SPARQL SELECT count(DISTINCT ?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s ?p ?o};");
#nb_wikidata=$(get_answer_nb "$resp_base");
#resp_base2=$(run_virtuoso_cmd "SPARQL SELECT count(DISTINCT ?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s ?p dbo:WdtFrResource};");
#nb_wikidata_fr=$(get_answer_nb "$resp_base2");

#echo "wikidata;${nb_wikidata};${nb_wikidata_fr}" >> "./${title}"
rm -rf ./dbpedia_dumps_lang_fr_related/

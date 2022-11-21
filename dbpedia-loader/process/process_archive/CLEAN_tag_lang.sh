#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============ CLEAN TAG LANG "
################### SPARQL - GET LANG LIST
resp=$(run_virtuoso_cmd "SPARQL SELECT DISTINCT CONCAT('lang_',?lang) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> where { ?s rdfs:label ?o. BIND (lang(?o) AS ?lang) };";);
echo $resp;
lang_list=$(echo $resp | tr " " "\n" | grep -oP "lang_\K(.*)");

for lang in ${lang_list[@]}; do
	if [[ $lang != 'fr' ]]; then
		echo "============>>>>>>>>>> $lang need to be treaten"; 

		Lang="${lang[@]^}"
		resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?S) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
	        ?S a dbo:${Lang}FrResource };") 
	    
	    nb_todelete=$(get_answer_nb "$resp_count");
	    while [ "$nb_todelete" -ne 0 ]
	    do
	      echo "TO DELETE : $nb_todelete";
	      
	      resp_delete=$(run_virtuoso_cmd "SPARQL  DEFINE sql:log-enable 2 \
	       PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
	       PREFIX oa: <http://www.w3.org/ns/oa#> \
	       WITH <http://fr.dbpedia.org/graph/dbpedia_generic_labels> \
	       DELETE { ?s a dbo:${Lang}FrResource. } \
               INSERT { tag-fr:${Lang}FrResource oa:hasTarget ?s . } \
               WHERE { \
	       SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { ?s a dbo:${Lang}FrResource. } LIMIT $limit \
	       };")
	      
	      resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?S) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
	        ?S a dbo:${Lang}FrResource };") 
	      
	      nb_todelete=$(get_answer_nb "$resp_count");
    	done

	fi
done

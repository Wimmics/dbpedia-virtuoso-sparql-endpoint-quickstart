#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;
################### SPARQL - GET LANG LIST
resp=$(run_virtuoso_cmd "SPARQL SELECT DISTINCT CONCAT('lang_',?lang) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> where { ?s rdfs:label ?o. BIND (lang(?o) AS ?lang) };";);
echo $resp;
lang_list=$(echo $resp | tr " " "\n" | grep -oP "lang_\K(.*)");
echo "============>>>>>>>>>> DELETE NOT USED LABELS BY LANG Version november"; 
for lang in ${lang_list[@]}; do
  if [[ $lang != 'fr' ]]; then

    Lang="${lang[@]^}"
    echo "============>>>>>>>>>> $lang"
    
    resp_count=$(run_virtuoso_cmd "SPARQL PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
    PREFIX oa: <http://www.w3.org/ns/oa#> \
    SELECT COUNT(?S) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
    ?S ?p ?o . FILTER NOT EXISTS { tag-fr:${Lang}FrResource oa:hasTarget ?S } };") 
    
    nb_todelete=$(get_answer_nb "$resp_count");
    while [ "$nb_todelete" -ne 0 ]
    do
      echo "TO DELETE : $nb_todelete";
      
      resp_delete=$(run_virtuoso_cmd "SPARQL  DEFINE sql:log-enable 2 \
       PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
       PREFIX oa: <http://www.w3.org/ns/oa#> \
       WITH <http://fr.dbpedia.org/graph/dbpedia_generic_labels> \
       DELETE { ?S <http://www.w3.org/2000/01/rdf-schema#label> ?o. }  WHERE { \
      SELECT ?S ?o FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE {\
      ?S <http://www.w3.org/2000/01/rdf-schema#label> ?o .\
      FILTER NOT EXISTS { tag-fr:${Lang}FrResource oa:hasTarget ?S  } }  LIMIT $limit };")
      
      resp_count=$(run_virtuoso_cmd "SPARQL PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
      PREFIX oa: <http://www.w3.org/ns/oa#> \
      7SELECT COUNT(?S) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
      ?S ?p ?o . FILTER NOT EXISTS { tag-fr:${Lang}FrResource oa:hasTarget ?S };") 
      
      nb_todelete=$(get_answer_nb "$resp_count");
    done
  fi
done

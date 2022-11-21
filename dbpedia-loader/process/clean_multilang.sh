#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

resp_count=$(run_virtuoso_cmd "SPARQL PREFIX oa: <http://www.w3.org/ns/oa#> \
SELECT COUNT(?S) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
?S <http://www.w3.org/2000/01/rdf-schema#label> ?o . FILTER NOT EXISTS { ?t oa:hasTarget ?S }. FILTER(lang(?o) != 'fr') };") 

nb_todelete=$(get_answer_nb "$resp_count");
while [ "$nb_todelete" -ne 0 ]
do
  echo "TO DELETE : $nb_todelete";

  resp_delete=$(run_virtuoso_cmd "SPARQL  DEFINE sql:log-enable 2 \
   PREFIX oa: <http://www.w3.org/ns/oa#> \
   WITH <http://fr.dbpedia.org/graph/dbpedia_generic_labels> \
   DELETE { ?S <http://www.w3.org/2000/01/rdf-schema#label> ?o. }  WHERE { \
  SELECT ?S ?o FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
  ?S <http://www.w3.org/2000/01/rdf-schema#label> ?o . \
  FILTER NOT EXISTS { ?t oa:hasTarget ?S  }. FILTER(lang(?o) != 'fr')  }  LIMIT $limit };")

  resp_count=$(run_virtuoso_cmd "SPARQL PREFIX oa: <http://www.w3.org/ns/oa#> \
  SELECT COUNT(?S) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
  ?S <http://www.w3.org/2000/01/rdf-schema#label> ?o . FILTER NOT EXISTS { ?t oa:hasTarget ?S }. FILTER(lang(?o) != 'fr') };")

  nb_todelete=$(get_answer_nb "$resp_count");
done
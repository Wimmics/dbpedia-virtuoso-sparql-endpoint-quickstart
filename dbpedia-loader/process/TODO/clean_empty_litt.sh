#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only


limit=500000;

resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?S) WHERE { \
?s ?p ?o. FILTER (datatype(?o) = xsd:string). FILTER(?o="")};") 

nb_todelete=$(get_answer_nb "$resp_count");
while [ "$nb_todelete" -ne 0 ]
do
  echo "TO DELETE : $nb_todelete";

  resp_delete=$(run_virtuoso_cmd "SPARQL  DEFINE sql:log-enable 2 \
   WITH <http://fr.dbpedia.org/graph/dbpedia_generic_labels> \
   DELETE { ?s ?p ?o. }  WHERE { \
  ?s ?p ?o. FILTER (datatype(?o) = xsd:string). FILTER(?o="") }  LIMIT $limit };")

  resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?S) WHERE { \
  ?s ?p ?o. FILTER (datatype(?o) = xsd:string). FILTER(?o="")};") 

  nb_todelete=$(get_answer_nb "$resp_count");
done

#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============>>>> EXPORT TAG TO SAME AS - Version November"
count=0;
nb_global=1;
last=0;
while [ "$nb_global" -ne "$last" ]
do
    echo "NEW LOOP $nb_global not equals to  $last" ;
    last=$nb_global;  
    
    resp2=$(run_virtuoso_cmd "SPARQL  \
    DEFINE sql:log-enable 2 \
    PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
    PREFIX oa: <http://www.w3.org/ns/oa#> \
    INSERT { GRAPH  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis>  { tag-fr:WdtHaveFrLabel oa:hasTarget ?s.} } \
    WHERE { \
    SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
        WHERE {  ?s ?p2 ?o2. MINUS {  \
              SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
               tag-fr:WdtHaveFrLabel oa:hasTarget ?s \
              }  \
       } } LIMIT $limit };");
       
    resp_count=$(run_virtuoso_cmd "SPARQL 
    PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
    PREFIX oa: <http://www.w3.org/ns/oa#> \
    SELECT COUNT(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
     WHERE {  tag-fr:WdtHaveFrLabel oa:hasTarget ?s };");         
    nb_global=$(get_answer_nb "$resp_count");
done

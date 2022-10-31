#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============>>>> EXPORT TAG TO SAME AS"
count=0;
nb_global=1;
last=0;
while [ "$nb_global" -ne "$last" ]
do
    echo "NEW LOOP $nb_global not equals to  $last" ;
    last=$nb_global;	
    resp2=$(run_virtuoso_cmd "SPARQL  \
    DEFINE sql:log-enable 2 \
    WITH <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
    INSERT { ?s rdf:type dbo:WdtHaveFrLabel. } \
    WHERE { \
    SELECT DISTINCT ?s WHERE \
    { \
    ?s ?p ?o. FILTER NOT EXISTS { ?s rdf:type ?t}. \
    { \
       SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
       WHERE {  ?s ?p ?o }  \
    } \
    } LIMIT $limit };");
    resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
     WHERE { ?s rdf:type dbo:WdtHaveFrLabel };");         
    nb_global=$(get_answer_nb "$resp_count");
done

#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============>>>> FIRST FLAG frLabels Version BIS"
count=0;
nb_global=1;
last=0;
while [ "$nb_global" -ne "$last" ]
do
    echo "NEW LOOP $nb_global not equals to  $last" ;
    last=$nb_global;	
    resp2=$(run_virtuoso_cmd "SPARQL \
    DEFINE sql:log-enable 2 \
    WITH <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
    INSERT { ?s rdf:type dbo:WdtHaveFrLabel. } \
    WHERE { \
      ?s ?p2 ?o2. \
      FILTER NOT EXISTS { ?s rdf:type ?t}. \
      { \
        SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> WHERE { \
        ?s ?p ?o . FILTER (lang(?o)= 'fr') \
      } \
    } \
    LIMIT $limit \
    };");
    resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
     WHERE { ?s rdf:type dbo:WdtHaveFrLabel };");         
    nb_global=$(get_answer_nb "$resp_count");
done

#!/usr/bin/env bash

. ../virtuoso_fct.sh --source-only
pat_meta='metadata'
pat_onto='ontology'

##### SPACIAL WIKIDATA STATS w
declare -a graph_list_wikidata=("http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals" "http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned")
for graph in ${graph_list_wikidata[@]}; do

   ################### SPARQL - CLASS PARTITION - CREATE PARTITION BY CLASS
    run_virtuoso_cmd "    SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
    PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
    PREFIX oa: <http://www.w3.org/ns/oa#> \
    INSERT INTO <${DOMAIN}/graph/statistics> \
    { <$graph> void:classPartition [ void:class tag-fr:WdtFrResource ; void:classPartition [ void:class ?c] ]. } \
    WHERE { SELECT DISTINCT(?c) FROM <$graph> { ?s ?p ?o. \
    { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
    WHERE {  tag-fr:WdtFrResource oa:hasTarget ?s } }. \
    { SELECT ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> \
    WHERE { ?s a ?c } } }};"
    
done
echo ">>>>>>>>> END NAMED GRAPH STATS COMPUTATION"

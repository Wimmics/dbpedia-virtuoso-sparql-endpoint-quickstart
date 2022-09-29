
#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

cd ${DATA_DIR}/lastUpdate
mkdir -p computed_dumps
cd ${DATA_DIR}/lastUpdate/computed_dumps
echo ">>>>>>> DUMP METADATA"
run_virtuoso_cmd "dump_one_graph_no_limits ('http://fr.dbpedia.org/graph/metadata', '${STORE_DATA_DIR}/computed_dump/metadata_computed');"
echo ">>>>>>> DUMP LABELS" 
run_virtuoso_cmd "dump_one_graph_no_limits ('http://fr.dbpedia.org/graph/dbpedia_generic_labels', '${STORE_DATA_DIR}/lastUpdate/computed_dumps/dbpedia_generic_labels_corrected');"
echo ">>>>>>> DUMP GEOCORRECTED" 
run_virtuoso_cmd "dump_one_graph_no_limits ('http://fr.dbpedia.org/graph/dbpedia_generic_geo-coordinates', '${STORE_DATA_DIR}/computed_dumps/dbpedia_generic_geo-coordinates_corrected');"

################### SPARQL - GET ALL NAMED WIKIDATA GRAPH
get_named_graph='SPARQL SELECT ?o FROM <http://fr.dbpedia.org/graph/metadata> WHERE { ?s sd:namedGraph ?o. FILTER( STRSTARTS(STR(?o), "http://fr.dbpedia.org/graph/dbpedia_wikidata_") ) };'
resp=$(run_virtuoso_cmd "$get_named_graph");
graph_list=$(echo $resp | tr " " "\n" | grep -E "\/graph\/");
for graph in ${graph_list[@]}; do
    fn=$(echo "$graph" | grep -Po '(?<=\/graph\/)(.*)')
    echo ">> DUMP $graph to > $fn"
    run_virtuoso_cmd "dump_one_graph_no_limits ('$graph', '${STORE_DATA_DIR}/lastUpdate/computed_dumps/${fn}_corrected');"
done





 	

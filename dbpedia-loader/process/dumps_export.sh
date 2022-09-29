
#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

cd ${DATA_DIR}/lastUpdate
mkdir -p computed_dumps
cd ${DATA_DIR}/lastUpdate/computed_dumps
#echo ">>>>>>> DUMP METADATA"
#run_virtuoso_cmd "dump_one_graph ('http://fr.dbpedia.org/graph/metadata', '${STORE_DATA_DIR}/computed_dump/metadata_computed_', 1000000000000000);"
echo ">>>>>>> DUMP LABELS" 
run_virtuoso_cmd "dump_one_graph_no_limits ('http://fr.dbpedia.org/graph/dbpedia_generic_labels', '${STORE_DATA_DIR}/lastUpdate/computed_dumps/labels_corrected');"
#echo ">>>>>>> DUMP GEOCORRECTED" 
#run_virtuoso_cmd "dump_one_graph_no_limits ('http://fr.dbpedia.org/graph/dbpedia_generic_labels', '${STORE_DATA_DIR}/computed_dumps/labels_corrected');"

################### SPARQL - GET ALL NAMED WIKIDATA GRAPH
get_named_graph='SPARQL SELECT ?o FROM <http://fr.dbpedia.org/graph/metadata> WHERE { ?s sd:namedGraph ?o. FILTER( ?o != <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> AND ?o != <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links> AND STRSTARTS(STR(?o), "http://fr.dbpedia.org/graph/dbpedia_wikidata_") ) };'
resp=$(run_virtuoso_cmd "$get_named_graph");
graph_list=$(echo $resp | tr " " "\n" | grep -E "\/graph\/");
for graph in ${graph_list[@]}; do
    fn = echo "$graph" | grep -Po '\/graph\/(.*)'
    echo ">> DUMP $graph"
    run_virtuoso_cmd "dump_one_graph_no_limits ('$graph', '${STORE_DATA_DIR}/lastUpdate/computed_dumps/${fn}_corrected');"
done
#echo ">>>>>>> DUMP WIKIDATA SUBCLASS OF" 
#run_virtuoso_cmd "dump_one_graph ('http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals', '${STORE_DATA_DIR}/computed_dumps/wikidata-subclassof_computed_', 1000000000000000);"
#echo ">>>>>>> DUMP WIKIDATA GEOCOORD" 
#run_virtuoso_cmd "dump_one_graph ('http://fr.dbpedia.org/graph/dbpedia_wikidata_geo-coordinates', '${STORE_DATA_DIR}/computed_dumps/wikidata-geocoord_computed_', 1000000000000000);"
#echo ">>>>>>> DUMP WIKIDATA LINKS EXTERNAL" 
#run_virtuoso_cmd "dump_one_graph ('http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-external', '${STORE_DATA_DIR}/computed_dumps/wikidata-links-external_computed_', 1000000000000000);"
#echo ">>>>>>> DUMP WIKIDATA LINKS SAME AS" 
#run_virtuoso_cmd "dump_one_graph ('http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis', '${STORE_DATA_DIR}/computed_dumps/wikidata-links-sameas_computed_', 1000000000000000);"
#echo ">>>>>>> DUMP WIKIDATA Mapped Obj" 
#run_virtuoso_cmd "dump_one_graph ('http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned', '${STORE_DATA_DIR}/computed_dumps/wikidata-mapped-obj_computed_', 1000000000000000);"




 	

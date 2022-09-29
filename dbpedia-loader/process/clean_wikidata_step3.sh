. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============>>>> DELETE USELESS WIKIDATA IN FLAGED GRAPHS 5"
nb_todo1=1;
while [ "$nb_todo1" -ne 0 ]
do
	resp_delete1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	    WITH  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
	    DELETE {?s ?p2 ?o2.} WHERE { \
	    ?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };");
	resp_todo1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
	?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };" );
	nb_todo1=$(get_answer_nb "$resp_todo1");
	echo "sameas-all-wikis need to delete objects : $nb_todo1";
done
echo "----- wikidata_labels"
nb_todo2=1;
while [ "$nb_todo2" -ne 0 ]
do
	resp_delete2=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	    WITH  <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
	    DELETE {?s ?p2 ?o2.} WHERE { \
	    ?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };");
	resp_todo2=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> WHERE { \
	?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };" );
	nb_todo2=$(get_answer_nb "$resp_todo2");
	echo "wikidata_labels need to delete object : $nb_todo2";
done

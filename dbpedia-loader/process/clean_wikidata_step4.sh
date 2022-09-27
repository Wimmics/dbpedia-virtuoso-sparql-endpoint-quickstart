. ../virtuoso_fct.sh --source-only

limit=500000;
echo "============>>>> DELETE ALL THE TAGS"
echo "----- sameas-all-wikis"
nb_todo2=1;
while [ "$nb_todo2" -ne 0 ]
do
	resp_delete2=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	    SPARQL WITH <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
	    DELETE { ?s a ?t. } WHERE { \
	    ?s a ?t };");
	resp_todo2=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	SPARQL SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
	?s a ?t };" );
	nb_todo2=$(get_answer_nb "$resp_todo2");
	echo "sameas-all-wikis need to change objects : $nb_todo2";
done
echo "----- wikidata_labels"
nb_todo2=1;
while [ "$nb_todo2" -ne 0 ]
do
	resp_delete2=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	    SPARQL WITH <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
	    DELETE { ?s a ?t. } WHERE { \
	    ?s a ?t };");
	resp_todo2=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	SPARQL SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> WHERE { \
	?s a ?t };" );
	nb_todo2=$(get_answer_nb "$resp_todo2");
	echo "wikidata_labels need to change objects : $nb_todo2";
done

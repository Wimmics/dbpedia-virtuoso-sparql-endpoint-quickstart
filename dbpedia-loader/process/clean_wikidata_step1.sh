. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============>>>> DELETE WIKIDATA WITHOUT TAG"
nb_todo1=1;
while [ "$nb_todo1" -ne 0 ]
do
	resp_delete1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
            PREFIX oa: <http://www.w3.org/ns/oa#> \
	    WITH  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
	    DELETE {?s ?p2 ?o2.} WHERE { \
	    SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis>  WHERE { \
	    ?s owl:sameAs ?o2. FILTER NOT EXISTS {  ?t oa:hasTarget ?s. } } LIMIT $limit };");
	resp_todo1=$(run_virtuoso_cmd "SPARQL \
            PREFIX oa: <http://www.w3.org/ns/oa#> \
	SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
	?s owl:sameAs ?o2. FILTER NOT EXISTS { ?t oa:hasTarget ?s. } };" );
	nb_todo1=$(get_answer_nb "$resp_todo1");
	echo "sameas-all-wikis need to delete objects : $nb_todo1";
done



echo "============>>>> DELETE USELESS WIKIDATA IN OTHER NAMED GRAPHS"
get_named_graph='SPARQL SELECT ?o FROM <http://fr.dbpedia.org/graph/metadata> WHERE { ?s sd:namedGraph ?o. FILTER( ?o != <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> AND  ?o != <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> AND ?o != <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links> AND STRSTARTS(STR(?o), "http://fr.dbpedia.org/graph/dbpedia_wikidata_") ) };'
resp=$(run_virtuoso_cmd "$get_named_graph");
graph_list=$(echo $resp | tr " " "\n" | grep -E "\/graph\/");
for graph in ${graph_list[@]}; do
        nb_todo0=1;
        while [ "$nb_todo0" -ne 0 ]
        do
		resp_delete=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
			WITH <$graph>  DELETE { ?s ?p ?o. } WHERE {  \
			    ?s ?p ?o. \
			    { \
				SELECT  ?s ?p1 ?o1 FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels>  WHERE { \
				    ?s ?p1 ?o1. FILTER NOT EXISTS { ?s rdf:type dbo:WdtHaveFrLabel } \
				} \
			    }.{ \
				SELECT  ?s ?p2 ?o2 FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
				    ?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} \
				}  \
			    } \
			} LIMIT $limit;" );
		
		resp_todo0=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
			SELECT COUNT(?s) FROM <$graph> WHERE {  \
			    ?s ?p ?o. \
			    { \
			    SELECT  ?s ?p1 ?o1 FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels>  WHERE { \
				?s ?p1 ?o1. FILTER NOT EXISTS { ?s rdf:type dbo:WdtHaveFrLabel } \
			    } \
			    }.{ \
			    SELECT  ?s ?p2 ?o2 FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
				?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} \
			    }  \
			    } \
			} LIMIT $limit;" );
			
		nb_todo0=$(get_answer_nb "$resp_todo0");
		echo "$graph need to change objects : $nb_todo0";
	done
done


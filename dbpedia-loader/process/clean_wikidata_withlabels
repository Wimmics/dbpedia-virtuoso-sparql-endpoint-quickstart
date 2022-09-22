#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============>>>> FIRST FLAG frLabels"
count=0;
nb_global=1;
last=0;
while [ "$nb_global" -ne "$last" ]
do
    echo "NEW LOOP $nb_global not equals to  $last" ;
    last=$nb_global;	
    resp2=$(run_virtuoso_cmd "SPARQL \
    DEFINE sql:log-enable 2 \
    WITH <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
    INSERT { ?s rdf:type dbo:WdtHaveFrLabel. } \
    WHERE { \
     SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
     WHERE { ?s ?p ?o. FILTER (lang(?o)= 'fr').  FILTER NOT EXISTS { ?s rdf:type dbo:WdtHaveFrLabel }} LIMIT $limit \
    };");
    resp_count=$(run_virtuoso_cmd "SPARQL SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
     WHERE { ?s ?p ?o. FILTER (lang(?o)= 'fr').  FILTER NOT EXISTS { ?s rdf:type dbo:WdtHaveFrLabel }};)");         
    nb_global=$(get_answer_nb "$resp_count");
done

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


echo "============>>>> DELETE USELESS WIKIDATA IN FLAGED GRAPHS"
nb_todo1=1;
while [ "$nb_todo1" -ne 0 ]
do
	resp_delete1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	    SPARQL WITH  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
	    DELETE {?s ?p2 ?o2.} WHERE {\
	    ?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };");
	resp_todo1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	SPARQL SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {\
	?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };" );
	nb_todo1=$(get_answer_nb "$resp_todo1");
	echo "sameas-all-wikis need to delete objects : $nb_todo1";
done
echo "----- wikidata_labels"
nb_todo1=1;
while [ "$nb_todo2" -ne 0 ]
do
	resp_delete1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	    SPARQL WITH  <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> \
	    DELETE {?s ?p2 ?o2.} WHERE {\
	    ?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };");
	resp_todo1=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
	SPARQL SELECT COUNT(?s) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_labels> WHERE {\
	?s ?p2 ?o2. FILTER NOT EXISTS { ?s rdf:type ?t} };" );
	nb_todo1=$(get_answer_nb "$resp_todo1");
	echo "wikidata_labels need to delete object : $nb_todo1";
done

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

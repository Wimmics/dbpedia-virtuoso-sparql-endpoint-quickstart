echo "############################################################# PROP LITT";
echo "################### SPARQL - Nb distinctSubjects ";
echo "## DBPEDIA FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-literals> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"

echo "## WIKIDATA ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_wikidata> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-lit_wikidata> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_wikidata> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"
  
echo "## DBPEDIA FR only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_only> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_only> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_only> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-literals> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
		    } \
	    } \
 	};"

echo "## WIKIDATA only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_wikidata_only> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-lit_wikidata_only> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_wikidata_only> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-literals>  \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
		    } \
	    } \
 	};"


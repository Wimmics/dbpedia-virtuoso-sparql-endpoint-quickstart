#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

echo "############################################################# PROP OBJ";
echo "################### SPARQL - Nb distinctSubjects ";
echo "## DBPEDIA FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"

echo "## WIKIDATA ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"
  
echo "## DBPEDIA FR only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
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
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:distinctSubjects ?no. \
	} WHERE { \
 		SELECT COUNT(DISTINCT(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned>  \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
		    } \
	    } \
 	};"

echo "################### SPARQL - Nb Triples ";
echo "## DBPEDIA FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:triples ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:triples ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:triples ?no. \
	} WHERE { \
 		SELECT COUNT(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"

echo "## WIKIDATA ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:triples ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:triples ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:triples ?no. \
	} WHERE { \
 		SELECT COUNT(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"
  
echo "## DBPEDIA FR only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:triples ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:triples ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:triples ?no. \
	} WHERE { \
 		SELECT COUNT(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
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
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:triples ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:triples ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:triples ?no. \
	} WHERE { \
 		SELECT COUNT(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned>  \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
		    } \
	    } \
 	};"
echo "################### SPARQL - Nb Properties ";
echo "## DBPEDIA FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:properties ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:properties ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:properties ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?p2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"

echo "## WIKIDATA ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:properties ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:properties ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:properties ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?p2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"
  
echo "## DBPEDIA FR only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:properties ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:properties ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:properties ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?p2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
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
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:properties ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:properties ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:properties ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?p2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned>  \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
		    } \
	    } \
 	};"

echo "################### SPARQL - Nb Distinct Objects ";
echo "## DBPEDIA FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:distinctObjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:distinctObjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr> void:distinctObjects ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?o2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"

echo "## WIKIDATA ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:distinctObjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:distinctObjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata> void:distinctObjects ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?o2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			} \
	    } \
 	};"
  
echo "## DBPEDIA FR only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:distinctObjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:distinctObjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_only> void:distinctObjects ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?o2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
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
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:distinctObjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:distinctObjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_wikidata_only> void:distinctObjects ?no. \
	} WHERE { \
 		SELECT COUNT( DISTINCT ?o2) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
	           	SELECT ?s ?p2 ?o2 \
	           	FROM NAMED  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
			}. \
			FILTER NOT EXISTS { \
				SELECT ?s ?p2 ?o2 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned>  \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o2 \
			      } \
				} \
		    } \
	    } \
 	};"



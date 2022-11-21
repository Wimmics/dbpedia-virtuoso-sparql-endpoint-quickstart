#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

echo "################### SPARQL - GLOBAL STATS - Nb distincts classes";
echo "## FR ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classes ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classes ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classes ?no. } \
	WHERE { \
 		SELECT count(distinct(?class)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

echo "## ONLY FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classes ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classes ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classes ?no. } \
	WHERE { \
 		SELECT count(distinct(?class)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class \
				} \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"


echo "################### SPARQL - Nb total triples";
echo "## FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:triples ?no. \
	} WHERE { \
		SELECT count(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

echo "## ONLY FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:triples ?no. \
	} WHERE { \
		SELECT count(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class \
				} \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

echo "################### SPARQL - CLASS PARTITION creation";
echo "## FR ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	    DELETE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
	    	?bn void:class ?c. \
	    } WHERE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
	      	?bn void:class ?c. \
	    	FILTER (isBlank(?bn)) \
	    };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
        INSERT INTO <${DOMAIN}/graph/statistics> { \
        	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition [ void:class ?class ]. \
        } WHERE { \
	        SELECT distinct(?class) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				{ \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
						?s a ?class \
					} \
				} \
			} \
        };"

echo "## ONLY FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	    DELETE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
	    	?bn void:class ?c. \
	    } WHERE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
	      	?bn void:class ?c. \
	    	FILTER (isBlank(?bn)) \
	    };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
        INSERT INTO <${DOMAIN}/graph/statistics> { \
        	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition [ void:class ?class ]. \
        } WHERE { \
	        SELECT distinct(?class) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				{ \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
						?s a ?class \
					} \
				}.FILTER NOT EXISTS { \
					SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
						?s a ?class \
					} \
				} \
			} \
        };"


echo "################### SPARQL - CLASS PARTITION - nb entities";
echo "## FR ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	WITH <${DOMAIN}/graph/statistics> \
	DELETE { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. \
	} WHERE { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. FILTER (isBlank(?bn)) \
	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
 	INSERT INTO <${DOMAIN}/graph/statistics> { \
 		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition [ void:class ?class ; void:entities ?count ].\
 	} WHERE { \
    SELECT ?class count(distinct(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"

echo "## FR only";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	WITH <${DOMAIN}/graph/statistics> \
	DELETE { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. \
	} WHERE { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. FILTER (isBlank(?bn)) \
	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
 	INSERT INTO <${DOMAIN}/graph/statistics> { \
 		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition [ void:class ?class ; void:entities ?count ].\
 	} WHERE { \
    SELECT ?class count(distinct(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
			} \
		}.FILTER NOT EXISTS { \
			SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"


echo "################### SPARQL - CLASS PARTITION - NB triples";
echo "## ONLY FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
         WITH <${DOMAIN}/graph/statistics> \
         DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
          ?bn void:class ?p. ?bn void:class ?c. ?bn void:triples ?x. } \
         WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. \
          FILTER (isBlank(?bn)) };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
    	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition [ \
    		void:class ?class ; \
    	 	void:triples ?count \
    	]. \
    } WHERE { \
    SELECT ?class count(?s) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
			} \
		}.FILTER NOT EXISTS { \
			SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"

echo "## ALL FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
         WITH <${DOMAIN}/graph/statistics> \
         DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
          ?bn void:class ?p. ?bn void:class ?c. ?bn void:triples ?x. } \
         WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. \
          FILTER (isBlank(?bn)) };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
    	<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition [ void:class ?class ; void:triples ?count ]. \
    } WHERE { \
    SELECT ?class count(?s) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"
echo "############################################################# PROP LITT";

echo "################### SPARQL - Nb distinctSubjects ";
echo "## FR ALL ";
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

echo "## FR only" 
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:distinctSubjects ?no. \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
 	};"



echo "################### SPARQL - Nb triples";
echo "## FR ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:triples ?no. \
	} WHERE { \
		SELECT COUNT(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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

echo "## FR pred only";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:triples ?no. \
	} WHERE { \
		SELECT COUNT(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
	};"


echo "################### SPARQL - Nb distinct prop";
echo "## FR ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:properties ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:properties ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:properties ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?p2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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

echo "## FR pred only ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:properties ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:properties ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:properties ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?p2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
	};"

echo "################### SPARQL - Nb distinct subj";
echo "## FR ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:distinctObjects ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:distinctObjects ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr> void:distinctObjects ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?o2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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

echo "## FR PRED ONLY";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:distinctObjects ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:distinctObjects ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-lit_dbpediafr_pred_only> void:distinctObjects ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?o2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
	};"


echo "############################################################# PROP MAPPED";

echo "################### SPARQL - Nb distinctSubjects";
echo "## FR ALL "

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

echo "## FR pred only"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	DELETE { <http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_pred_only> void:distinctSubjects ?no. \
 	} WHERE { \
 		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_pred_only> void:distinctSubjects ?no. \
 	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-obj_dbpediafr_pred_only> void:distinctSubjects ?no. \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
 	};"


echo "################### SPARQL - Nb triples"
echo "## FR ALL"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr> void:triples ?no. \
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

echo "## FR PRED ONLY"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:triples ?no. \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
	};"


echo "################### SPARQL - Nb distinct prop"

echo "# FR ALL"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr> void:properties ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr> void:properties ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr> void:properties ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?p2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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

echo "# FR only"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:properties ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:properties ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:properties ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?p2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
	};"

echo "################### SPARQL - Nb distinct obj"
echo "## FR all"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:distinctObjects ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:distinctObjects ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:distinctObjects ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?o2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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

echo "## FR only"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:distinctObjects ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:distinctObjects ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/prop-map_dbpediafr_only> void:distinctObjects ?no. \
	} WHERE { \
		SELECT COUNT(DISTINCT(?o2)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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
				SELECT ?s ?p2 ?o3 \
				FROM NAMED <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> \
				{ \
			      GRAPH ?g { \
			        ?s ?p2 ?o3 \
			      } \
				} \
		    } \
	    } \
	};"

echo "######################### PART CLASS AND PROP FOR FIRST LEVEL CLASS"

declare -a first_level_class=("dbo:Person" "dbo:Organisation" "dbo:Place" "dbo:Work" "dbo:Event")
for class in ${first_level_class[@]}; do

	echo "###################### LITT PROP"

	echo "## FR all"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr> void:classPartition [ \
				void:class ${class}; \
				void:propertyPartition [ \
					void:property ?p2; \
					void:triples ?nbtriple \
				] \
			] \
	    } WHERE { \
	    	SELECT ?p2 count(?s) as ?nbtriple FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				FILTER EXISTS { \
					SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types>  WHERE { \
						?s a ${class} \
					} \
				}.{ \
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-literals> { \
			        	?s ?p2 ?o2 \
			    	} \
		        } \
			} GROUP BY ?p2 \
		};"

	echo "## FR only"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr_only> void:classPartition [ \
				void:class ${class}; \
				void:propertyPartition [ \
					void:property ?p2; \
					void:triples ?nbtriple \
				] \
			] \
	    } WHERE { \
	    	SELECT ?p2 count(?s) as ?nbtriple FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				FILTER EXISTS { \
					SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types>  WHERE { \
						?s a ${class} \
					} \
				}.{ \
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-literals> { \
			        	?s ?p2 ?o2 \
			    	} \
				
		        }. FILTER EXISTS { \
		            SELECT ?s ?p2 ?o3 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> { \
			        	?s ?p2 ?o3 \
			      	} \
		        } \
			} GROUP BY ?p2 \
		};"

	echo "###################### OBJ PROP"
	echo "## FR all"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr> void:classPartition [ \
				void:class ${class}; \
				void:propertyPartition [ \
					void:property ?p2; \
					void:triples ?nbtriple \
				] \
			]. \
	    } WHERE { \
	    	SELECT ?p2 count(?s) as ?nbtriple FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				FILTER EXISTS { \
					SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types>  WHERE { \
						?s a ${class} \
					} \
				}.{ \
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			        	?s ?p2 ?o2 \
			    	} \
		        } \
			} GROUP BY ?p2 \
		};"

	echo "## FR only"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_dbpediafr_only> void:classPartition [ \
				void:class ${class}; \
				void:propertyPartition [ \
					void:property ?p2; \
					void:triples ?nbtriple \
				] \
			]. \
	    } WHERE { \
	    	SELECT ?p2 count(?s) as ?nbtriple FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				FILTER EXISTS { \
					SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types>  WHERE { \
						?s a ${class} \
					} \
				}.{ \
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			        	?s ?p2 ?o2 \
			    	} \
				
		        }. FILTER EXISTS { \
		            SELECT ?s ?p2 ?o3 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> { \
			        	?s ?p2 ?o3 \
			      	} \
		        } \
			} GROUP BY ?p2 \
		};"
done


####################### VALIDATED 

echo "############################################################# TYPES";
echo "################## NOT TYPED AS OWL:THING";
echo "## FR ALL X";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:NbNotThing ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:NbNotThing ?count. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:NbNotThing ?count. \
	} WHERE { \
		SELECT count(DISTINCT(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types>  WHERE { \
					?s a ?class. \
					FILTER(?class != dbo:Thing) \
				} \
			} \
		} \
	};"

echo "## FR only X"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> prop-fr:NbNotThing ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> prop-fr:NbNotThing ?count. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> prop-fr:NbNotThing ?count. \
	} WHERE { \
		SELECT count(DISTINCT(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class. \
					FILTER(?class != dbo:Thing) \
				} 		 \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				 ?s a ?class \
				} \
			} \
		} \
	};"

echo "################## LEVEL DISTRIB";
echo "## FR ALL X";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. ?bn void:entities ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. \
?bn void:entities ?count. \
FILTER (isBlank(?bn)) };"


run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:levelPartition [ prop-fr:level ?level; void:entities ?count ]. \
	} WHERE { \
		SELECT ?depth COUNT(?s) as ?count  FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
			?s a ?class. \
           { \
               select ?class (count(?mid)-1 as ?depth) FROM <http://fr.dbpedia.org/graph/dbpedia_ontology> WHERE { \
  				?class rdfs:subClassOf* ?mid. \
  				?mid rdfs:subClassOf* owl:Thing \
				} \
            } \
		} group by  ?depth \
	};"


echo "################### SPARQL - Nb distinct entities";
echo "## FR ALL X";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:entities ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:entities ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:entities ?no. \
	} WHERE { \
	 	SELECT count(distinct(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
				} \
			} \
		} \
 	};"

echo "## ONLY FR X";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:entities ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:entities ?no };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:entities ?no. \
	} WHERE { \
	 	SELECT count(distinct(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
				} \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
				} \
			} \
		} \
 	};"

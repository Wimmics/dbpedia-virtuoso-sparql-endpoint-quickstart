#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only
echo "################### SPARQL - CLASS PARTITION creation";
echo "## DBPEDIA FR ALL "
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

echo "## ONLY DBPEDIA FR";
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

echo "## WIKIDATA ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	    DELETE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition ?bn. \
	    	?bn void:class ?c. \
	    } WHERE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition ?bn. \
	      	?bn void:class ?c. \
	    	FILTER (isBlank(?bn)) \
	    };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
        INSERT INTO <${DOMAIN}/graph/statistics> { \
        	<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition [ void:class ?class ]. \
        } WHERE { \
	        SELECT distinct(?class) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
				?s ?p ?o. \
				{ \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
						?s a ?class \
					} \
				} \
			} \
        };"

echo "## ONLY WIKIDATA FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	    DELETE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition ?bn. \
	    	?bn void:class ?c. \
	    } WHERE { \
	    	<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition ?bn. \
	      	?bn void:class ?c. \
	    	FILTER (isBlank(?bn)) \
	    };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
        INSERT INTO <${DOMAIN}/graph/statistics> { \
        	<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition [ void:class ?class ]. \
        } WHERE { \
	        SELECT distinct(?class) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page>  WHERE { \
				?s ?p ?o. \
				{ \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
						?s a ?class \
					} \
				}.FILTER NOT EXISTS { \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance> WHERE { \
						?s a ?class \
					} \
				} \
			} \
        };"

echo "################### SPARQL - CLASS PARTITION - nb entities";
echo "## DBPEDIA FR ALL "
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

echo "## DBPEDIA FR only";
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

echo "#### WIKIDATA ALL";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	WITH <${DOMAIN}/graph/statistics> \
	DELETE { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. \
	} WHERE { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. FILTER (isBlank(?bn)) \
	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
 	INSERT INTO <${DOMAIN}/graph/statistics> { \
 		<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition [ void:class ?class ; void:entities ?count ].\
 	} WHERE { \
    SELECT ?class count(distinct(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"

echo "## WIKIDATA only";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	WITH <${DOMAIN}/graph/statistics> \
	DELETE { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. \
	} WHERE { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition ?bn. \
		?bn void:class ?class. ?bn void:entities ?count. FILTER (isBlank(?bn)) \
	};"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
 	INSERT INTO <${DOMAIN}/graph/statistics> { \
 		<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition [ void:class ?class ; void:entities ?count ].\
 	} WHERE { \
    SELECT ?class count(distinct(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
			} \
		}.FILTER NOT EXISTS { \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types>  WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"

echo "################### SPARQL - CLASS PARTITION - NB triples";
echo "## ALL DBPEDIA FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
         WITH <${DOMAIN}/graph/statistics> \
         DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. } \
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

echo "## ONLY DBPEDIA FR";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
         WITH <${DOMAIN}/graph/statistics> \
         DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. } \
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

echo "## ALL WIKIDATA";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
         WITH <${DOMAIN}/graph/statistics> \
         DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. } \
         WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. \
          FILTER (isBlank(?bn)) };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
    	<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classPartition [ void:class ?class ; void:triples ?count ]. \
    } WHERE { \
    SELECT ?class count(?s) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"

echo "## ONLY WIKIDATA";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
         WITH <${DOMAIN}/graph/statistics> \
         DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. } \
         WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition ?bn. \
          ?bn void:class ?c. ?bn void:triples ?x. \
          FILTER (isBlank(?bn)) };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
    	<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classPartition [ \
    		void:class ?class ; \
    	 	void:triples ?count \
    	]. \
    } WHERE { \
    SELECT ?class count(?s) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
		?s ?p ?o. \
		{ \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
			} \
		}.FILTER NOT EXISTS { \
			SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				?s a ?class \
			} \
		} \
		} GROUP BY ?class \
    };"

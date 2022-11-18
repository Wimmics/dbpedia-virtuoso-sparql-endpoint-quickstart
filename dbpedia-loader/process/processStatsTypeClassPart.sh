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
	        SELECT distinct(?class) FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s ?p ?o. \
				{ \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
						?s a ?class \
					} \
				}.FILTER NOT EXISTS { \
					SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
						?s a ?class \
					} \
				} \
			} \
        };"

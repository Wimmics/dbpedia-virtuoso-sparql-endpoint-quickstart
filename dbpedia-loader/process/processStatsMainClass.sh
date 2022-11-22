#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only
echo "######################### PART CLASS AND PROP FOR FIRST LEVEL CLASS"

declare -a first_level_class=("dbo:Person" "dbo:Organisation" "dbo:Place" "dbo:Work" "dbo:Event")
for class in ${first_level_class[@]}; do
	
	echo "###################### LITT PROP"

	echo "## DBPEDIA FR all"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_dbpediafr> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_dbpediafr> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_dbpediafr> void:classPartition [ \
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

	echo "#### WIKIDATA"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_wikidata> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_wikidata> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_wikidata> void:classPartition [ \
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
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> { \
			        	?s ?p2 ?o2 \
			    	} \
		        } \
			} GROUP BY ?p2 \
		};"

	echo "## DBPEDIAFR only"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_dbpediafr_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_dbpediafr_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_dbpediafr_only> void:classPartition [ \
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


	echo "## WIKIDATA only"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_wikidata_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_wikidata_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-lit_wikidata_only> void:classPartition [ \
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
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals> { \
			        	?s ?p2 ?o2 \
			    	} \
				
		        }. FILTER EXISTS { \
		            SELECT ?s ?p2 ?o3 FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-literals> { \
			        	?s ?p2 ?o3 \
			      	} \
		        } \
			} GROUP BY ?p2 \
		};"

	echo "###################### OBJ PROP"
	echo "## DBPEDIA FR all"

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

    echo "### WIKIDATA "
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_wikidata> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_wikidata> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_wikidata> void:classPartition [ \
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
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			        	?s ?p2 ?o2 \
			    	} \
		        } \
			} GROUP BY ?p2 \
		};"


	echo "## DBPEDIAFR only"
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
		            SELECT ?s ?p2 ?o3 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned> { \
			        	?s ?p2 ?o3 \
			      	} \
		        } \
			} GROUP BY ?p2 \
		};"

	echo "## WIKIDATA only"
	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
		DELETE { <http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_wikidata_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. } \
		WHERE { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_wikidata_only> void:classPartition ?bn1. \
			?bn1 void:class ${class}. \
			?bn1 void:propertyPartition ?bn2. \
			?bn2 void:property ?p. \
			?bn2 void:triples ?x. \
	 		FILTER (isBlank(?bn1) AND isBlank(?bn2)) \
	 	};"

	run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
		INSERT INTO <${DOMAIN}/graph/statistics> { \
			<http://fr.dbpedia.org/abstract_graph/mainclass_prop-obj_wikidata_only> void:classPartition [ \
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
		            SELECT ?s ?p2 ?o2 FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned>  { \
			        	?s ?p2 ?o2 \
			    	} \
				
		        }. FILTER EXISTS { \
		            SELECT ?s ?p2 ?o3 FROM  <http://fr.dbpedia.org/graph/dbpedia_mappings_mappingbased-objects-uncleaned> { \
			        	?s ?p2 ?o3 \
			      	} \
		        } \
			} GROUP BY ?p2 \
		};"
done

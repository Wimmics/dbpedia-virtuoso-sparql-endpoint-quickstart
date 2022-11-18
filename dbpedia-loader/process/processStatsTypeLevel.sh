#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

echo "################## LEVEL DISTRIB";
echo "## DBPEDIA";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. ?bn void:entities ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. \
?bn void:entities ?count. \
FILTER (isBlank(?bn)) };"


run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr> prop-fr:levelPartition [ prop-fr:level ?depth; void:entities ?count ]. \
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

echo "## WIKIDATA";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. ?bn void:entities ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. \
?bn void:entities ?count. \
FILTER (isBlank(?bn)) };"


run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:levelPartition [ prop-fr:level ?depth; void:entities ?count ]. \
	} WHERE { \
		SELECT ?depth COUNT(?s) as ?count  FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
			?s a ?class. \
           { \
               select ?class (count(?mid)-1 as ?depth) FROM <http://fr.dbpedia.org/graph/dbpedia_ontology> WHERE { \
  				?class rdfs:subClassOf* ?mid. \
  				?mid rdfs:subClassOf* owl:Thing \
				} \
            } \
		} group by  ?depth \
	};"

echo "################## STATS GENERALES";

echo "################### SPARQL - GLOBAL STATS - Nb distincts classes";
echo "## DBPEDIA FR ALL "
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

echo "## WIKIDATA ALL "
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classes ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classes ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:classes ?no. } \
	WHERE { \
 		SELECT count(distinct(?class)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

echo "## ONLY WIKIDATA";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classes ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classes ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:classes ?no. } \
	WHERE { \
 		SELECT count(distinct(?class)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class \
				} \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

echo "################### SPARQL - Nb total triples";
echo "## DBPEDIA FR ALL ";
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

echo "## WIKIDATA ALL ";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:triples ?no. \
	} WHERE { \
		SELECT count(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

echo "## ONLY WIKIDATA";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:triples ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:triples ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:triples ?no. \
	} WHERE { \
		SELECT count(?s) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class \
				} \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM  <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
					?s a ?class \
				} \
			} \
		} \
	};"

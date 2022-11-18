#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

echo "############################################################# TYPES";

echo "################### SPARQL - Nb distinct entities";
echo "######## DBPEDIA";
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

echo "######## WIKIDATA";
echo "## ALL";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:entities ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> void:entities ?no. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> void:entities ?no. \
	} WHERE { \
	 	SELECT count(distinct(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			{ \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
				?s a ?class \
				} \
			} \
		} \
 	};"

echo "## ONLY";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:entities ?no. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> void:entities ?no };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_dbpediafr_only> void:entities ?no. \
	} WHERE { \
	 	SELECT count(distinct(?s)) as ?no FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
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
		} \
 	};"



echo "################## NOT TYPED AS OWL:THING";

#### DBPEDIA 
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

#### WIKIDATA 
echo "## ALL";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:NbNotThing ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:NbNotThing ?count. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:NbNotThing ?count. \
	} WHERE { \
		SELECT count(DISTINCT(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s  FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class. \
					FILTER(?class != dbo:Thing) \
				} \
			} \
		} \
	};"

echo "## only";
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> prop-fr:NbNotThing ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata_only> prop-fr:NbNotThing ?count. };"

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata_only> prop-fr:NbNotThing ?count. \
	} WHERE { \
		SELECT count(DISTINCT(?s)) as ?count FROM <http://fr.dbpedia.org/graph/dbpedia_generic_page> WHERE { \
			?s ?p ?o. \
			FILTER EXISTS { \
				SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { \
					?s a ?class. \
					FILTER(?class != dbo:Thing) \
				} 		 \
			}.FILTER NOT EXISTS { \
				SELECT ?s ?class FROM <http://fr.dbpedia.org/graph/dbpedia_mappings_instance-types> WHERE { \
				 ?s a ?class \
				} \
			} \
		} \
	};"

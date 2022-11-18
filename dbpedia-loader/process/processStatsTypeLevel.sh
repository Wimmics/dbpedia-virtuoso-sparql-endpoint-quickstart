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

run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
DELETE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. ?bn void:entities ?count. } \
WHERE { <http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:levelPartition ?bn. \
?bn prop-fr:level ?level. \
?bn void:entities ?count. \
FILTER (isBlank(?bn)) };"


run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> \
	INSERT INTO <${DOMAIN}/graph/statistics> { \
		<http://fr.dbpedia.org/abstract_graph/type_wikidata> prop-fr:levelPartition [ prop-fr:level ?level; void:entities ?count ]. \
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

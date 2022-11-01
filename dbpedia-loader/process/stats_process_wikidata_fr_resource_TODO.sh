#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only
pat_meta='metadata'
pat_onto='ontology'

##### SPACIAL WIKIDATA STATS w
declare -a graph_list_wikidata=("http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-literals" "http://fr.dbpedia.org/graph/dbpedia_wikidata_mappingbased-objects-uncleaned
for graph in ${graph_list_wikidata[@]}; do

    ## CREATE SPECIFIC CLASS PARTITION
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph> void:classPartition ?bn. ?bn void:class dbo:WdtFrResource. } WHERE { <$graph> void:classPartition ?bn. ?bn void:class ?c. FILTER (isBlank(?bn))};"
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { <$graph> void:classPartition [void:class dbo:WdtFrResource ] };"

    
    ################### SPARQL - CLASS PARTITION - CREATE PARTITION BY CLASS
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph> void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn1 void:class ?c. } WHERE { <$graph> void:classPartition ?bn1. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. FILTER (isBlank(?bn1) AND isBlank(?bn2) )};"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { <$graph> void:classPartition [ void:class dbo:WdtFrResource; void:classPartition [ void:class ?c] ] . } WHERE { SELECT DISTINCT(?c) FROM <$graph> { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }.{ SELECT ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } };"
    echo "- nb entities per classes";


    ################### SPARQL - CLASS PARTITION - Nb of triples by entites by class X

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> 
    DELETE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:entities ?count. } WHERE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:entities ?count. FILTER (isBlank(?bn1) AND isBlank(?bn2) ) };"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:entities ?x ] ]. } WHERE { SELECT (COUNT(?p) AS ?x) ?c FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }.{ select ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c  };"
    echo "- nb prop by class";


    ################### SPARQL - CLASS PARTITION - Nb of triples triples associated to a class X
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:triples ?x. } WHERE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:triples ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) )};"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { 
    <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:triples ?x ] ].  
    } WHERE {     SELECT (COUNT(?p) AS ?x) ?c FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }. { SELECT ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c  };"
    echo "- nb prop by class";

   ################### SPARQL - CLASS PARTITION - Nb of triples properties associated to a class X
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:properties ?x. } WHERE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:properties ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) ) };"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:properties ?x ] ]. } WHERE { SELECT (COUNT(DISTINCT ?p) AS ?x) ?c FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }. { select ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c  };"
    echo "- besoin d'explications";

    ################### SPARQL - CLASS PARTITION - Nb of triples associated to a class X
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:classes ?x. } WHERE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:classes ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) )};"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:classes ?x ] ]. } WHERE { SELECT (COUNT(DISTINCT ?d) AS ?x) ?c  FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }. { select ?s ?c ?d FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE {  ?s a ?c , ?d } } } GROUP BY ?c };"
    echo "- distinct subject per classes";

    ################### SPARQL - CLASS PARTITION - Nb of triples distincts subjects associated to a class X
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph> void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2 void:distinctSubjects ?x. } WHERE { <$graph> void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:distinctSubjects ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) ) };"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:distinctSubjects ?x ] ]. } WHERE { SELECT (COUNT(DISTINCT ?s) AS ?x) ?c FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }. { select ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c };"
    echo "- distinct object per classes";

    ################### SPARQL - CLASS PARTITION - Nb  of triples  distincts objects associated to a class X
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:distinctObjects ?x. } WHERE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2  void:distinctObjects ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) ) };"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> {  <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [void:class ?c ; void:distinctObjects ?x ] ]. } WHERE { SELECT (COUNT(DISTINCT ?o) AS ?x) ?c FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }.{ select ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c };"
    echo "- nb triples by prop";

    ################### SPARQL - CLASS PARTITION - Nb of triple by class and properties X
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2 void:propertyPartition ?bn3. ?bn3 void:property ?p. ?bn3 void:triples ?x. } WHERE { <$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2 void:propertyPartition ?bn3. ?bn3 void:property ?p. ?bn3 void:triples ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) AND isBlank(?bn3)) };"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> { 
    <$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:propertyPartition [void:property ?p ; void:triples ?x ] ]]. } WHERE { SELECT ?c (COUNT(?o) AS ?x) ?p FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }.{ select ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c ?p };"
    echo "- nb subj distinct by prop";

    ################### SPARQL - CLASS PARTITION - Nb distincts subjects by  properties -
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE {<$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2 void:propertyPartition ?bn3. ?bn3 void:property ?p. ?bn3 void:distinctSubjects ?x. } WHERE {<$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:classPartition ?bn2. ?bn2 void:class ?c. ?bn2 void:propertyPartition ?bn3. ?bn3 void:property ?p. ?bn3 void:distinctSubjects ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2) AND isBlank(?bn3)) };"

    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> {<$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:classPartition [ void:class ?c ; void:propertyPartition [void:property ?p ; void:distinctSubjects ?x ] ]]. } WHERE { SELECT (COUNT(DISTINCT ?s) AS ?x) ?c ?p FROM <$graph>  WHERE {?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }. { select ?s ?c FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_instance-types> WHERE { ?s a ?c } } } GROUP BY ?c ?p };

    "echo "---- Property PARTITIONS";
    echo "-nb triples by property";

    ################### SPARQL - PROPERTIES PARTITION - Nb distincts triples
    run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/statistics> DELETE {<$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:propertyPartition ?bn2. ?bn2 void:property ?p. ?bn2 void:triples ?x. } WHERE {<$graph>  void:classPartition ?bn1. ?bn1 void:class dbo:WdtFrResource. ?bn1 void:propertyPartition ?bn2. ?bn2 void:property ?p. ?bn2 void:triples ?x. FILTER (isBlank(?bn1) AND isBlank(?bn2))};

    "run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/statistics> {<$graph> void:classPartition [ void:class dbo:WdtFrResource ; void:propertyPartition [ void:property ?p ; void:triples ?x ]]. } WHERE {SELECT (COUNT(?o) AS ?x) ?p FROM <$graph> WHERE { ?s ?p ?o. { SELECT ?s FROM  <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE {?s a dbo:WdtFrResource } }} GROUP BY ?p };
    "echo "- nb distinct Subject by prop";
    
done
echo ">>>>>>>>> END NAMED GRAPH STATS COMPUTATION"

#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only
pat_meta='metadata'
pat_onto='ontology'
echo "[STATS TIME]"
echo "----GENERAL STATS"

################### SPARQL - GLOBAL STATS - Nb entities total
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <${DOMAIN}> void:entities ?no . } WHERE { <${DOMAIN}> void:entities ?no . };"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:entities ?no . } WHERE { SELECT COUNT(distinct ?s) AS ?no { ?s a [] } };"

################### SPARQL - GLOBAL STATS - Nb distincts classes
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <${DOMAIN}> void:classes ?no . } WHERE { <${DOMAIN}> void:classes ?no . };"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:classes ?no . } WHERE { SELECT COUNT(distinct ?o) AS ?no { ?s rdf:type ?o } };"

################### SPARQL - GLOBAL STATS - Nb total triples
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <${DOMAIN}> void:triples ?no . } WHERE { <${DOMAIN}> void:triples ?no . };"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:triples ?no . } WHERE { SELECT (COUNT(*) AS ?no) { ?s ?p ?o } };"

################### SPARQL - GLOBAL STATS - Nb distincts properties
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <${DOMAIN}> void:properties ?no . } WHERE { <${DOMAIN}> void:properties ?no . };"
run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <${DOMAIN}> void:properties ?no . } WHERE { SELECT COUNT(distinct ?p) AS ?no  { ?s ?p ?o } };"

echo "---->>> ASK FIRST THE LIST OF NAMED GRAPH"
get_named_graph='SPARQL SELECT DISTINCT(?graphName) WHERE {GRAPH ?graphName {?s ?p ?o } } GROUP BY ?graphName ;'
resp=$(run_virtuoso_cmd "$get_named_graph");
graph_list=$(echo $resp | tr " " "\n" | grep -E "\/graph\/");
echo "---->>> COMPUTE FOR EACH GRAPH STATS"
pat4='metadata'
pat5='wikidata'
for graph in ${graph_list[@]}; do
    echo "<$graph>"
    echo "----  GRAPH STATS";
    
    if [[ ! $graph =~ $pat_meta ]] && [[ ! $graph =~ $pat_onto ]]; then

        ################### SPARQL - GRAPH STATS - Nb triples total
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <$graph> void:triples ?no . } WHERE { <$graph> void:triples ?no };"
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:triples ?no . } WHERE { SELECT (COUNT(*) AS ?no)  FROM <$graph>  { ?s ?p ?o } };"
       
        ################### SPARQL - GRAPH STATS - Nb distincts entities
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <$graph> void:entities ?no . } WHERE { <$graph> void:entities ?no };"
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:entities ?no . } WHERE { SELECT COUNT(distinct ?s) AS ?no  FROM <$graph> { ?s a [] } };"
      
        ################### SPARQL - GRAPH STATS - Nb distincts classes
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <$graph> void:classes ?no . } WHERE { <$graph> void:classes ?no };"
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:classes ?no . } WHERE { SELECT COUNT(distinct ?o) AS ?no  FROM <$graph> { ?s rdf:type ?o } };"
      
        ################### SPARQL - GRAPH STATS - Nb distincts properties
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> WITH <${DOMAIN}/graph/metadata> DELETE { <$graph> void:properties ?no . } WHERE { <$graph> void:properties ?no };"
        run_virtuoso_cmd "SPARQL PREFIX void: <http://rdfs.org/ns/void#> INSERT INTO <${DOMAIN}/graph/metadata> { <$graph> void:properties ?no . } WHERE { SELECT COUNT(distinct ?p) AS ?no  FROM <$graph> { ?s ?p ?o } };"
        
       
     fi
done

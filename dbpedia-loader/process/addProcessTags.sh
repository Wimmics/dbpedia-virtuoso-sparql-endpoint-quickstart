#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only
echo "[ADD CUSTOM PREFIXES"
run_virtuoso_cmd "DB.DBA.XML_SET_NS_DECL ('tag-fr', 'http://fr.dbpedia.org/tag/', 2);"

run_virtuoso_cmd " SPARQL PREFIX  prov: <http://www.w3.org/ns/prov#> \
  PREFIX oa: <http://www.w3.org/ns/oa#> \
  PREFIX void: <http://rdfs.org/ns/void#> \ 
  PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \  
  PREFIX prov:  <http://www.w3.org/ns/prov#> \
  PREFIX dc: <http://purl.org/dc/elements/1.1/> \
  prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#>  \
  prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> \
  INSERT DATA { GRAPH <http://fr.dbpedia.org/graph/process_tags> { \
 tag-fr:WdtFrResource  a oa:Annotation;   \
 a prov:Entity; \
 rdfs:label 'Wikidata Fr related'@en; \
 rdfs:comment 'Wikidata resource that have a corresponding DBpedia Fr resource'@en; \
 prov:wasGeneratedBy <https://github.com/Wimmics/dbpedia-virtuoso-sparql-endpoint-quickstart/blob/test3/dbpedia-loader/process/clean_multilang.sh>; \
 prov:wasGeneratedBy <https://github.com/Wimmics/dbpedia-virtuoso-sparql-endpoint-quickstart/blob/test3/dbpedia-loader/process/multilingual_labels_corrected.sh>; \
 prov:wasAttributedTo <https://fr.dbpedia.org/>. \
 }};"
   
resp=$(run_virtuoso_cmd "SPARQL SELECT DISTINCT CONCAT('lang_',?lang) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> where { ?s rdfs:label ?o. BIND (lang(?o) AS ?lang) };";);
echo $resp;
lang_list=$(echo $resp | tr " " "\n" | grep -oP "lang_\K(.*)");

for lang in ${lang_list[@]}; do
	if [[ $lang != 'fr' ]]; then
  
		Lang="${lang[@]^}"
                echo "LANG >>> ${Lang}"
     run_virtuoso_cmd " SPARQL PREFIX  prov: <http://www.w3.org/ns/prov#> \
            PREFIX oa: <http://www.w3.org/ns/oa#> \
            PREFIX void: <http://rdfs.org/ns/void#> \ 
            PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \ 
            PREFIX prov:  <http://www.w3.org/ns/prov#>  \
            PREFIX dc: <http://purl.org/dc/elements/1.1/> \
            prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#>  \
            prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> \
            INSERT DATA { GRAPH <http://fr.dbpedia.org/graph/process_tags> { \
           tag-fr:${Lang}FrResource  a oa:Annotation;   \
           a prov:Entity; \
           rdfs:label '${Lang} labels '@en; \
           rdfs:comment 'Filtered ${Lang} labels having related to a DBpedia FR resource'@en; \
           prov:wasGeneratedBy <https://github.com/Wimmics/dbpedia-virtuoso-sparql-endpoint-quickstart/blob/test3/dbpedia-loader/process/clean_multilang.sh>;  \
           prov:wasGeneratedBy <https://github.com/Wimmics/dbpedia-virtuoso-sparql-endpoint-quickstart/blob/test3/dbpedia-loader/process/multilingual_labels_corrected.sh>;  \
           prov:wasAttributedTo <https://fr.dbpedia.org/>. \
           }};"
           fi 
done

   

#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;

echo "============ multilingual_labels.sh Version november 2022"
################### SPARQL - GET LANG LIST
resp=$(run_virtuoso_cmd "SPARQL SELECT DISTINCT CONCAT('lang_',?lang) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> where { ?s rdfs:label ?o. BIND (lang(?o) AS ?lang) };";);
echo $resp;
lang_list=$(echo $resp | tr " " "\n" | grep -oP "lang_\K(.*)");

for lang in ${lang_list[@]}; do
    if [[ $lang != 'fr' ]]; then
        echo "============>>>>>>>>>> $lang need to be treaten"; 

        Lang="${lang[@]^}"
        
        #echo "============>>>>>>>>>> WIKILINKS";
        #nb_global_wlk=1;
        #last_wlk=0;
        #while [ "$nb_global_wlk" -ne "$last_wlk" ]
        #do
        #   last_wlk=$nb_global_wlk;
        #   resp_wikilinks_flag=$(run_virtuoso_cmd "SPARQL  WITH <http://fr.dbpedia.org/graph/dbpedia_generic_labels> DELETE { ?s_lang rdfs:label ?o_lang. } INSERT { ?s_fr rdf:type prop-fr:${Lang}FrResource. ?s_fr rdfs:label ?o_lang. }  WHERE {SELECT  ?s_fr ?s_lang ?o_lang  FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels>  WHERE {?s_lang rdfs:label ?o_lang. {SELECT ?s_fr ?s_lang FROM <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links> WHERE { ?s_fr owl:sameAs ?s_lang } } . FILTER NOT EXISTS { ?s_fr rdf:type  prop-fr:${Lang}FrResource } . FILTER(lang(?o_lang)='$lang') } LIMIT $limit };");   
        #   resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?s_fr) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { ?s_fr rdf:type prop-fr:${Lang}FrResource };");
        #   nb_global_wlk=$(get_answer_nb "$resp_count");
        #   echo ">>> nb flags WKL : $nb_global_wlk";
        #done
        echo "============>>>>>>>>>> WIKIDATA";
        nb_global_wkd=1;
        last_wkd=0;
        while [ "$nb_global_wkd" -ne "$last_wkd" ]
        do
            last_wkd=$nb_global_wkd;
            resp_wikilinks_flag=$(run_virtuoso_cmd "SPARQL DEFINE sql:log-enable 2 \
                    PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
                    PREFIX oa: <http://www.w3.org/ns/oa#> \ 
                    WITH <http://fr.dbpedia.org/graph/dbpedia_generic_labels> \
                DELETE { ?s_lang rdfs:label ?o_lang. } \
                INSERT { tag-fr:${Lang}FrResource oa:hasTarget ?s_fr. ?s_fr rdfs:label ?o_lang.} \
                WHERE { \
                    SELECT  ?s_fr ?s_lang ?o_lang  FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels>  WHERE { \
                    ?s_lang rdfs:label ?o_lang. \
                    { SELECT ?s_fr ?s_lang FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
                        ?s_fr owl:sameAs ?s_lang. \
                         tag-fr:WdtFrResource oa:hasTarget ?s_fr } } \
                         . FILTER NOT EXISTS { tag-fr:${Lang}FrResource oa:hasTarget ?s_fr } \
                         . FILTER(lang(?o_lang)='$lang') \
                } LIMIT $limit };");
                echo "========================";
            echo $resp_wikilinks_flag;
                echo "========================";
            resp_count=$(run_virtuoso_cmd "SPARQL PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
                         PREFIX oa: <http://www.w3.org/ns/oa#> \
             SELECT COUNT(?s_fr) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_labels> WHERE { \
             tag-fr:${Lang}FrResource oa:hasTarget ?s_fr };");
             
            nb_global_wkd=$(get_answer_nb "$resp_count");
            echo ">>> nb flags WKD : $nb_global_wkd > $last_wkd";
        done
        
    fi 
done


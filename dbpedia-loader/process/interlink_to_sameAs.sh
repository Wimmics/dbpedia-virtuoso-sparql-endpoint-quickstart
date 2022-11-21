#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only


############### THIS SCRIPT WAS USED FOR SHAPING INTERLINK AS SAMEAS LINKS
############### BUT INTERLINK COULD REDIRECT TO A ARTICLE PART IF NO WIKIPEDIA PAGE EXISTS FOR IT
############### WE COULDN'T USE IT FOR TRANSLATION / WIKIDATA REFINEMENT SO I DELETED IT FROM THE PROCESS


echo "> INTERLANG LINKS TRANSFORM TO SAMEAS ";
nbsameAs=0;
limit=500000;
################### SPARQL - COUNT INTERLINKS
resp_interlang=$(run_virtuoso_cmd "SPARQL \
SELECT count(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links> WHERE {\
?s dbo:wikiPageInterLanguageLink ?o \
};");

nb_interlang=$(get_answer_nb "$resp_interlang");
if [ "$nb_interlang" -ne 0 ]
then
    while [ "$nb_interlang" -ne "$nbsameAs" ];
    do

        ################### SPARQL - ADD SAMEAS LINKS FOR EACH INTERLANG
        resp_update=$(run_virtuoso_cmd "SPARQL \
        WITH <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links>\
        INSERT { ?x owl:sameAs ?y } WHERE {\
        SELECT ?x ?y FROM <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links> WHERE {\
        ?x dbo:wikiPageInterLanguageLink ?y.\
        MINUS{ ?x owl:sameAs ?y }\
        } LIMIT $limit \
        } ;");

        ################### SPARQL - COUNT INTERLANG TO TRANSFORM
        resp_sameAs=$(run_virtuoso_cmd "SPARQL\
        SELECT count(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_generic_interlanguage-links> WHERE { \
        ?s owl:sameAs ?o\
        };");
        
        nbsameAs=$(get_answer_nb "$resp_sameAs");
        echo "$nb_interlang ne $nbsameAs";
    done
fi

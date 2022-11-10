#!/usr/bin/env bash
. ../virtuoso_fct.sh --source-only

limit=500000;


resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
   ?s a dbo:WdtFrResource  };") 

nb_todelete=$(get_answer_nb "$resp_count");
while [ "$nb_todelete" -ne 0 ]
do
  echo "TO DELETE : $nb_todelete";

  resp_delete=$(run_virtuoso_cmd "SPARQL  DEFINE sql:log-enable 2 \
   PREFIX tag-fr: <http://fr.dbpedia.org/tag/> \
   PREFIX oa: <http://www.w3.org/ns/oa#> \
   WITH <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> \
   DELETE { ?s a dbo:WdtFrResource. } \
     INSERT { tag-fr:WdtFrResource oa:hasTarget ?s . } \
     WHERE { \
  SELECT ?s FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { ?s a dbo:WdtFrResource. } LIMIT $limit \
  };")
  
  resp_count=$(run_virtuoso_cmd "SPARQL SELECT COUNT(?s) FROM <http://fr.dbpedia.org/graph/dbpedia_wikidata_sameas-all-wikis> WHERE { \
   ?s a dbo:WdtFrResource  };") 

  nb_todelete=$(get_answer_nb "$resp_count");
done

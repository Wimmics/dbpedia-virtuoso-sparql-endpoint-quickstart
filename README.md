# French DBpedia Chapter Infrastructure

Welcome on the French DBpedia infrastructure source page. The project is extending the [Quick start virtuoso sparql endpoint](https://github.com/dbpedia/virtuoso-sparql-endpoint-quickstart) built by the DBpedia Association. 

We present here the main feature of the pipeline drawn for refining the french DBpedia knowledge graph, for more explanation about how to built a virtuoso endpoint please refer to [this Wimmics repository](https://github.com/Wimmics/HOWTO_Virtuoso-Docker)

We will find here three docker-composed files :
* docker-compose.dbpedia-load.yml : that is used for building our knowledge base 
* docker-compose.dbpedia.yml : that is used for hosting our endpoint at the end
* docker-compose.live.yml : used for building our instance of [DBpedia Live](https://www.dbpedia.org/resources/live/), only available for academic purposes 

## About the extension of the virtuoso instance

The common container used in the three configuration is extending the official docker image of virtuoso,
as we organised our data in named graph we were obliged to adapt the [VAD interface](https://github.com/datalogism/dbpedia-vad) for allowing us to display for a given entities  all the properties contained in every named graphs.

We simply install this corrected VAD interface in the container

## The French DBpedia pipeline

The process works on last release of databus our [databus collection](https://databus.dbpedia.org/cringwald/collections/french_chapter) downloaded via [the collection downloader](https://github.com/Wimmics/dbpedia-databus-collection-downloader)

This pipeline is processed by the second container of the docker-compose.dbpedia-load.yml, called "load". 
This is running a [master bash script](https://github.com/Wimmics/dbpedia-virtuoso-sparql-endpoint-quickstart/blob/master/dbpedia-loader/import_conductor.sh) shifting depending of the configuration given in the docker-compose file, the different step of the SPARQL refinment process.

This one is composed of theses followings steps :
* FILTER_WIKIDATA_LABELS : filter the [wikidata_labels dataset](https://databus.dbpedia.org/dbpedia/wikidata/labels/) for keeping only wikidata entities that have a french label 
* PROCESS_INIT : load the data into separate named graphs 
* PROCESS_GEOLOC : update the shape of the [geo data](https://databus.dbpedia.org/dbpedia/generic/geo-coordinates/) triples because of their may refer to geocoordinates found into the article that are not necessarily related to the resource of the wikipedia article
* PROCESS_WIKIDATA : process the same as invertion into the [wikidata sameas wiki dataset](https://databus.dbpedia.org/dbpedia/wikidata/sameas-all-wikis/) and propagate it into all the other wikidata named graphs
* PROCESS_MULTILANG : link to french resource labels that have wikidata sameAs relation and tags these triples depending of the language 
* COMPUTE_STATS_MULTILANG : compute stats for allowing chapter coverage comparison
* CLEAN_MULTILANG : delete all the labels that are not related to a french resource
* CLEAN_WIKIDATA : delete wikidata triples without french labels and link to french resource
* PROCESS_STATS : compute general stat for every named graphs and specifics statistics for infobox data from DBpedia and wikidata 
* PROCESS DUMPS : save and export dumps of the produced and enriched graphs

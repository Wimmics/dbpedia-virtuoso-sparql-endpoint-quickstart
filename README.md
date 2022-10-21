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

This pipeline is processed by the second container of the docker-compose.dbpedia-load.yml, called "load". 
This is running a [master bash script](https://github.com/Wimmics/dbpedia-virtuoso-sparql-endpoint-quickstart/blob/master/dbpedia-loader/import_conductor.sh) shifting depending of the configuration given in the docker-compose file, the different step of the SPARQL refinment process.

This one is composed of :
* A first structuration process : this one is getting the last DBpedia release on our server, and load them into named graphs. This script also do some important stuffs as indexation configuration...
* the second on is  

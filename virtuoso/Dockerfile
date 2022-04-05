FROM openlink/virtuoso-opensource-7 

USER root
WORKDIR /opt/
RUN apt-get update
RUN apt-get install -y git python 
RUN git clone https://github.com/datalogism/dbpedia-vad 
WORKDIR /opt/dbpedia-vad  
RUN ./build.sh

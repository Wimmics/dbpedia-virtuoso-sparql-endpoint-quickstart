FROM openlink/virtuoso-opensource-7 

USER root
WORKDIR /opt/
RUN apt-get -y update
RUN apt-get -y install git python 
RUN git clone https://github.com/datalogism/dbpedia-vad 
WORKDIR /opt/dbpedia-vad  
RUN ./build.sh

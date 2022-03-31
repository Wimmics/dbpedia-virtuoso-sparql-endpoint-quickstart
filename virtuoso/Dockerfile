FROM openlink/virtuoso-opensource-7 

USER root
RUN apt-get update && apt-get install -y git python 
RUN git clone https://github.com/datalogism/dbpedia-vad 
RUN cd dbpedia-vad  
RUN ./build.sh

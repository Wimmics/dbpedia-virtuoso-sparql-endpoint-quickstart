FROM debian:jessie

LABEL org.aksw.dld=true org.aksw.dld.type="finalize" org.aksw.dld.require.store="virtuoso" org.aksw.dld.config="{volumes_from: [store]}"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --force-yes git virtuoso-opensource pigz pbzip2 bzip2 curl wget ca-certificates
RUN apt-get clean

ADD virtuoso_fct.sh /
RUN chmod +x /virtuoso_fct.sh
ADD addProcessTags.sh /
RUN chmod +x /addProcessTags.sh
ADD import.sh /
RUN chmod +x /import.sh

ENTRYPOINT /bin/bash import.sh 

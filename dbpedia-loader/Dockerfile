FROM debian:jessie

LABEL org.aksw.dld=true org.aksw.dld.type="import" org.aksw.dld.require.store="virtuoso" org.aksw.dld.config="{volumes_from: [store]}"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --force-yes git virtuoso-opensource pigz pbzip2 bzip2 curl wget ca-certificates
RUN apt-get clean

ADD virtuoso_fct.sh /
RUN chmod +x /virtuoso_fct.sh
ADD import_conductor.sh /
RUN chmod +x /import_conductor.sh
ADD process ./process
RUN chmod +rx -R /process
ADD virtuoso_proc ./virtuoso_proc
RUN chmod +rx -R /virtuoso_proc
ADD metadata ./metadata
RUN chmod +rx -R /metadata


ENTRYPOINT /bin/bash import_conductor.sh 

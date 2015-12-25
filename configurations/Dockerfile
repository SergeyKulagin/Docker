FROM ubuntu:14.04

RUN apt-get install -y --force-yes software-properties-common && apt-get install wget && apt-get install nano
RUN wget https://raw.githubusercontent.com/SergeyKulagin/Docker/master/jboss/standalone.xml
RUN mkdir -p /usr/local/share/jboss/standalone/configuration/standalone.xml
RUN mv standalone.xml /usr/local/share/jboss/standalone/configuration/standalone.xml
FROM ubuntu:14.04

#java
RUN apt-get install -y --force-yes software-properties-common && apt-get install wget && apt-get install nano
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN apt-get install -y default-jdk

#jboss
RUN wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
RUN tar xfvz jboss-as-7.1.1.Final.tar.gz
RUN mv jboss-as-7.1.1.Final /usr/local/share/jboss/
RUN wget http://central.maven.org/maven2/org/hibernate/javax/persistence/hibernate-jpa-2.1-api/1.0.0.Final/hibernate-jpa-2.1-api-1.0.0.Final.jar
RUN mv hibernate-jpa-2.1-api-1.0.0.Final.jar /usr/local/share/jboss/modules/javax/persistence/api/main/
RUN cd /usr/local/share/jboss/modules/javax/persistence/api/main/
RUN ls .
RUN sed -i 's/hibernate-jpa-2.0-api-1.0.1.Final.jar/hibernate-jpa-2.1-api-1.0.0.Final.jar/g' /usr/local/share/jboss/modules/javax/persistence/api/main/module.xml
RUN adduser appserver
RUN chown -R appserver /usr/local/share/jboss
 
#driver
RUN cd /
RUN wget https://jdbc.postgresql.org/download/postgresql-9.4-1206-jdbc4.jar
RUN mv postgresql-9.4-1206-jdbc4.jar /usr/local/share/jboss/standalone/deployments

USER appserver	
RUN /usr/local/share/jboss/bin/add-user.sh --silent=true sergey 1
RUN /usr/local/share/jboss/bin/add-user.sh --silent=true -a sergey 1

EXPOSE 8080
EXPOSE 9990
EXPOSE 9999
#ENTRYPOINT /usr/local/share/jboss/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 
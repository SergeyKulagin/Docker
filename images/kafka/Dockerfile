FROM openjdk:11-jre-slim

ENV KAFKA_VERSION=2.5.0 \
    SCALA_VERSION=2.12 \
    KAFKA_HOME=/opt/kafka

ENV PATH=${PATH}:${KAFKA_HOME}/bin
ENV PATH=${PATH}:${KAFKA_HOME}

RUN mkdir ${KAFKA_HOME}

COPY download-kafka.sh start-kafka.sh /tmp0/

RUN apt-get update; \
    yes | apt-get install curl jq wget;

RUN chmod a+x /tmp0/*.sh; \
 mv /tmp0/start-kafka.sh ${KAFKA_HOME}/; \
 ./tmp0/download-kafka.sh;

RUN tar xfz /tmp0/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /tmp0; \
 cp -R /tmp0/kafka_${SCALA_VERSION}-${KAFKA_VERSION}/* ${KAFKA_HOME}; \
 rm -r /tmp0;

WORKDIR $KAFKA_HOME

ENTRYPOINT ["start-kafka.sh"]
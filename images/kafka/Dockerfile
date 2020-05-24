FROM openjdk:11-jre-slim

ARG kafka_version=2.5.0
ARG scala_version=2.12
ARG glibc_version=2.31-r0
ARG vcs_ref=unspecified
ARG build_date=unspecified

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin
ENV PATH=${PATH}:${KAFKA_HOME}

RUN mkdir ${KAFKA_HOME}

COPY download-kafka.sh start-kafka.sh versions.sh /tmp0/

RUN apt-get update; \
    yes | apt-get install curl jq wget;

RUN chmod a+x /tmp0/*.sh; \
 mv /tmp0/start-kafka.sh /tmp0/versions.sh ${KAFKA_HOME}/; \
 ./tmp0/download-kafka.sh;

RUN tar xfz /tmp0/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /tmp0; \
 cp -R /tmp0/kafka_${SCALA_VERSION}-${KAFKA_VERSION}/* ${KAFKA_HOME};

VOLUME ["/kafka"]

WORKDIR $KAFKA_HOME

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
ENTRYPOINT ["start-kafka.sh"]
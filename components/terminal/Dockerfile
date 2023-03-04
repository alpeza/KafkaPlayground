FROM openjdk:8

LABEL maintainer="minikafka"

ENV DEBIAN_FRONTEND interactive
ENV KAFKA_VERSION="3.4.0"
ENV SCALA_VERSION="2.13"

RUN apt-get update 
RUN apt-get install -y apt-transport-https

RUN ( apt-get update && \
      apt-get install -y --no-install-recommends \
      python3-pip \
      python3-dev \
      build-essential && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* )

RUN ( pip install pip --upgrade && \
      pip install --upgrade setuptools && \
      pip install kafka-tools )

RUN ( wget -q "https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -O /tmp/kafka.tgz && \
      tar xfz /tmp/kafka.tgz -C /opt && \
      mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka && \
      cd /opt/kafka/bin/ && \
      rm /tmp/kafka.tgz )

ENV PATH="/opt/kafka/bin:${PATH}"
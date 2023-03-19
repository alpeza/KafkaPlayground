FROM openjdk:8

LABEL maintainer="KafkaPlayground"

ENV DEBIAN_FRONTEND interactive
ENV KAFKA_VERSION="3.4.0"
ENV SCALA_VERSION="2.13"
ENV GOPATH="/go"

RUN apt-get update && \
    apt-get install -y apt-transport-https

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

# Instalación de las herramientas de Kafka
RUN ( wget -q "https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -O /tmp/kafka.tgz && \
    tar xfz /tmp/kafka.tgz -C /opt && \
    mv /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka && \
    cd /opt/kafka/bin/ && \
    rm /tmp/kafka.tgz )

RUN apt-get update && \
    apt-get install -y libaio1 && \
    apt-get install -y wget && \
    wget https://download.oracle.com/otn_software/linux/instantclient/199000/instantclient-basic-linux.x64-19.9.0.0.0dbru.zip && \
    unzip instantclient-basic-linux.x64-19.9.0.0.0dbru.zip && \
    mv instantclient_19_9 /opt && \
    echo /opt/instantclient_19_9 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig && \
    apt-get install -y jq && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Instalación de go y coyote
RUN apt-get update && \
    apt-get install -y golang && \
    apt-get install -y git && \
    go get -u github.com/landoop/coyote 



ENV PATH="/usr/local/bin:/go/bin:/opt/kafka/bin:${PATH}"

WORKDIR /app

COPY scripts/ /app/scripts/
COPY scripts/servidor/.env.docker /app/scripts/servidor/.env
RUN mkdir -p /app/output &&\
    mkdir -p /app/tests &&\
    mkdir -p /app/logs &&\
    pip3 install markupsafe==2.0.1 && \
    pip3 install -r /app/scripts/servidor/requirements.txt

EXPOSE 5002
CMD [ "python3", "/app/scripts/servidor/app.py" ]
#CMD ["python3", "-m", "http.server", "8000", "--directory", "/app/output"]
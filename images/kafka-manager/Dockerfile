FROM openjdk:8-jdk-alpine

ENV ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.18 \
    KM_CONFIGFILE="conf/application.conf"

ADD startup.sh /kafka-manager-${KM_VERSION}/startup.sh

RUN apk add bash && \
    cd /tmp && \
    wget https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.tar.gz && \
    tar xzf ${KM_VERSION}.tar.gz && \
    cd kafka-manager-${KM_VERSION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    chmod +x /kafka-manager-${KM_VERSION}/startup.sh && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./startup.sh"]

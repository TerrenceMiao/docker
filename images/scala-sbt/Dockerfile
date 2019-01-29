# Scala and sbt Dockerfile

# Pull base image
FROM openjdk:8-jdk-alpine

# Env variables
ENV SCALA_VERSION 2.12.8
ENV SCALA_HOME /usr/local/scala

ENV SBT_VERSION 1.2.7
ENV SBT_HOME /usr/local/sbt

# Install Scala
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache bash curl jq && \
    cd "/tmp" && \
    wget --no-verbose "https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    mkdir -p "${SCALA_HOME}" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/local/bin/" && \
    apk del .build-dependencies && \
    rm -rf "/tmp/"*
 
# Install sbt
 RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar && \
     cd "/tmp" && \
     wget --no-verbose "https://piccolo.link/sbt-${SBT_VERSION}.tgz" && \
     mkdir -p "${SBT_HOME}" && \
     mkdir -p "sbt-${SBT_VERSION}" && \
     tar xzf "sbt-${SBT_VERSION}.tgz" -C "sbt-${SBT_VERSION}" --strip-components=1 && \
     rm "/tmp/sbt-${SBT_VERSION}/bin/"*.bat && \
     mv "/tmp/sbt-${SBT_VERSION}/bin" "/tmp/sbt-${SBT_VERSION}/lib" "/tmp/sbt-${SBT_VERSION}/conf" "${SBT_HOME}" && \
     ln -s "${SBT_HOME}/bin/"* "/usr/local/bin/" && \
     apk del .build-dependencies && \
     rm -rf "/tmp/"* && \
     sbt sbtVersion
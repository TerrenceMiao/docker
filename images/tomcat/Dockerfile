## Latest Tomcat distribution

FROM docker/oracle-jdk:latest 

MAINTAINER Terrence Miao <TerrenceMiao@users.noreply.github.com>

## Tomcat Version
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.32

## Get Tomcat
RUN curl -Ls http://apache.rediris.es/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    | tar -xzf - -C /usr/local && \
    ln -s /usr/local/apache-tomcat-${TOMCAT_VERSION} /usr/local/tomcat && \
    rm -rf /usr/local/tomcat/webapps/*

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]

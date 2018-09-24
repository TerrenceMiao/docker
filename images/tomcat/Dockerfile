## Latest Tomcat distribution

FROM jtech/oracle-jdk:latest 

MAINTAINER Terrence Miao <TerrenceMiao@users.noreply.github.com>

## Tomcat Version
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.53

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

## Get Tomcat
RUN curl -Ls http://apache.rediris.es/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    | tar -xzf - -C /usr/local && \
    ln -s /usr/local/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
    rm -rf ${CATALINA_HOME}/webapps/*

EXPOSE 8080 8009

WORKDIR $CATALINA_HOME
CMD ["bin/catalina.sh", "run"]

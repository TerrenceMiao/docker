FROM openjdk:8-jre-alpine

ENV WM_PACKAGE wiremock
ARG WM_VERSION=2.20.0

RUN mkdir /$WM_PACKAGE
WORKDIR /$WM_PACKAGE
RUN wget https://repo1.maven.org/maven2/com/github/tomakehurst/$WM_PACKAGE-standalone/$WM_VERSION/$WM_PACKAGE-standalone-$WM_VERSION.jar -O wiremock.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "wiremock.jar"]
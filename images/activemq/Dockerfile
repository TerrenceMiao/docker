## Latest ActiveMQ distribution

FROM openjdk:8-jre-alpine

ENV ACTIVEMQ_VERSION 5.13.1
ENV ACTIVEMQ apache-activemq-$ACTIVEMQ_VERSION
ENV ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161

ENV ACTIVEMQ_HOME /usr/local/activemq

RUN \
    wget --no-verbose http://archive.apache.org/dist/activemq/${ACTIVEMQ_VERSION}/${ACTIVEMQ}-bin.tar.gz && \
    tar xf ${ACTIVEMQ}-bin.tar.gz -C /usr/local/ && \
    rm ${ACTIVEMQ}-bin.tar.gz && \
    ln -s /usr/local/${ACTIVEMQ} ${ACTIVEMQ_HOME}

EXPOSE $ACTIVEMQ_TCP $ACTIVEMQ_AMQP $ACTIVEMQ_STOMP $ACTIVEMQ_MQTT $ACTIVEMQ_WS $ACTIVEMQ_UI

WORKDIR $ACTIVEMQ_HOME
CMD ["/bin/sh", "-c", "bin/activemq console"]
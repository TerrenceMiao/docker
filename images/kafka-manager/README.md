Kafka Manager in Docker
=======================
[![](https://images.microbadger.com/badges/image/jtech/kafka-manager.svg)](https://microbadger.com/images/jtech/kafka-manager "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jtech/kafka-manager.svg)](https://microbadger.com/images/jtech/kafka-manager "Get your own version badge on microbadger.com")

A Docker image based on the smallest Linux - Alpine with latest Oracle JDK, Kafka Manager.

Prerequisites
-------------

- Install Docker on host

Source Repository
-----------------
_https://github.com/TerrenceMiao/docker/images/kafka-manager_

How To
------

```bash
𝜆 docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="10.101.32.74:2181" jtech/kafka-manager
```

Without luxury DNS resolver, "**10.101.32.74**" is the ip address of host that Zookeeper and Kafa run on.

Without define ZK_HOSTS, default value is "localhost:2181"

Other runtime options, for example:

```bash
𝜆 docker run -it --rm -p 9000:9000 -e ZK_HOSTS="10.101.32.74:2181" -e APPLICATION_SECRET=letmein jtech/kafka-manager

𝜆 docker run -it --rm -p 9000:9000 -e ZK_HOSTS="10.101.32.74:2181" -e APPLICATION_SECRET=letmein -e KM_ARGS=-Djava.net.preferIPv4Stack=true jtech/kafka-manager

𝜆 docker run -it --rm -v /Users/terrence/kafka-manager/conf:/config -e KM_CONFIGFILE=/config/application.conf -p 9000:9000 --name kafka-manager jtech/kafka-manager
```

Tips
----

- In **/Users/terrence/kafka-manager/conf/application.conf** file, has **last** line with: 

```console
kafka-manager.zkhosts=${?ZK_HOSTS}
kafka-manager.zkhosts="10.101.32.74:2181"
```

- Remove **/tmp/kafka-logs** directory when to reset all the Kafka Cluster settings and Zookeeper Host URLs
- Set Zookeeper Host URL to as SAME as environment variable ZK_HOSTS above i.e. "**10.101.32.74:2181**"

Single node Kafka in Docker
---------------------------

1. Run Zookeeper

```bash
𝜆 docker run -d --net=host --name=zookeeper -e ZOOKEEPER_CLIENT_PORT=2181 -e ZOOKEEPER_TICK_TIME=2000 confluentinc/cp-zookeeper

𝜆 docker logs zookeeper
```

2. Run Kafka

```bash
𝜆 docker run -d --net=host --name=kafka -e KAFKA_ZOOKEEPER_CONNECT=localhost:2181 -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 confluentinc/cp-kafka

𝜆 docker logs kafka
```

3. Create a topic

```bash
𝜆 docker run --net=host --rm confluentinc/cp-kafka kafka-topics --create --topic test --partitions 1 --replication-factor 1 --if-not-exists --zookeeper localhost:2181

𝜆 docker run --net=host --rm confluentinc/cp-kafka kafka-topics --describe --topic test --zookeeper localhost:2181
```

4. Generate messages by Producer

```bash
𝜆 docker run --net=host --rm confluentinc/cp-kafka bash -c "seq 42 | kafka-console-producer --broker-list localhost:9092 --topic test && echo 'Produced 42 messages.'"
```

5. Read messages by Consumer

```bash
𝜆 docker run --net=host --rm confluentinc/cp-kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic test --new-consumer --from-beginning --max-messages 42
```

Or with Docker Compose:

```bash
𝜆 docker-compose up
```

Go to http://localhost:9000 Kafka Manager UI.

Add a Kafka cluster at first. Give **zookeeper:2181** as Cluster Zookeeper Hosts. Others use default values.

![Kafka Cluster](https://terrencemiao.github.io/blog/img/Kafka%20Cluster.png "Kafka Cluster")

Visit "test" topic in Kafka cluster.

![Kafka Manager](https://terrencemiao.github.io/blog/img/Kafka%20Manager.png "Kafka Manager")

References
----------
- Kafka Manager Download, _https://github.com/yahoo/kafka-manager_
- Kafka Manager Dockerfile, _https://github.com/sheepkiller/kafka-manager-docker_
- Step by step run Kafka on Mac, _https://terrencemiao.github.io/blog/2018/12/10/Step-by-step-run-Kafka-on-Mac/_
- Getting Started, _https://github.com/confluentinc/cp-docker-images/wiki/Getting-Started_

Copying
-------
Copyright © 2016 - Terrence Miao. Free use of this software is granted under the terms of the GNU General Public License version 3 (GPLv3).

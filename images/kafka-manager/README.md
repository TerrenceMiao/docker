Kafka Manager in Docker
=======================
[![](https://images.microbadger.com/badges/image/jtech/kafka-manager.svg)](https://microbadger.com/images/jtech/kafka-manager "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jtech/kafka-manager.svg)](https://microbadger.com/images/jtech/kafka-manager "Get your own version badge on microbadger.com")

A Docker image based on based on the smallest Linux - Alpine with latest Oracle JDK, Kafka Manager.

Prerequisites
-------------

- Install Docker on host

References
----------
- Kafka Manager Download, _https://github.com/yahoo/kafka-manager_
- Kafka Manager Dockerfile, _https://github.com/sheepkiller/kafka-manager-docker_

Source Repository
-----------------
_https://github.com/TerrenceMiao/docker/images/kafka-manager_

How To
------

```bash
𝜆 docker run -it --rm  -p 9000:9000 -e ZK_HOSTS="10.101.32.74:2181" jtech/kafka-manager
```

Without luxury DNS resolver, "10.101.32.74" is the ip address of host that Zookeeper and Kafa run on.

Without define ZK_HOSTS, default value is "localhost:2181"

Other runtime options, for example:

```bash
𝜆 docker run -it --rm -p 9000:9000 -e ZK_HOSTS="10.101.32.74:2181" -e APPLICATION_SECRET=letmein jtech/kafka-manager

𝜆 docker run -it --rm -p 9000:9000 -e ZK_HOSTS="10.101.32.74:2181" -e APPLICATION_SECRET=letmein -e KM_ARGS=-Djava.net.preferIPv4Stack=true jtech/kafka-manager

𝜆 docker run -it --rm -v /Users/terrence/kafka-manager/conf:/config -e KM_CONFIGFILE=/config/application.conf -p 9000:9000 --name kafka-manager jtech/kafka-manager
```

Tips
----

- Remove **/tmp/kafka-logs** directory when to reset all the Kafka Cluster settings and Zookeeper Host URLs
- Set Zookeeper Host URL to as SAME as environment variable ZK_HOSTS above i.e. "**10.101.32.74:2181**"

Copying
-------
Copyright © 2016 - Terrence Miao. Free use of this software is granted under the terms of the GNU General Public License version 3 (GPLv3).

Kafka Manager in Docker
=======================
[![](https://images.microbadger.com/badges/image/jtech/wiremock.svg)](https://microbadger.com/images/jtech/wiremock "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jtech/wiremock.svg)](https://microbadger.com/images/jtech/wiremock "Get your own version badge on microbadger.com")

A WireMock Docker image based on the smallest Linux - Alpine with latest Oracle JDK.

Prerequisites
-------------

- Install Docker on host

Source Repository
-----------------
_https://github.com/TerrenceMiao/docker/images/wiremock_

How To
------

```bash
𝜆 docker run -d -p 9999:8080 -v wiremock/__files:/wiremock/__files -v wiremock/mappings/:/wiremock/mappings --name wiremock wiremock
```

Copying
-------
Copyright © 2019 - Terrence Miao. Free use of this software is granted under the terms of the GNU General Public License version 3 (GPLv3).

WireMock in Docker
==================
[![Codefresh build status](https://g.codefresh.io/api/badges/pipeline/terrencemiao/TerrenceMiao%2Fdocker%2Fwiremock?type=cf-2)]( https://g.codefresh.io/public/accounts/terrencemiao/pipelines/TerrenceMiao/docker/wiremock) [![](https://images.microbadger.com/badges/image/jtech/wiremock.svg)](https://microbadger.com/images/jtech/wiremock "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jtech/wiremock.svg)](https://microbadger.com/images/jtech/wiremock "Get your own version badge on microbadger.com") [![](https://img.shields.io/docker/pulls/jtech/wiremock.svg)](https://hub.docker.com/r/jtech/wiremock "Get your own docker pull badge on shields.io")

A WireMock Docker image based on the smallest Linux - Alpine with latest Oracle JDK.

Prerequisites
-------------

- Install Docker on host

Source Repository
-----------------
_https://github.com/TerrenceMiao/docker/tree/master/images/wiremock_

How To
------

```bash
𝜆 docker run -d -p 9999:8080 -v wiremock/__files:/wiremock/__files -v wiremock/mappings/:/wiremock/mappings --name wiremock wiremock
```

With Docker compose:

```yaml
# Docker compose to have WireMock running.

---
version: '3'
services:
  wiremock:
    image: wiremock:latest
    ports:
      - 9999:8080
    volumes:
      - wiremock/__files:/wiremock/__files
      - wiremock/mappings:/wiremock/mappings
```

Copying
-------
Copyright © 2019 - Terrence Miao. Free use of this software is granted under the terms of the GNU General Public License version 3 (GPLv3).

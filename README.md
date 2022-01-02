# Docker in docker with Buildx

[![Docker Automated build](https://img.shields.io/docker/automated/maurosoft1973/docker-with-buildx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/docker-with-buildx/)
[![Docker Pulls](https://img.shields.io/docker/pulls/maurosoft1973/docker-with-buildx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/docker-with-buildx/)
[![Docker Stars](https://img.shields.io/docker/stars/maurosoft1973/docker-with-buildx.svg?style=for-the-badge&logo=docker)](https://hub.docker.com/r/maurosoft1973/docker-with-buildx/)

This image [(maurosoft1973/docker-with-buildx)](https://hub.docker.com/r/maurosoft1973/alpine/) is based on the docker in docker official image [Docker](https://hub.docker.com/_/docker).

## Architectures

* ```:aarch64``` - 64 bit ARM
* ```:armhf```   - 32 bit ARM v6
* ```:armv7```   - 32 bit ARM v7
* ```:x86_64```  - 64 bit Intel/AMD (x86_64/amd64)

## Layers & Sizes

![Version](https://img.shields.io/badge/version-aarch64-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/docker-with-buildx/aarch64?style=for-the-badge)

![Version](https://img.shields.io/badge/version-armv6-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/docker-with-buildx/armhf?style=for-the-badge)

![Version](https://img.shields.io/badge/version-armv7-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/docker-with-buildx/armv7?style=for-the-badge)

![Version](https://img.shields.io/badge/version-amd64-blue.svg?style=for-the-badge)
![MicroBadger Size (tag)](https://img.shields.io/docker/image-size/maurosoft1973/docker-with-buildx/x86_64?style=for-the-badge)

### Main parameters:
* `DOCKER_HOST`: the address and port for docker daemon ("tcp://{address}:{port}")

## Creating an instance

The ip address of host is 192.168.178.75 and port is 2375 (default port)

```bash
docker run -it --rm --name docker-with-buildx -e DOCKER_HOST="tcp://192.168.178.75:2375" maurosoft1973/docker-with-buildx
```

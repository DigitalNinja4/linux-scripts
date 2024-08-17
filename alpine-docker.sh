#!/bin/sh
apk update
apk add docker
addgroup $USER docker
rc-update add docker default
service docker start
apk add docker-cli-compose
echo "Instalacja Dockera i Docker Compose zakończona."

#!/bin/sh
apk update
apk add docker
addgroup $USER docker
rc-update add docker default
service docker start
echo "Instalacja Dockera i Docker Compose zakończona."

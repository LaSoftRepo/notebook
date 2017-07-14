#!/bin/bash
echo "Start installing docker..."

VER="17.03.0-ce" # Docker version

curl -L -o /tmp/dohhhcker-$VER.tgz https://get.docker.com/builds/Linux/x86_64/docker-$VER.tgz &&
tar -xz -C /tmp -f /tmp/docker-$VER.tgz &&
mv /tmp/docker/* /usr/bin &&
SUCESS=1

if [ "$SUCESS" == 1 ]; then
  echo "Installed docker"
else
  echo "There was an error during installing docker"
  exit 1
fi

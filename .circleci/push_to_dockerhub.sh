#!/bin/bash
TAG=$1 # Release tag which is used as docker image tag
ENV=$2 # App environment
IMAGE="vitalikpaprotsky/repeek-${ENV}:${TAG}"

echo "Start pushing ${IMAGE} to Dockerhub..."

docker build -t $IMAGE -f Dockerfile.$ENV . &&
docker login -u $DOCKER_USER -p "${DOCKER_PASS}" &&
docker push $IMAGE &&
SUCCESS=1

if [ "$SUCCESS" == 1 ]; then
  echo "Pushed ${IMAGE} to Dockerhub"
else
  echo "There was an error during pushing ${IMAGE} to Dockerhub"
  exit 1
fi

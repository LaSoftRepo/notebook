#!/bin/bash
TAG=$1 # Release tag which is used as docker image tag
ENV=$2 # App environment
IMAGE="vitalikpaprotsky/repeek-${ENV}:${TAG}"

echo "Start pushing ${IMAGE} to Dockerhub..."

docker build -t $IMAGE -f Dockerfile.$ENV . &&
docker login -u $DOCKER_USER -p "${DOCKER_PASS}qqq" &&
docker push $IMAGE &&
SUCESS=1

if [ "$SUCESS" == 1 ]; then
  echo "Pushed ${IMAGE} to Dockerhub"
else
  echo "There was an error during pushing ${IMAGE} to Dockerhub"
  exit 1 # Doesn't stop the build. Maybe if I put it in deploy_to_staging or deploy_to_production.
fi

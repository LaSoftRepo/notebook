#!/bin/bash
TAG=$1 # Release tag which is used as docker image tag
ENV=$2 # App environment

echo "Start pushing vitalikpaprotsky/repeek-${ENV}:${TAG} to Dockerhub..."
docker build -t vitalikpaprotsky/repeek-$ENV:$TAG -f Dockerfile.$ENV .
docker login -u $DOCKER_USER -p $DOCKER_PASS
docker push vitalikpaprotsky/repeek-$ENV:$TAG
echo "Pushed vitalikpaprotsky/repeek-${ENV}:${TAG} to Dockerhub"

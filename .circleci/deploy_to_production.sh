#!/bin/bash
TAG=$1 # Release tag which is used as docker image tag

bash .circleci/install_docker.sh
bash .circleci/push_to_dockerhub.sh $TAG production

echo "Start deploying to production..."
# TODO
echo "Deployed to production"

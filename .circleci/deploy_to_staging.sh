#!/bin/bash
TAG=$1 # Release tag which is used as docker image tag

bash .circleci/install_docker.sh
# echo $?
# exit 1
if [ "$?" == 1 ]; then exit 1; fi # Doesn't work

bash .circleci/push_to_dockerhub.sh $TAG staging
if [ "$?" == 1 ]; then exit 1; fi # Doesn't work

echo "Start deploying to staging..."
docker run \
  -e PLUGIN_URL=$STAGING_RANCHER_URL \
  -e PLUGIN_ACCESS_KEY=$STAGING_RANCHER_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$STAGING_RANCHER_SECRET_KEY \
  -e PLUGIN_SERVICE=repeek/web \
  -e PLUGIN_DOCKER_IMAGE=vitalikpaprotsky/repeek-staging:$TAG \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  peloton/drone-rancher
echo "Deployed to staging"

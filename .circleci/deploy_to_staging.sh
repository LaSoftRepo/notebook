TAG=$1 # Release tag which is used as docker image tag

sh .circleci/install_docker.sh
sh .circleci/push_to_dockerhub.sh $TAG staging

echo "Start deploying to staging..."
docker run \
  -e PLUGIN_URL=$STAGING_RANCHER_URL \
  -e PLUGIN_ACCESS_KEY=$STAGING_RANCHER_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$STAGING_RANCHER_SECRET_KEY \
  -e PLUGIN_SERVICE=repeek/web \
  -e PLUGIN_DOCKER_IMAGE=vitalikpaprotsky/repeek:$TAG \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  peloton/drone-rancher
echo "Deployed to staging"

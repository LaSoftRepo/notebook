TAG=$1 # Release tag which is used as docker image tag

sh .circleci/install_docker.sh
sh .circleci/push_to_dockerhub.sh $TAG

echo "Start deploying to staging..."
# PLUGIN_URL=$STAGING_RANCHER_URL
# PLUGIN_ACCESS_KEY=$STAGING_RANCHER_ACCESS_KEY
# PLUGIN_SECRET_KEY=$STAGING_RANCHER_SECRET_KEY
# PLUGIN_SERVICE=repeek/web
# PLUGIN_DOCKER_IMAGE=vitalikpaprotsky/repeek:$TAG
docker run \
  -e PLUGIN_URL=$STAGING_RANCHER_URL \
  -e PLUGIN_ACCESS_KEY=$STAGING_RANCHER_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$STAGING_RANCHER_SECRET_KEY \
  -e PLUGIN_SERVICE=repeek/web \
  -e PLUGIN_DOCKER_IMAGE=vitalikpaprotsky/repeek:$TAG \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  peloton/drone-rancher
# docker run -v $(pwd):$(pwd) -w $(pwd) peloton/drone-rancher
echo "Deployed to staging"

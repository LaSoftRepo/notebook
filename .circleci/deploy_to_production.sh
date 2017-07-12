TAG=$1 # Release tag which is used as docker image tag

sh install_docker.sh
sh push_to_dockerhub.sh $TAG

echo "Start deploying to production..."
# TODO...
echo "Deployed to production"

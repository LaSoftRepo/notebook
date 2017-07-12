TAG=$1
docker build -t vitalikpaprotsky/repeek:$TAG .
docker login -u $DOCKER_USER -p $DOCKER_PASS
docker push vitalikpaprotsky/repeek:$TAG
echo "Pushed vitalikpaprotsky/repeek:${TAG} tag to Dockerhub"

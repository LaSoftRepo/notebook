TAG=$1
echo "Start pushing vitalikpaprotsky/repeek:${TAG} to Dockerhub..."
docker build -t vitalikpaprotsky/repeek:$TAG .
docker login -u $DOCKER_USER -p $DOCKER_PASS
docker push vitalikpaprotsky/repeek:$TAG
echo "Pushed vitalikpaprotsky/repeek:${TAG} to Dockerhub"

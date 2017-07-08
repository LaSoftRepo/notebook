# README

Update the service on rancher:

docker run --env-file=.env.rancher-deploy -v $(pwd):$(pwd) -w $(pwd) peloton/drone-rancher

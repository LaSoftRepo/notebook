# README

* Docker & Docker Compose - Environment Setup
* RSpec - Testing
* Rancher & Circle CI - Deployment


Update the service on rancher using plugin drone-rancher:
```
docker run --env-file=.env.rancher-deploy -v $(pwd):$(pwd) -w $(pwd) peloton/drone-rancher
```

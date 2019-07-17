```bash
docker-machine ssh swarm-1

# TODO: Download registry.yml

docker stack deploy -c registry.yml registry

docker stack ps registry

docker image pull jenkins:alpine

docker image tag jenkins:alpine localhost:5000/jenkins:latest

docker image tag jenkins:alpine localhost:5000/jenkins:1.0

docker image push localhost:5000/jenkins:latest

docker image push localhost:5000/jenkins:1.0

docker image rm localhost:5000/jenkins:latest

docker image rm localhost:5000/jenkins:1.0

docker service create --name jenkins localhost:5000/jenkins

docker service ps jenkins

docker service rm jenkins

exit

docker-machine ip swarm-1

docker-machine ssh swarm-1

mkdir certs

openssl genrsa 1024 > certs/registry.key

openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/registry.key -x509 -days 365 -out certs/registry.crt

# chmod 400 certs/registry.key

# NOTE: Respond to all questions. Can enter OK for all.

docker secret create registry.crt certs/registry.crt

docker secret create registry.key certs/registry.key

# TODO: Download registry-cert.yml

docker stack deploy -c registry.yml registry

docker stack ps registry

docker image pull jenkins:alpine

docker image tag jenkins:alpine localhost:5000/jenkins:latest

docker image tag jenkins:alpine localhost:5000/jenkins:1.0

docker image push localhost:5000/jenkins:latest

docker image push localhost:5000/jenkins:1.0

exit

docker-machine ssh swarm-1

docker image pull localhost:5000/jenkins:latest

docker image tag localhost:5000/jenkins:latest localhost:5000/jenkins:2.0

docker image push localhost:5000/jenkins:2.0

docker service scale registry_main=0

docker service scale registry_main=1

docker image pull localhost:5000/jenkins:2.0 # Fails

docker service rm registry

# TODO: Download registry-cert-aws.yml

docker stack deploy -c registry.yml registry

docker image push localhost:5000/jenkins:2.0

docker service scale registry_main=0

docker service scale registry_main=1

docker image pull localhost:5000/jenkins:2.0

exit

docker image pull $(docker-machine ip swarm-1):5000/jenkins:2.0 # Fails

docker-machine ssh swarm-2

docker run --entrypoint htpasswd registry -Bbn admin secret | docker secret create registry.auth -

# TODO: Download registry-cert-aws.yml

docker stack deploy -c registry.yml registry

docker stack ps registry

docker image tag localhost:5000/jenkins:2.0 localhost:5000/jenkins:3.0

docker image push localhost:5000/jenkins:3.0

docker login localhost:5000

docker image push localhost:5000/jenkins:3.0

# NOTE: Needs "TLS certificate issued by a known CA" for a proper setup outside the cluster

exit

pwd

docker-machine ssh swarm-1

cd [...]

git clone https://github.com/vfarcic/docker-flow-stacks

docker image build -t localhost:5000/jenkins:workshop docker-flow-stacks/jenkins/.

docker image push localhost:5000/jenkins:workshop
```
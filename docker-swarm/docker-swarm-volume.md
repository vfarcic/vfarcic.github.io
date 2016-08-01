```
docker-machine create -d virtualbox node-1

docker-machine create -d virtualbox node-2

docker-machine create -d virtualbox node-3

eval $(docker-machine env node-1)

docker swarm init \
    --advertise-addr $(docker-machine ip node-1) \
    --listen-addr $(docker-machine ip node-1):2377

docker node update \
    --label-add environment=proxy \
    $(docker node inspect -f "{{.ID}}" self)

TOKEN=$(docker swarm join-token -q manager)

eval $(docker-machine env node-2)

docker swarm join --token $TOKEN $(docker-machine ip node-1):2377

docker node update \
    --label-add environment=test \
    $(docker node inspect -f "{{.ID}}" self)

docker node demote $(docker node inspect -f "{{.ID}}" self)

eval $(docker-machine env node-3)

docker swarm join --token $TOKEN $(docker-machine ip node-1):2377

docker node update \
    --label-add environment=test \
    $(docker node inspect -f "{{.ID}}" self)

docker node demote $(docker node inspect -f "{{.ID}}" self)

eval $(docker-machine env node-1)

docker network create --driver overlay proxy

# TODO: Set up RexRay

docker service create --name jenkins \
  -p 8080 \
  -p 50000 \
  --network proxy \
  --constraint node.labels.environment==test \
  --env JENKINS_OPTS="--prefix=/jenkins" \
  jenkins:2.3-alpine

docker service create --name proxy \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    --network proxy \
    --constraint node.labels.environment==proxy \
    -e MODE=swarm \
    vfarcic/docker-flow-proxy

docker service ls # Wait until replicas are set to 1/1

open http://$(docker-machine ip node-1)/jenkins

# Configure Jenkins
```


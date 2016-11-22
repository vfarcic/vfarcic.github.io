#!/usr/bin/env bash

set -e

unset DOCKER_HOST DOCKER_CERT_PATH DOCKER_MACHINE_NAME DOCKER_TLS_VERIFY

docker pull registry
docker pull mongo
docker pull vfarcic/go-demo
docker pull vfarcic/docker-flow-swarm-listener
docker pull vfarcic/docker-flow-proxy
docker pull cloudbees/jenkins-enterprise:2.7.21.1
docker pull cloudbees/jenkins-operations-center:2.7.21.1
docker pull docker.bintray.io/jfrog/artifactory-oss
docker pull vfarcic/jenkins-swarm-agent
docker pull golang:1.6
docker pull mongo:3.2.10
docker pull catatnight/postfix:latest

mkdir -p ~/docker/images

docker save registry:latest -o ~/docker/images/registry.tar
docker save mongo:latest -o ~/docker/images/mongo.tar
docker save vfarcic/go-demo:latest -o ~/docker/images/go-demo.tar
docker save vfarcic/docker-flow-swarm-listener:latest -o ~/docker/images/docker-flow-swarm-listener.tar
docker save vfarcic/docker-flow-proxy:latest -o ~/docker/images/docker-flow-proxy.tar
docker save cloudbees/jenkins-enterprise:2.7.21.1 -o ~/docker/images/jenkins-enterprise.tar
docker save cloudbees/jenkins-operations-center:2.7.21.1 -o ~/docker/images/jenkins-operations-center.tar
docker save docker.bintray.io/jfrog/artifactory-oss:latest -o ~/docker/images/artifactory-oss.tar
docker save vfarcic/jenkins-swarm-agent:latest -o ~/docker/images/jenkins-swarm-agent.tar
docker save golang:1.6 -o ~/docker/images/golang.tar
docker save mongo:3.2.10 -o ~/docker/images/mongo_3_2_10.tar
docker save catatnight/postfix:latest -o ~/docker/images/postfix.tar

for i in 1 2 3 4 5; do
    docker-machine create -d virtualbox swarm-$i
    eval $(docker-machine env swarm-$i)
    for p in \
        registry \
        mongo \
        go-demo \
        docker-flow-swarm-listener \
        docker-flow-proxy \
        jenkins-enterprise \
        jenkins-operations-center \
        artifactory-oss \
        jenkins-swarm-agent \
        golang \
        mongo_3_2_10 \
        postfix
    do
        docker load -i $HOME/docker/images/$p.tar
    done
done

set +e

git clone https://github.com/vfarcic/go-demo.git

set -e

for i in 4 5; do
    eval $(docker-machine env swarm-$i)
    docker-compose -f $PWD/go-demo/docker-compose-test-local.yml run --rm unit
done

eval $(docker-machine env swarm-1)

docker swarm init \
  --advertise-addr $(docker-machine ip swarm-1)

TOKEN=$(docker swarm join-token -q manager)

TOKEN_WORKER=$(docker swarm join-token -q worker)

for i in 2 3; do
    eval $(docker-machine env swarm-$i)

    docker swarm join \
        --token $TOKEN \
        --advertise-addr $(docker-machine ip swarm-$i) \
        $(docker-machine ip swarm-1):2377
done

for i in 4 5; do
    eval $(docker-machine env swarm-$i)

    docker swarm join \
        --token $TOKEN_WORKER \
        --advertise-addr $(docker-machine ip swarm-$i) \
        $(docker-machine ip swarm-1):2377
done

eval $(docker-machine env swarm-1)

for i in 1 2 3; do
    docker node update --label-add env=prod swarm-$i
done

for i in 4 5; do
    docker node update --label-add env=test swarm-$i
done

docker network create --driver overlay proxy

docker service create --name registry -p 5000:5000 \
    --constraint 'node.labels.env == prod' \
    --mount "type=bind,source=$PWD,target=/var/lib/registry" \
    --reserve-memory 100m registry

docker service create --name go-demo-db \
    --constraint 'node.labels.env == prod' \
    --network proxy --reserve-memory 100m mongo

docker service create --name go-demo -e DB=go-demo-db \
    --replicas 3 \
    --constraint 'node.labels.env == prod' \
    --network proxy --reserve-memory 50m \
    --label com.df.notify=true --label com.df.distribute=true \
    --label com.df.servicePath=/demo --label com.df.port=8080 \
    vfarcic/go-demo

docker service create --name swarm-listener \
  --constraint 'node.labels.env == prod' \
  --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
  -e DF_NOTIF_CREATE_SERVICE_URL=http://proxy:8080/v1/docker-flow-proxy/reconfigure \
  -e DF_NOTIF_REMOVE_SERVICE_URL=http://proxy:8080/v1/docker-flow-proxy/remove \
  --constraint 'node.role==manager' \
  --network proxy \
  vfarcic/docker-flow-swarm-listener

docker service create -e MODE=swarm -e LISTENER_ADDRESS=swarm-listener \
    --name proxy \
    --constraint 'node.labels.env == prod' \
    -p 80:80 -p 443:443 --network proxy --replicas 3 \
    vfarcic/docker-flow-proxy

docker node ls

docker service ls

echo ""
echo ">> A Swarm cluster is created!!!"
echo ""

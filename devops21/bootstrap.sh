#!/usr/bin/env bash

set -e

git clone https://github.com/vfarcic/go-demo.git

cd go-demo

docker-machine create -d virtualbox go-demo

eval $(docker-machine env go-demo)

docker pull golang:1.6

docker pull mongo

docker pull registry

docker pull alpine

for i in 1 2 3 4; do

    docker-machine create -d virtualbox swarm-$i

    eval $(docker-machine env swarm-$i)

    docker pull registry

    docker pull jenkins:alpine

    docker pull mongo

    docker pull vfarcic/go-demo

    docker pull vfarcic/go-demo:1.0

    docker pull vfarcic/go-demo:1.1

    docker pull vfarcic/docker-flow-proxy

    docker pull alpine

    docker pull consul

    docker pull manomarks/visualizer

done

for i in 1 2; do

    docker-machine create -d virtualbox swarm-test-$i

    eval $(docker-machine env swarm-test-$i)

    docker pull vfarcic/jenkins-swarm-agent

    docker pull registry

    docker pull mongo

    docker pull manomarks/visualizer

done

echo "Well done!!!"



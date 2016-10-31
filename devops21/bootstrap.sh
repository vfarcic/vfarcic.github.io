#!/usr/bin/env bash

set +e

git clone https://github.com/vfarcic/go-demo.git

set -e

cd go-demo

set +e

docker-machine create -d virtualbox go-demo

set -e

eval $(docker-machine env go-demo)

docker pull golang:1.6

docker pull mongo

docker pull registry

docker pull alpine

for i in 1 2 3 4 5; do

    set +e

    docker-machine create -d virtualbox swarm-$i

    set -e

    eval $(docker-machine env swarm-$i)

    docker pull registry

    docker pull jenkins:alpine

    docker pull mongo:3.2.10

    docker pull vfarcic/go-demo

    docker pull vfarcic/go-demo:1.0

    docker pull vfarcic/go-demo:1.1

    docker pull vfarcic/docker-flow-proxy

    docker pull vfarcic/docker-flow-swarm-listener

    docker pull alpine

    docker pull manomarks/visualizer

    docker pull elasticsearch:2.4

    docker pull prom/node-exporter:0.12.0

    docker pull google/cadvisor:v0.24.1

    docker pull prom/haproxy-exporter:v0.7.1

    docker pull prom/prometheus:v1.2.1

    docker pull grafana/grafana:3.1.1

done

for i in 1 2; do

    set +e

    docker-machine create -d virtualbox swarm-test-$i

    set -e

    eval $(docker-machine env swarm-test-$i)

    docker pull vfarcic/jenkins-swarm-agent

    docker pull registry

    docker pull mongo

    docker pull manomarks/visualizer

done

echo ""
echo "Nodes were created and preloaded with images!!!"
echo ""



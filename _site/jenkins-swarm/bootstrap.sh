#!/usr/bin/env bash

set -e

for i in 1 2 3; do

    set +e

    docker-machine create -d virtualbox swarm-$i

    set -e

    eval $(docker-machine env swarm-$i)

    docker pull registry

    docker pull jenkins:alpine

    docker pull mongo

    docker pull vfarcic/go-demo

    docker pull vfarcic/docker-flow-swarm-listener

    docker pull vfarcic/docker-flow-proxy

    docker pull dockersamples/visualizer

done

for i in 1 2; do

    set +e

    docker-machine create -d virtualbox swarm-test-$i

    set -e

    eval $(docker-machine env swarm-test-$i)

    docker pull golang:1.6

    docker pull vfarcic/jenkins-swarm-agent

    docker pull registry

    docker pull mongo:3.2.10

    docker pull dockersamples/visualizer

done

echo ""
echo "Nodes were created and preloaded with images!!!"
echo ""
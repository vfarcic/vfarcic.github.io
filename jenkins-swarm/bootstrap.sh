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

    docker pull vfarcic/docker-flow-proxy

    docker pull manomarks/visualizer

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
#!/usr/bin/env bash

set -e

for i in 1 2 3 4; do

    docker-machine create -d virtualbox swarm-$i

    eval $(docker-machine env swarm-$i)

    docker pull mongo

    docker pull vfarcic/go-demo

    docker pull alpine

    docker pull consul

    docker pull vfarcic/docker-flow-proxy

    docker pull vfarcic/go-demo:1.1

    docker pull dockersamples/visualizer

done


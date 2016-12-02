#!/usr/bin/env bash

export AWS_ZONE=b

docker-machine create \
    --driver amazonec2 \
    --amazonec2-zone ${AWS_ZONE} \
    go-demo

eval $(docker-machine env go-demo)

docker pull golang:1.6

docker pull mongo

docker pull registry:2.5.0

docker pull alpine

echo ""
echo "Nodes were created and preloaded with images!!!"
echo ""



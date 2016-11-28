#!/usr/bin/env bash

set +e

git clone https://github.com/vfarcic/go-demo.git

set -e

cd go-demo

set +e

export AWS_ZONE=b

docker-machine create \
    --driver amazonec2 \
    --amazonec2-zone ${AWS_ZONE} \
    go-demo

set -e

eval $(docker-machine env go-demo)

docker-machine ssh go-demo curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

docker pull golang:1.6

docker pull mongo

docker pull registry:2.5.0

docker pull alpine

echo ""
echo "Nodes were created and preloaded with images!!!"
echo ""



#!/usr/bin/env bash

echo "export CLUSTER_DNS=[...]
export CLUSTER_IP=[...]
export DOCKER_HUB_USER=[...]
">creds

curl -o visualizer.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/web/docker-visualizer.yml

HTTP_PORT=8083 docker stack deploy -c visualizer.yml visualizer

curl -o proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-mem.yml

docker stack rm monitor

docker network create -d overlay monitor

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-alert.yml

docker stack deploy -c exporters.yml exporter

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert.yml

docker stack deploy -c go-demo.yml go-demo

#!/usr/bin/env bash

echo "export CLUSTER_DNS=[...]
export CLUSTER_IP=[...]
export DOCKER_HUB_USER=[...]
">creds

source creds

curl -o visualizer.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/web/docker-visualizer.yml

HTTP_PORT=8083 docker stack deploy -c visualizer.yml visualizer

curl -o proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack-9093.yml

echo "route:
  group_by: [service,scale]
  repeat_interval: 5m
  group_interval: 5m
  receiver: 'slack'
  routes:
  - match:
      service: 'go-demo_main'
      scale: 'up'
    receiver: 'jenkins-go-demo_main-up'
  - match:
      service: 'go-demo_main'
      scale: 'down'
    receiver: 'jenkins-go-demo_main-down'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
  - name: 'jenkins-go-demo_main-down'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1'
" | docker secret create alert_manager_config -

docker network create -d overlay monitor

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-alert.yml

docker stack deploy -c exporters.yml exporter

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument-alert-short-2.yml

docker stack deploy -c go-demo.yml go-demo

curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/jenkins.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c jenkins.yml jenkins
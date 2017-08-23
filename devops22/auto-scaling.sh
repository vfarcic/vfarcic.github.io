# Setup Cluster


for i in 1 2 3; do
  docker-machine create -d virtualbox swarm-$i
done

eval $(docker-machine env swarm-1)

docker swarm init --advertise-addr $(docker-machine ip swarm-1)

TOKEN=$(docker swarm join-token -q manager)

for i in 2 3; do
  eval $(docker-machine env swarm-$i)

  docker swarm join --advertise-addr $(docker-machine ip swarm-$i) \
        --token $TOKEN $(docker-machine ip swarm-1):2377
done

docker node ls


# Deploy Proxy


curl -L -o proxy.yml https://goo.gl/NRJa95

cat proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

docker stack ps proxy


# Deploy Monitor

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
        title_link: 'http://$(docker-machine ip swarm-1)/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
  - name: 'jenkins-go-demo_main-down'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1'
" | docker secret create alert_manager_config -

curl -L -o monitor.yml https://goo.gl/6QRAof

cat monitor.yml

docker network create -d overlay monitor

DOMAIN=$(docker-machine ip swarm-1) docker stack deploy \
    -c monitor.yml monitor

docker stack ps -f desired-state=running monitor

open "http://$(docker-machine ip swarm-1)/monitor"


# Deploy Jenkins


curl -L -o jenkins.yml https://goo.gl/tCKG7Y

cat jenkins.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c jenkins.yml jenkins

docker stack ps jenkins

open "http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/configure"

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

# Click the *Run* button > it fails


# Metrics


open "https://goo.gl/jc6aUx"

curl -L -o go-demo.yml https://goo.gl/eoP7zE

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

docker stack ps -f desired-state=running go-demo

open "http://$(docker-machine ip swarm-1)/monitor/targets"

open "http://$(docker-machine ip swarm-1)/monitor/graph"

# sum(rate(http_server_resp_time_bucket{job="go-demo_main",le="0.1"}[5m])) / sum(rate(http_server_resp_time_count{job="go-demo_main"}[5m]))


# Auto-Scaling

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo

# Wait for 10 minutes

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

open "http://slack.devops20toolkit.com/"

open "https://devops20.slack.com/messages/C59EWRE2K/"

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip swarm-1)/demo/hello?delay=$DELAY"
done

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo
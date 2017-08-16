## Hands-On Time

---

# Self-Adapting Services


# Jenkins

---

```bash
cat stacks/jenkins-scale.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c stacks/jenkins-scale.yml jenkins

docker stack ps jenkins

open "http://$(docker-machine ip $NODE)/jenkins"

open "http://$(docker-machine ip $NODE)/jenkins/configure"
```


# Jenkins: Scaling

---

```bash
open "http://$(docker-machine ip $NODE)/jenkins/computer"

open "http://$(docker-machine ip $NODE)/jenkins/job/service-scale/configure"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

# Run > Fails

curl -X POST "http://$(docker-machine ip $NODE)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=Running go-demo
```


# Jenkins: Scaling

---

```bash
curl -X POST "http://$(docker-machine ip $NODE)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=Running go-demo

curl -X POST "http://$(docker-machine ip $NODE)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=3"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

open "https://devops20.slack.com/messages/C59EWRE2K/"
```


# Slack: Alerting

---

```bash
docker service rm monitor_alert-manager

docker secret rm alert_manager_config

echo "route:
  group_by: [service]
  repeat_interval: 1h
  receiver: 'slack'
  routes:
  - match:
      service: 'go-demo_main'
    receiver: 'jenkins-go-demo_main'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$(docker-machine ip $NODE)/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main'
    webhook_configs:
      - send_resolved: false
        url: 'http://$(docker-machine ip $NODE)/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -
```


# Prometheus > Slack

---

```bash
DOMAIN=$(docker-machine ip $NODE) GLOBAL_SCRAPE_INTERVAL=1s \
    docker stack deploy -c stacks/docker-flow-monitor-slack.yml \
    monitor

docker service update \
    --label-add com.df.alertIf.1=@node_mem_limit:0.01 \
    exporter_node-exporter

open "http://$(docker-machine ip $NODE)/monitor/alerts"

open "https://devops20.slack.com/messages/C59EWRE2K/"

docker service update \
    --label-add com.df.alertIf.1=@node_mem_limit:0.8 \
    exporter_node-exporter
```


# Prometheus > Scale

---

```bash
docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.01 \
    go-demo_main

open "http://$(docker-machine ip $NODE)/monitor/alerts"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker service ps -f desired-state=Running go-demo_main

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.8 \
    go-demo_main
```
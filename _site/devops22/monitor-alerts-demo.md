## Hands-On Time

---

# Metrics & Alerts


## Monitor Stack

---

```bash
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

# https://goo.gl/G6dwUi
```


## Monitor Stack

---

```bash
curl -L -o monitor.yml https://goo.gl/6QRAof

cat monitor.yml

docker network create -d overlay monitor

DOMAIN=$(docker-machine ip swarm-1) docker stack deploy \
    -c monitor.yml monitor

docker stack ps -f desired-state=running monitor

open "http://$(docker-machine ip swarm-1)/monitor"
```

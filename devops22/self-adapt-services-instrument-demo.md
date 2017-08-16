## Hands-On Time

---

# Self-Adaptating Instrumented Services


## Querying Response Time

---

```bash
cat stacks/go-demo-instrument.yml

docker stack deploy -c stacks/go-demo-instrument.yml go-demo

open "http://$(docker-machine ip $NODE)/monitor/config"

open "http://$(docker-machine ip $NODE)/monitor/targets"

open "http://$(docker-machine ip $NODE)/monitor/graph"

# http_server_resp_time_sum / http_server_resp_time_count
```


## Querying Response Time

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip $NODE)/demo/hello?delay=$DELAY"
done

# rate(http_server_resp_time_sum[5m]) / rate(http_server_resp_time_count[5m])

# sum(rate(http_server_resp_time_sum[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

# sum(rate(http_server_resp_time_bucket{le="0.1"}[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

# sum(rate(http_server_resp_time_bucket{job="go-demo_main",le="0.1"}[5m])) / sum(rate(http_server_resp_time_count{job="go-demo_main"}[5m]))
```


## Querying Errors

---

```bash
for i in {1..100}; do
    curl "http://$(docker-machine ip $NODE)/demo/random-error"
done

# sum(rate(http_server_resp_time_count{code=~"^5..$"}[5m])) by (job)

# sum(rate(http_server_resp_time_count{code=~"^5..$"}[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)
```


## Scaling Up

---

```bash
docker stack rm monitor

docker secret rm alert_manager_config

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
" | docker secret create alert_manager_config -
```


## Scaling Up

---

```bash
DOMAIN=$(docker-machine ip $NODE) docker stack deploy \
    -c stacks/docker-flow-monitor-slack.yml monitor

docker stack ps -f desired-state=running monitor

cat stacks/go-demo-instrument-alert.yml

docker stack deploy -c stacks/go-demo-instrument-alert.yml go-demo

open "http://$(docker-machine ip $NODE)/monitor/alerts"
```


## Scaling Up

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$(docker-machine ip $NODE)/demo/hello?delay=$DELAY"
done

open "http://$(docker-machine ip $NODE)/monitor/alerts"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo
```


## Scaling Down

---

```bash
docker stack rm monitor

docker secret rm alert_manager_config

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
```


## Scaling Down

---

```bash
DOMAIN=$(docker-machine ip $NODE) docker stack deploy \
    -c stacks/docker-flow-monitor-slack.yml monitor

cat stacks/go-demo-instrument-alert-short.yml

docker stack deploy -c stacks/go-demo-instrument-alert-short.yml \
    go-demo

open "http://$(docker-machine ip $NODE)/monitor/alerts"

open "http://$(docker-machine ip $NODE)/jenkins/blue/organizations/jenkins/service-scale/activity"

docker stack ps -f desired-state=running go-demo
```


## Error Notifications

---

```bash
cat stacks/go-demo-instrument-alert-short-2.yml

docker stack deploy -c stacks/go-demo-instrument-alert-short-2.yml \
    go-demo

open "http://$(docker-machine ip $NODE)/monitor/alerts"

for i in {1..100}; do
    curl "http://$(docker-machine ip $NODE)/demo/random-error"
done

open "http://$(docker-machine ip $NODE)/monitor/alerts"

open "https://devops20.slack.com/messages/C59EWRE2K/"
```
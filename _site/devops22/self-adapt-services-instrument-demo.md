## Hands-On Time

---

# Self-Adapting Instrumented Services


## Querying Response Time

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/config"

open "http://$CLUSTER_DNS/monitor/targets"
```


## Querying Response Time

---

```bash
open "http://$CLUSTER_DNS/monitor/graph"

# http_server_resp_time_sum / http_server_resp_time_count

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
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
    curl "http://$CLUSTER_DNS/demo/random-error"
done

# sum(rate(http_server_resp_time_count{code=~"^5..$"}[5m])) by (job)

# sum(rate(http_server_resp_time_count{code=~"^5..$"}[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

ssh -i workshop.pem docker@$CLUSTER_IP

source creds
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
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -
```


## Scaling Up

---

```bash
DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

docker stack ps -f desired-state=running monitor

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument-alert.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"
```


## Scaling Up

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
done

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

source creds

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
```


## Scaling Down

---

```bash
DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument-alert-short.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"
```


## Scaling Down

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo
```


## Error Notifications

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument-alert-short-2.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"

for i in {1..100}; do
    curl "http://$CLUSTER_DNS/demo/random-error"
done
```


## Error Notifications

---

```bash
open "http://$CLUSTER_DNS/monitor/alerts"

open "https://devops20.slack.com/messages/C59EWRE2K/"

ssh -i workshop.pem docker@$CLUSTER_IP
```

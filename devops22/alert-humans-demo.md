## Hands-On Time

---

# Alerting Humans


## Alertmanager

---

```bash
echo 'route:
  receiver: "slack"
  repeat_interval: 1h

receivers:
  - name: "slack"
    slack_configs:
      - send_resolved: true
        text: "Something horrible happened! Run for your lives!"
        api_url: "https://hooks.slack.com/services/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"
' | docker secret create alert_manager_config -
```


## Alertmanager

---

```bash
curl -o alert-manager.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/alert-manager-slack.yml

cat alert-manager.yml

docker stack deploy -c alert-manager.yml alert-manager

exit

curl -H "Content-Type: application/json" \
    -d '[{"labels":{"alertname":"My Fancy Alert"}}]' \
    $CLUSTER_DNS:9093/api/v1/alerts

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack rm alert-manager
```


## Alertmanager

---

```bash
curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack.yml

cat monitor.yml

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

exit

open "http://$CLUSTER_DNS/monitor/flags"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Alertmanager

---

```bash
docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.1 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```


<!-- .slide: data-background="img/slack-alert-manager-diag.png" data-background-size="contain" -->


## Alertmanager

---

```bash
docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.8 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm monitor_alert-manager

docker secret rm alert_manager_config
```


## Alertmanager Templates

---

```bash
source creds

echo "route:
  group_by: [service]
  receiver: 'slack'
  repeat_interval: 1h

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
" | docker secret create alert_manager_config -
```


## Alertmanager Templates

---

```bash
DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.1 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.8 \
    go-demo_main
```
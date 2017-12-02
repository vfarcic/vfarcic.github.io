## Hands-On Time

---

# Alerting Humans


## Alertmanager

---

```bash
source creds

echo "route:
  group_by: [service,scale,type]
  repeat_interval: 30m
  group_interval: 30m
  receiver: 'slack'
  routes:
  - match:
      type: 'node'
      scale: 'up'
    receiver: 'jenkins-node-up'
  - match:
      type: 'node'
      scale: 'down'
    receiver: 'jenkins-node-down'
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
  - name: 'jenkins-node-up'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=1'
  - name: 'jenkins-node-down'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=-1'
" | docker secret create alert_manager_config -
```


## Alertmanager

---

```bash
curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack.yml

cat monitor.yml

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
```

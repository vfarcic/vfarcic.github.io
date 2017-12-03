## Hands-On Time

---

# Alerting Humans


## Alertmanager

---

```bash
source creds

echo "route:
  repeat_interval: 30m
  group_interval: 30m
  receiver: 'slack'

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
    --label-add com.df.alertIf.1=@service_mem_limit:0.1 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://slack.devops20toolkit.com"

open "https://devops20.slack.com/messages/C59EWRE2K/team/U2ZLK8MLM"

ssh -i workshop.pem docker@$CLUSTER_IP
```


<!-- .slide: data-background="img/slack-alert-manager-diag.png" data-background-size="contain" -->


## Alertmanager

---

```bash
docker service update \
    --label-add com.df.alertIf.1=@service_mem_limit:0.8 go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```

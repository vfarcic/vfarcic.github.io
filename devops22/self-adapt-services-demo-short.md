## Hands-On Time

---

# Self-Adapting Services


## Alertmanager

---

```bash
docker service scale go-demo_main=3

docker stack rm monitor

docker secret rm alert_manager_config

source creds
```


## Alertmanager

---

```bash
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


# Service Limits

---

```bash
DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor
```


## Jenkins Service

---

```bash
curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/jenkins-aws-secret.yml

cat jenkins.yml

source creds

echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
export STACK_NAME=devops22
" | docker secret create aws -
```


## Jenkins Service

---

```bash
echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c jenkins.yml jenkins

exit

open "http://$CLUSTER_DNS/jenkins"

open "http://$CLUSTER_DNS/jenkins/computer"
```


<!-- .slide: data-background="img/jenkins-master-agent.png" data-background-size="contain" -->


## Notifying Humans

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Scroll to *Global Slack Notifier Settings*
* Click the *Test Connection* button

```bash
open "https://devops20.slack.com/messages/C59EWRE2K/team/U2ZLK8MLM"
```


## Creating A Scaling Pipeline

---

```bash
open "http://$CLUSTER_DNS/jenkins/job/service-scale/configure"
```

* Click the *Jenkins* button
* Click the *Open Blue Ocean* link located in the left-hand menu
* Click the *service-scale* job
* Click the *Run* button


## Creating A Scaling Pipeline

---

```bash
curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo

exit

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo
```


## Alertmanager From Jenkins

---

```bash
docker service update \
    --label-add com.df.alertIf.1=@service_mem_limit:0.01 \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service ps -f desired-state=Running go-demo_main
```


<!-- .slide: data-background="img/jenkins-slack-scale.png" data-background-size="contain" -->


## Alertmanager From Jenkins

---

```bash
docker service update \
    --label-add com.df.alertIf.1=@service_mem_limit:0.8 \
    go-demo_main
```
## Hands-On Time

---

# Self-Adapting Services


# Jenkins Service

---

```bash
curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/jenkins.yml

cat jenkins.yml
```


<!-- .slide: data-background="img/jenkins-master-agent.png" data-background-size="contain" -->


# Jenkins Service

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


## Creating A Scaling Pipeline

---

```bash
open "http://$CLUSTER_DNS/jenkins/newJob"
```

* Type *service-scale* as the item name
* Select *Pipeline* as job type
* Click the *OK* button
* Select the *Trigger builds remotely* checkbox
* Type *DevOps22* as the *Authentication Token*
* Type the script that follows inside the *Pipeline Script* field


## Creating A Scaling Pipeline

---

```groovy
pipeline {
  agent {
      label "prod"
  }
  parameters {
    string(
      name: "service",
      defaultValue: "",
      description: "The name of the service that should be scaled"
    )
    string(
      name: "scale",
      defaultValue: "",
      description: "Number of replicas to add or remove."
      )
  }
  stages {
    stage("Scale") {
      steps {
        script {
          def inspectOut = sh script: "docker service inspect $service",
            returnStdout: true
          def inspectJson = readJSON text: inspectOut.trim()
          def currentReplicas = inspectJson[0].Spec.Mode.Replicated.Replicas
          def newReplicas = currentReplicas + scale.toInteger()
          sh "docker service scale $service=$newReplicas"
          echo "$service was scaled from $currentReplicas to $newReplicas replicas"
        }
      }
    }
  }
}
```


## Creating A Scaling Pipeline

---

* Click the *Save* button
* Click the *Open Blue Ocean* link located in the left-hand menu.
* Click the *Run* button


## Creating A Scaling Pipeline

---

```bash
curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=2"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo

exit

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-1"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo
```


<!-- .slide: data-background="img/jenkins-user-scale.png" data-background-size="contain" -->


## Preventing Scaling Disaster

---

```bash
curl -o go-demo.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-scale.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/jenkins/job/service-scale/configure"
```


## Preventing Scaling Disaster

---

```groovy
pipeline {
  agent {
      label "prod"
  }
  parameters {
    string(
      name: "service",
      defaultValue: "",
      description: "The name of the service that should be scaled"
    )
    string(
      name: "scale",
      defaultValue: "",
      description: "Number of replicas to add or remove."
    )
  }
  stages {
    stage("Scale") {
      steps {
        script {
          def inspectOut = sh script: "docker service inspect $service",
            returnStdout: true
          def inspectJson = readJSON text: inspectOut.trim()
          def currentReplicas = inspectJson[0].Spec.Mode.Replicated.Replicas
          def newReplicas = currentReplicas + scale.toInteger()
          def minReplicas = inspectJson[0].Spec.Labels["com.df.scaleMin"].toInteger()
          def maxReplicas = inspectJson[0].Spec.Labels["com.df.scaleMax"].toInteger()
          if (newReplicas > maxReplicas) {
            error "$service is already scaled to the maximum number of $maxReplicas replicas"
          } else if (newReplicas < minReplicas) {
            error "$service is already descaled to the minimum number of $minReplicas replicas"
          } else {
            sh "docker service scale $service=$newReplicas"
            echo "$service was scaled from $currentReplicas to $newReplicas replicas"
          }
        }
      }
    }
  }
}
```


## Preventing Scaling Disaster

---

```bash
curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=Running go-demo

exit

curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"
```


## Notifying Humans

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Scroll to *Global Slack Notifier Settings*
* Enter *devops20* in the *Team Subdomain* field
* Enter *2Tg33eiyB0PfzxII2srTeMbd* in the *Integration Token* field
* Click the *Apply* button
* Click the *Test Connection* button

```bash
open "http://slack.devops20toolkit.com"

open "https://devops20.slack.com/messages/C59EWRE2K/team/U2ZLK8MLM"
```


## Notifying Humans

---

```bash
open "http://$CLUSTER_DNS/jenkins/job/service-scale/configure"
```

* Replace the pipeline with the one from the next slide


## Notifying Humans

---

```groovy
pipeline {
    agent {
        label "prod"
    }
    parameters {
        string(
                name: "service",
                defaultValue: "",
                description: "The name of the service that should be scaled"
        )
        string(
                name: "scale",
                defaultValue: "",
                description: "Number of replicas to add or remove."
        )
    }
    stages {
        stage("Scale") {
            steps {
                script {
                    def inspectOut = sh(
                            script: "docker service inspect $service",
                            returnStdout: true
                    )
                    def inspectJson = readJSON text: inspectOut.trim()
                    def currentReplicas = inspectJson[0].Spec.Mode.Replicated.Replicas
                    def newReplicas = currentReplicas + scale.toInteger()
                    def minReplicas = inspectJson[0].Spec.Labels["com.df.scaleMin"].toInteger()
                    def maxReplicas = inspectJson[0].Spec.Labels["com.df.scaleMax"].toInteger()
                    if (newReplicas > maxReplicas) {
                        error "$service is already scaled to the maximum number of $maxReplicas replicas"
                    } else if (newReplicas < minReplicas) {
                        error "$service is already descaled to the minimum number of $minReplicas replicas"
                    } else {
                        sh "docker service scale $service=$newReplicas"
                        echo "$service was scaled from $currentReplicas to $newReplicas replicas"
                    }
                }
            }
        }
    }
    post {
        failure {
            slackSend(
                    color: "danger",
                    message: """$service could not be scaled.
Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
${env.RUN_DISPLAY_URL}"""
            )
        }
    }
}
```


## Notifying Humans

---

```bash
curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-123"
```


## Alertmanager From Jenkins

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm monitor_alert-manager

docker secret rm alert_manager_config
```


## Alertmanager From Jenkins

---

```bash
source creds

echo "route:
  group_by: [service]
  repeat_interval: 1h
  receiver: 'jenkins-go-demo_main'

receivers:
  - name: 'jenkins-go-demo_main'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -

curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack-9093.yml

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor
```


## Alertmanager From Jenkins

---

```bash
docker service scale go-demo_main=3

exit

curl -H "Content-Type: application/json" \
    -d '[{"labels":{"service":"it-does-not-matter"}}]' \
    $CLUSTER_DNS:9093/api/v1/alerts

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service ps -f desired-state=Running go-demo_main
```


<!-- .slide: data-background="img/jenkins-alertmanager-scale.png" data-background-size="contain" -->


## Alertmanager From Jenkins

---

```bash
docker service rm monitor_alert-manager

docker secret rm alert_manager_config
```


## Alertmanager From Jenkins

---

```bash
source creds

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
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
  - name: 'jenkins-go-demo_main'
    webhook_configs:
      - send_resolved: false
        url: 'http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=1'
" | docker secret create alert_manager_config -
```


## Alertmanager From Jenkins

---

```bash
curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-slack.yml

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

docker service scale go-demo_main=3

docker service update \
    --label-add com.df.alertIf.1=@node_mem_limit:0.01 \
    exporter_node-exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "https://devops20.slack.com/messages/C59EWRE2K/team/U2ZLK8MLM"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Alertmanager From Jenkins

---

```bash
docker service update \
    --label-add com.df.alertIf.1=@node_mem_limit:0.8 \
    exporter_node-exporter

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.01 \
    go-demo_main

exit

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service ps -f desired-state=Running go-demo_main
```


<!-- .slide: data-background="img/jenkins-slack-scale.png" data-background-size="contain" -->
## Hands-On Time

---

# Self-Adapting Infra


## Manual Scaling

---

```bash
exit

aws autoscaling describe-auto-scaling-groups | jq "."

aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"devops22-NodeAsg-\")).AutoScalingGroupName"

aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"devops22-NodeAsg-\")).DesiredCapacity"
```


## Manual Scaling

---

```bash
ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
    | jq -r ".AutoScalingGroups[] \
    | select(.AutoScalingGroupName \
    | startswith(\"devops22-NodeAsg-\")).AutoScalingGroupName")

aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name $ASG_NAME --desired-capacity 1

aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $ASG_NAME \
    | jq ".AutoScalingGroups[0].DesiredCapacity"
```


## Manual Scaling

---

```bash
aws ec2 describe-instances | jq -r ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | startswith(\"devops22-NodeVpcSG\")).InstanceId"

INSTANCE_ID=$(aws ec2 describe-instances | jq -r \
    ".Reservations[].Instances[] \
    | select(.SecurityGroups[].GroupName \
    | startswith(\"devops22-NodeVpcSG\")).InstanceId")

aws ec2 describe-instance-status --instance-ids $INSTANCE_ID \
    | jq -r ".InstanceStatuses[0].InstanceStatus.Status"
```


## Manual Scaling

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit
```


<!-- .slide: data-background="img/manual-scaling.png" data-background-size="contain" -->


## Manual Scaling

---

```bash
aws autoscaling update-auto-scaling-group \
    --auto-scaling-group-name $ASG_NAME --desired-capacity 0

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

curl "https://raw.githubusercontent.com/vfarcic/docker-aws-cli/master/Dockerfile"

curl "https://raw.githubusercontent.com/vfarcic/docker-aws-cli/master/docker-compose.yml"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Scaling Job

---

```bash
curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/jenkins-aws-secret.yml

cat jenkins.yml

source creds

echo "
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
export STACK_NAME=devops22
" | docker secret create aws -

docker stack deploy -c jenkins.yml jenkins
```


## Scaling Job

---

```bash
exit

open "http://$CLUSTER_DNS/jenkins/configure"

open "http://$CLUSTER_DNS/jenkins/view/all/newJob"
```

* Type *aws-scale* as the job name
* Select *Pipeline* as the job type
* Click the *OK* button
* Click the *Build Triggers* tab
* Select the *Trigger builds remotely* checkbox
* Type *DevOps22* as the *Authentication Token*
* Type the script that follows in the *Pipeline Script* field


## Scaling Job

---

```groovy
pipeline {
  agent {
    label "prod"
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '2'))
    disableConcurrentBuilds()
  }
  parameters {
    string(
      name: "scale",
      defaultValue: "1",
      description: "The number of worker nodes to add or remove"
    )
  }
  stages {
    stage("scale") {
      steps {
        git "https://github.com/vfarcic/docker-aws-cli.git"
        script {
          def asgName = sh(
            script: "source /run/secrets/aws && docker-compose run --rm asg-name",
            returnStdout: true
          ).trim()
          if (asgName == "") {
            error "Could not find auto-scaling group"
          }
          def asgDesiredCapacity = sh(
            script: "source /run/secrets/aws && ASG_NAME=${asgName} docker-compose run --rm asg-desired-capacity",
            returnStdout: true
          ).trim().toInteger()
          def asgNewCapacity = asgDesiredCapacity + scale.toInteger()
          if (asgNewCapacity < 1) {
            error "The number of worker nodes is already at the minimum capacity of 1"
          } else if (asgNewCapacity > 3) {
            error "The number of worker nodes is already at the maximum capacity of 3"
          } else {
            sh "source /run/secrets/aws && ASG_NAME=${asgName} ASG_DESIRED_CAPACITY=${asgNewCapacity} docker-compose run --rm asg-update-desired-capacity"
            echo "Changed the number of worker nodes from ${asgDesiredCapacity} to ${asgNewCapacity}"
          }
        }
      }
    }
  }
  post {
    success {
      slackSend(
        color: "good",
        message: """Worker nodes were scaled.
Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
${env.BUILD_URL}console"""
      )
    }
    failure {
      slackSend(
        color: "danger",
        message: """Worker nodes could not be scaled.
Please check Jenkins logs for the job ${env.JOB_NAME} #${env.BUILD_NUMBER}
${env.BUILD_URL}console"""
      )
    }
  }
}
```


## Scaling Job

---

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

ssh -i $KEY_NAME.pem docker@$CLUSTER_IP

docker node ls

exit
```


<!-- .slide: data-background="img/jenkins-scaling.png" data-background-size="contain" -->


## Scaling Job

---

```bash
curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=2"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=1"
```


## Scaling Job

---

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=-2"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls

exit

curl -XPOST -i \
    "http://$CLUSTER_DNS/jenkins/job/aws-scale/buildWithParameters?token=DevOps22&scale=-1"
```


## Automated Scaling

---

```bash
open "http://$CLUSTER_DNS/monitor"

# (sum(node_memory_MemTotal) BY (instance) - sum(node_memory_MemFree + node_memory_Buffers + node_memory_Cached) BY (instance)) / sum(node_memory_MemTotal) BY (instance)

# sum(node_memory_MemTotal) - sum(node_memory_MemFree + node_memory_Buffers + node_memory_Cached)

# sum(node_memory_MemTotal)

# (sum(node_memory_MemTotal) - sum(node_memory_MemFree + node_memory_Buffers + node_memory_Cached)) / sum(node_memory_MemTotal)

ssh -i workshop.pem docker@$CLUSTER_IP

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-aws.yml

cat exporters.yml
```


## Automated Scaling

---

```bash
docker stack rm exporter

docker stack deploy -c exporters.yml exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

# (sum(node_memory_MemTotal{job="exporter_node-exporter-manager"}) - sum(node_memory_MemFree{job="exporter_node-exporter-manager"} + node_memory_Buffers{job="exporter_node-exporter-manager"} + node_memory_Cached{job="exporter_node-exporter-manager"})) / sum(node_memory_MemTotal{job="exporter_node-exporter-manager"}) > 0.8

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack rm monitor

docker secret rm alert_manager_config
```


## Automated Scaling

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


## Automated Scaling

---

```bash
DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

docker stack ps -f desired-state=running monitor

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.1" \
    exporter_node-exporter-manager

exit

open "http://$CLUSTER_DNS/monitor/alerts"
```


<!-- .slide: data-background="img/slack-scaling.png" data-background-size="contain" -->


## Automated Scaling

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.8" \
    exporter_node-exporter-manager

docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.1" \
    exporter_node-exporter-worker

exit

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/aws-scale/activity"
```


## Automated Scaling

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls
```


<!-- .slide: data-background="img/infra-scaling.png" data-background-size="contain" -->


## Automated Scaling

---

```bash
docker service update \
    --label-add "com.df.alertIf.2=@node_mem_limit_total_above:0.8" \
    exporter_node-exporter-worker

docker service update \
    --label-add "com.df.alertIf.3=@node_mem_limit_total_below:0.9" \
    exporter_node-exporter-worker

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP

docker node ls
```


## Automated Scaling

---

```bash
docker service update \
    --label-add "com.df.alertIf.3=@node_mem_limit_total_below:0.05" \
    exporter_node-exporter-worker

exit
```
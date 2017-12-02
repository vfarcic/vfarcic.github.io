## Hands-On Time

---

# Self-Adapting Infra


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


## Automated Scaling

---

```bash
open "http://$CLUSTER_DNS/monitor/alerts"

# (sum(node_memory_MemTotal{job="exporter_node-exporter-manager"}) - sum(node_memory_MemFree{job="exporter_node-exporter-manager"} + node_memory_Buffers{job="exporter_node-exporter-manager"} + node_memory_Cached{job="exporter_node-exporter-manager"})) / sum(node_memory_MemTotal{job="exporter_node-exporter-manager"}) > 0.8

ssh -i workshop.pem docker@$CLUSTER_IP

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
```

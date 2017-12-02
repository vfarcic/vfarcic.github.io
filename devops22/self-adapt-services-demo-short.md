## Hands-On Time

---

# Self-Adapting Services


# Service Limits

---

```bash
curl -o go-demo.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-scale.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo
```


# Jenkins Service

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
```


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


<!-- .slide: data-background="img/jenkins-master-agent.png" data-background-size="contain" -->


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


## Alertmanager From Jenkins

---

```bash
curl -X POST "http://$CLUSTER_DNS/jenkins/job/service-scale/buildWithParameters?token=DevOps22&service=go-demo_main&scale=-123"

docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.01 \
    go-demo_main

exit

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service ps -f desired-state=Running go-demo_main
```


<!-- .slide: data-background="img/jenkins-slack-scale.png" data-background-size="contain" -->


## Alertmanager From Jenkins

---

```bash
docker service update \
    --label-add com.df.alertIf=@service_mem_limit:0.8 \
    go-demo_main
```
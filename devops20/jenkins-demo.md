## Hands-On Time

---

# Jenkins Service


## Jenkins Service

---

```bash
curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy-aws.yml

cat jenkins.yml
```


## Jenkins Service

---

```bash
echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c jenkins.yml jenkins

docker stack ps jenkins

exit

open "http://$CLUSTER_DNS/jenkins"
```


## Simulating Failure

---

```bash
# Create a job

open "http://$CLUSTER_DNS/jenkins/exit"

open "http://$CLUSTER_DNS/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Jenkins Agents

---

```bash
curl -o jenkins-agent.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

cat jenkins-agent.yml

docker node ls

PRIVATE_IP=[...]

export JENKINS_URL="http://$PRIVATE_IP/jenkins"

LABEL=prod EXECUTORS=2 docker stack deploy -c jenkins-agent.yml \
    jenkins-agent-prod
```


## Running Jenkins Agents

---

```bash
source creds

export JENKINS_URL="http://$CLUSTER_DNS/jenkins"

LABEL=test EXECUTORS=3 docker stack deploy -c jenkins-agent.yml \
    jenkins-agent-test

exit

open "http://$CLUSTER_DNS/jenkins/computer"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Jenkins Credentials

---

```bash
open "http://$CLUSTER_DNS/jenkins/credentials/store/system/domain/_/"
```

* Login with *admin*/*admin*
* Click the *Add Credentials* link
* Type your Docker Hub username and password
* Type *docker* as the *ID*
* Click the *OK* button


## Jenkins Shared Libraries

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Navigate to *Global Pipeline Libraries*
* Click the *Add* button
* Type *my-lib* as the *Name*
* Type *master* as the *Default version*
* Select the *Load implicitly* checkbox
* Select the *Modern SCM* radio button
* Select the *GitHub* radio button
* Type *vfarcic* as the *Owner*
* Select *jenkins-shared-libraries* as the *Repository*
* Click the *Save* button


## Jenkinsfile

---

```bash
open "https://github.com/vfarcic/go-demo-2/blob/master/Jenkinsfile"

ssh -i workshop.pem docker@$CLUSTER_IP

source creds

echo "hostIp=$CLUSTER_DNS
dockerHubUser=$DOCKER_HUB_USER
" | docker secret create cluster-info.properties -

docker service update --secret-add cluster-info.properties \
    jenkins-agent-test_main

exit
```


## Building All Branches

---

```bash
open "http://$CLUSTER_DNS/jenkins/blue/pipelines"
```

* Click the *New Pipeline* button
* Select *GitHub*
* Enter the access token
* Select *vfarcic* as repository organization
* Choose *New Pipeline*
* Type *go-demo-2* as repository
* Click the *Create Pipeline* button


## Verifying The Deployment

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo-2
```

## Hands-On Time

---

## Continuous Deployment With Jenkins


## Jenkins Service

---

```bash
curl -o jenkins.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy-aws-full.yml

cat jenkins.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

source info

echo "hostIp=$CLUSTER_DNS
dockerHubUser=vfarcic
" | docker secret create cluster-info.properties -
```


## Jenkins Service

---

```bash
AGENT_LABELS="-labels test -labels prod" \
    docker stack deploy -c jenkins.yml jenkins

docker stack ps jenkins

exit

open "https://github.com/vfarcic/go-demo-2/blob/master/Jenkinsfile"

open "https://github.com/vfarcic/jenkins-shared-libraries/blob/master/vars/dockerRelease.groovy"

open "http://$CLUSTER_DNS/jenkins"
```

* Login using *admin* as *username* and *password*


## Agents & Credentials

---

```bash
open "http://$CLUSTER_DNS/jenkins/computer"

open "http://$CLUSTER_DNS/jenkins/credentials/store/system/domain/_/newCredentials"
```

* Type your Docker Hub *username* and *password*
* Type *docker* as *ID*


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


## Going Back

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo-2
```
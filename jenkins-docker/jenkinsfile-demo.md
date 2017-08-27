## Hands-On Time

---

# Pipeline in a Version Control System (VCS)


## Jenkinsfile

---

```bash
open "https://github.com/vfarcic/go-demo-2/blob/master/Jenkinsfile"

echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

CLUSTER_DNS=[...]

DOCKER_HUB_USER=[...]

echo "hostIp=$CLUSTER_DNS
dockerHubUser=$DOCKER_HUB_USER
" | docker secret create cluster-info.properties -

docker service update --secret-add cluster-info.properties \
    jenkins-agent-test_main
```


## Pipeline From Source Code Management (SCM)

---

```bash
open "http://$CLUSTER_DNS/jenkins/blue/pipelines"
```

* Click the *New Pipeline* button
* Select *Git*
* Type *https://github.com/vfarcic/go-demo-2.git* as *Repository URL*
* Click the *Save* button


## Master Branch

---

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2-scm/activity"
```

* Click the *Run* button

```bash
open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2-test/tags"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"
```


## Shared Library

---

```bash
open "https://goo.gl/GWneBx"
```

* Open *dockerBuild.groovy*
* Open *dockerRelease.groovy*


## Shared Library

---

```
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Scroll to *Global Pipeline Libraries*
* Set *workshop-mb* as *Default version*
* Click the *Save* button


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

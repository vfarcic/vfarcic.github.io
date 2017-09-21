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

exit

echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

CLUSTER_DNS=[...]
```


## Jenkins Service

---

```bash
echo "hostIp=$CLUSTER_DNS
dockerHubUser=vfarcic
" | docker secret create cluster-info.properties -

TAG=workshop AGENT_LABELS="test prod" \
    docker stack deploy -c jenkins.yml jenkins

exit

open "https://github.com/vfarcic/go-demo-2/blob/master/Jenkinsfile"

open "http://$CLUSTER_DNS/jenkins/computer"
```


## Jenkins Shared Libraries

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Click *Global Pipeline Libraries* > *Add*
* Set *my-shared-library* as *Name*
* Set *workshop* as *Default version*
* Check *Load implicitly*
* Check *Modern SCM*
* Check *GitHub*
* Set *vfarcic* as *Owner*
* Set *jenkins-shared-libraries* as *Repository*
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


## Going Back

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP
```
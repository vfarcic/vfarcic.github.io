## Hands-On Time

---

# Pipeline in a Version Control System (VCS)


## Removing The Old Job

---

```bash
open "http://$CLUSTER_DNS/jenkins/job/go-demo-2"
```

* Click the *Delete Pipeline* button


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


## Pipeline From Source Code Management (SCM)

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

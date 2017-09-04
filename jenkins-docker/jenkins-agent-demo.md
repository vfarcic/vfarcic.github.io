## Hands-On Time

---

# Jenkins Agent Services


## Running Jenkins Agents

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

cat docker-flow-stacks/jenkins/vfarcic-jenkins-agent.yml

docker node ls

PRIVATE_IP=[...]

export JENKINS_URL="http://$PRIVATE_IP/jenkins"

LABEL=prod EXECUTORS=2 docker stack deploy \
    -c docker-flow-stacks/jenkins/vfarcic-jenkins-agent.yml \
    jenkins-agent-prod

exit
```


## Running Jenkins Agents

---

```bash
echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

CLUSTER_DNS=[...]

export JENKINS_URL="http://$CLUSTER_DNS/jenkins"

LABEL=test EXECUTORS=3 docker stack deploy \
    -c docker-flow-stacks/jenkins/vfarcic-jenkins-agent.yml \
    jenkins-agent-test

exit

open "http://$CLUSTER_DNS/jenkins/computer"
```


## Scaling Jenkins Agents

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service scale jenkins-agent-test_main=2

exit

open "http://$CLUSTER_DNS/jenkins/computer"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service scale jenkins-agent-test_main=1

exit
```

## Hands-On Time

---

# Jenkins Agent Services

Note:
jenkins-agent-demo.sh


## Running Jenkins Agents

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

curl -o jenkins-agent.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

cat jenkins-agent.yml

docker node ls

PRIVATE_IP=[...]

export JENKINS_URL="http://$PRIVATE_IP/jenkins"

LABEL=prod \
    docker stack deploy -c jenkins-agent.yml jenkins-agent-prod

exit
```


## Running Jenkins Agents

---

```bash
open "http://$CLUSTER_DNS/jenkins/computer"

echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

PUBLIC_IP=[...]

export JENKINS_URL="http://$PUBLIC_IP/jenkins"

LABEL=test EXECUTORS=3 \
    docker stack deploy -c jenkins-agent.yml jenkins-agent-test

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

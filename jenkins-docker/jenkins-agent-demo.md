## Hands-On Time

---

# Jenkins Agent Services


## Running Jenkins Agents

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

curl -o jenkins-agent.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

cat jenkins-agent.yml

docker node ls

export JENKINS_URL=[...] # e.g. http://[INTERNAL_IP]/jenkins

LABEL=prod \
    docker stack deploy -c jenkins-agent.yml jenkins-agent-prod

exit

open "http://$CLUSTER_DNS/jenkins/computer"
```


## Running Jenkins Agents

---

```bash
echo $CLUSTER_DNS

ssh -i workshop.pem docker@$CLUSTER_IP

export JENKINS_URL=[...] # e.g. http://[PUBLIC_IP]/jenkins

LABEL=test \
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

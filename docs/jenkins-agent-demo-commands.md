## Hands-On Time

---

# Jenkins Agents


## Running Jenkins Agents

---

```bash
cd ~

curl -o jenkins-agent.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-agent.yml

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
```

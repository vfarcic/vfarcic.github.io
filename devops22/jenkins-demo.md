## Hands-On Time

---

# Tasks Executor


## Jenkins Service

---

```bash
curl -L -o jenkins.yml https://goo.gl/tCKG7Y

cat jenkins.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export SLACK_IP=$(ping -c 1 devops20.slack.com \
    | awk -F'[()]' '/PING/{print $2}')

docker stack deploy -c jenkins.yml jenkins

docker stack ps jenkins
```


## Jenkins Job

---

```bash
open "http://$(docker-machine ip swarm-1)/jenkins/job/service-scale/configure"

open "http://$(docker-machine ip swarm-1)/jenkins/blue/organizations/jenkins/service-scale/activity"

# Click the *Run* button > it fails
```

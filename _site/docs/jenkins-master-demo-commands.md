## Hands-On Time

---

# Jenkins Master


## Running Jenkins Master

---

```bash
source creds

docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/docker-flow-stacks

cd docker-flow-stacks/jenkins

docker login -u $DOCKER_HUB_USER

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

TAG=workshop docker stack deploy \
    -c vfarcic-jenkins-df-proxy-aws.yml jenkins
```

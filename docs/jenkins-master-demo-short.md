## Hands-On Time

---

# Jenkins Master Service


## Running Containers

---

```bash
docker container run -d --name jenkins -p 8080:8080 jenkins:alpine

docker container ls

PRIVATE_IP=$(docker inspect jenkins | \
    jq -r '.[0].NetworkSettings.IPAddress')

curl -i "http://$PRIVATE_IP:8080"

docker container rm -f jenkins

docker container ls
```


## Problems

---

* No high availability
* No fault tolerance
* It's not 2014


## Running Jenkins Stack

---

```bash
curl -L -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/jenkins-df-proxy.yml

cat jenkins.yml

docker stack deploy -c jenkins.yml jenkins

exit

open "http://$CLUSTER_DNS/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack rm jenkins

exit
```


## Problems

---

* Not Fully Automated


## Git In A Container

---

```bash
open https://github.com/vfarcic/docker-flow-stacks/blob/master/util/git/Dockerfile

ssh -i workshop.pem docker@$CLUSTER_IP

docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/docker-flow-stacks

docker container ls

ls -l
```


## Building Jenkins Image

---

```bash
source creds

cd docker-flow-stacks/jenkins

cat Dockerfile

cat security.groovy

cat plugins.txt

docker image build -t $DOCKER_HUB_USER/jenkins:workshop .

docker login -u $DOCKER_HUB_USER

docker image push $DOCKER_HUB_USER/jenkins:workshop
```


## Running Jenkins Without Manual Setup

---

```bash
cat vfarcic-jenkins-df-proxy.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

TAG=workshop docker stack deploy \
    -c vfarcic-jenkins-df-proxy.yml jenkins

exit

open "http://$CLUSTER_DNS/jenkins"
```


## Simulating Failure

---

```bash
# Create a job

open "http://$CLUSTER_DNS/jenkins/exit"

open "http://$CLUSTER_DNS/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps jenkins

docker stack rm jenkins
```


## Problems

---

* State is not preserved


## Preserving State

---

```bash
source creds

cd docker-flow-stacks/jenkins

cat vfarcic-jenkins-df-proxy-aws.yml

TAG=workshop docker stack deploy \
    -c vfarcic-jenkins-df-proxy-aws.yml jenkins
```


## Simulating Failure

---

```bash
exit

open "http://$CLUSTER_DNS/jenkins"

# Create a job

open "http://$CLUSTER_DNS/jenkins/exit"

open "http://$CLUSTER_DNS/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP
```

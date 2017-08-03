## Hands-On Time

---

# Jenkins Master Service


## Preparing

---

```bash
export CLUSTER_DNS=[...]

export CLUSTER_IP=[...]
```


## Running Containers

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker container run -d --name jenkins -p 8080:8080 jenkins:alpine

docker container ls # Wait until it is up and running

PRIVATE_IP=[...] # e.g. 172.31.21.216

curl -i "http://$PRIVATE_IP:8080"

docker container rm -f jenkins

docker container ls
```


## Running Containers

---

* No high availability
* No fault tolerance
* It's not 2014


## Running Services

---

```bash
docker service create --name jenkins -p 8080:8080 jenkins:alpine

docker service ps jenkins

exit

open "http://$CLUSTER_DNS:8080"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm jenkins
```


## Running Jenkins Stack

---

```bash
curl -o jenkins.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/jenkins.yml

cat jenkins.yml

docker stack deploy -c jenkins.yml jenkins

docker stack ps jenkins

exit

open "http://$CLUSTER_DNS:8080/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack rm jenkins
```


## Running DFP Stack

---

```bash
curl -o proxy.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

cat proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

docker stack ps proxy
```


## Running Jenkins Through DFP

---

```bash
curl -o jenkins.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/jenkins-df-proxy.yml

cat jenkins.yml

docker stack deploy -c jenkins.yml jenkins

exit

open "http://$CLUSTER_DNS/jenkins"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack rm jenkins
```


## Building Jenkins Image

---

```bash
exit

git clone https://github.com/vfarcic/docker-flow-stacks

cat docker-flow-stacks/jenkins/Dockerfile

cat docker-flow-stacks/jenkins/security.groovy

cat docker-flow-stacks/jenkins/plugins.txt

DOCKER_HUB_USER=[...]

docker image build -t $DOCKER_HUB_USER/jenkins:workshop \
    docker-flow-stacks/jenkins/.

docker image push $DOCKER_HUB_USER/jenkins:workshop
```


## Running Jenkins Without Manual Setup

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

curl -o jenkins.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy.yml

cat jenkins.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

export TAG=workshop

export HUB_USER=[...]

docker stack deploy -c jenkins.yml jenkins
```


## Running Jenkins Without Manual Setup

---

```bash
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

docker stack rm jenkins
```


## Preserving State

---

```bash
curl -o jenkins.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/jenkins/vfarcic-jenkins-df-proxy-aws.yml

cat jenkins.yml

export TAG=workshop

export HUB_USER=[...]

docker stack deploy -c jenkins.yml jenkins
```


## Simulating Failure

---

```bash
exit

open "http://$CLUSTER_DNS/jenkins"

# Create a job

open "http://$CLUSTER_DNS/jenkins/exit"

open "http://$CLUSTER_DNS/jenkins"
```


## Gist

---

# Gist [https://goo.gl/uRGgkM](https://goo.gl/uRGgkM)

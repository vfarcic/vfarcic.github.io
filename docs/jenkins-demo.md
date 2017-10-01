## Hands-On Time

---

# Running Jenkins

# As a Docker Service


## Running Jenkins

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


## Building Jenkins Image

---

```bash
docker container run --rm -it -v $PWD:/repos vfarcic/git \
    git clone https://github.com/vfarcic/docker-flow-stacks

cd docker-flow-stacks/jenkins

cat Dockerfile

cat security.groovy

cat plugins.txt
```


## Building Jenkins Image

---

```bash
source creds

docker image build -t $DOCKER_HUB_USER/jenkins:workshop .

docker login

docker image push $DOCKER_HUB_USER/jenkins:workshop
```


### Jenkins Agents

# Initialize Cluster

---

```bash
cat test-swarm.tf

terraform apply -target aws_instance.test-swarm-manager \
  -var swarm_init=true -var test_swarm_managers=1 -var rexray=true

terraform refresh
```


### Jenkins Agents

# Add Nodes

---

```bash
export TF_VAR_test_swarm_manager_token=$(ssh -i devops21.pem \
  ubuntu@$(terraform output test_swarm_manager_1_public_ip) \
  docker swarm join-token -q manager)

export TF_VAR_test_swarm_manager_ip=$(terraform \
  output test_swarm_manager_1_private_ip)

terraform apply -target aws_instance.test-swarm-manager \
  -var rexray=true

ssh -i devops21.pem ubuntu@$(terraform \
  output test_swarm_manager_1_public_ip) docker node ls
```


### Jenkins Agents

# Service

---

```bash
terraform output swarm_manager_1_private_ip

ssh -i devops21.pem ubuntu@$(terraform output test_swarm_manager_1_public_ip)

export JENKINS_IP=[...] # Manager private IP

curl -o jenkins-agent.yml https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/jenkins/jenkins-swarm-agent-secrets.yml

cat jenkins-agent.yml

echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -

docker stack deploy -c jenkins-agent.yml jenkins-agent
```


### Jenkins Agents

# Service

---

```bash
exit

open "http://$(terraform output swarm_manager_1_public_ip)/jenkins/computer"
```


### Jenkins Agents

# Registry Service

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
    output test_swarm_manager_1_public_ip)

curl -o registry.yml \
    https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/docker/registry-rexray-external.yml

docker stack deploy -c registry.yml registry

exit
```


### Jenkins Agents

# Env. Variables

---

```bash
terraform output swarm_manager_1_private_ip

open "http://$(terraform output swarm_manager_1_public_ip)/\
jenkins/configure"
```

* Click *Environment Variables*
* Click *Add*
* Type *PROD_IP* as *Name*
* Paste the output as *Value*
* Click *Save*


# Pipeline Job

---

```groovy
pipeline {
  agent {
    label "docker"
  }
  stages {
    stage("Unit") {
      steps {
        git url: "https://github.com/vfarcic/go-demo.git", branch: "multi-stage-builds"
        sh "docker image build -t go-demo ."
      }
    }
    stage("Staging") {
      steps {
        sh "docker-compose -f docker-compose-test-local.yml up -d staging-dep"
        sh 'HOST_IP=localhost docker-compose -f docker-compose-test-local.yml run --rm staging'
      }
    }
    stage("Publish") {
      steps {
        sh "docker image tag go-demo localhost:5000/go-demo"
        sh "docker image tag go-demo localhost:5000/go-demo:2.${env.BUILD_NUMBER}"
        sh "docker image push localhost:5000/go-demo"
        sh "docker image push localhost:5000/go-demo:2.${env.BUILD_NUMBER}"
      }
    }
    stage("Prod-like") {
      steps {
        echo "A production-like cluster is yet to be created"
        // sh "DOCKER_HOST=tcp://${env.PROD_LIKE_IP}:2375 docker service update --image localhost:5000/go-demo:2.${env.BUILD_NUMBER} go-demo_main"
        // sh "HOST_IP=${env.TEST_IP} docker-compose -f docker-compose-test-local.yml run --rm production"
      }
    }
    stage("Production") {
      steps {
        sh "DOCKER_HOST=tcp://${env.PROD_IP}:2375 docker service update --image localhost:5000/go-demo:2.${env.BUILD_NUMBER} go-demo_main"
        try {
          sh "HOST_IP=${env.PROD_IP} docker-compose -f docker-compose-test-local.yml run --rm production-loop"
        } catch (e) {
          sh "DOCKER_HOST=tcp://${env.PROD_IP}:2375 docker service update --rollback go-demo"
        }
      }
    }
  }
  post {
    always {
      sh "docker-compose -f docker-compose-test-local.yml down"
    }
  }
}
```


# Pipeline Job

---

* Click *New Item*
* Type *go-demo*, select *Pipeline*, click *OK*
* Paste the code into the *Pipeline Script* field
* Click the *Save* button
* Click *Build Now*


# Build Result

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker stack ps go-demo

curl $(terraform output swarm_manager_1_public_ip)/demo/hello
```


# Jenkins Failover

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

docker stack ps jenkins

IP=[...]  # Manager private IP

docker -H tcp://$IP:2375 rm -f $(docker -H tcp://$IP:2375 \
    ps -qa -f label=com.docker.swarm.service.name=jenkins_main)

docker stack ps jenkins

exit

open "http://$(terraform output swarm_manager_1_public_ip)/jenkins"
```


# Cleanup

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker stack rm jenkins

ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker stack rm registry

ssh -i devops21.pem ubuntu@$(terraform \
  output test_swarm_manager_1_public_ip) docker stack rm registry

ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker volume rm jenkins_main

ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip) docker volume rm registry
```

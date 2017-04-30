## Hands-On Time

---

# Running Jenkins

# Inside a Cluster


# Jenkins Service

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

curl -o jenkins.yml \
    https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/jenkins/jenkins-rexray-df-proxy.yml

cat jenkins.yml

docker stack deploy -c jenkins.yml jenkins

docker stack ps jenkins

exit

open "http://$(terraform output swarm_manager_1_public_ip)/jenkins"
```


# Jenkins Setup

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

docker run -it --rm \
  --volume-driver rexray -v jenkins_main:/var/jenkins_home \
  alpine cat /var/jenkins_home/secrets/initialAdminPassword

# Copy the password
```

* Paste the *Administrator password*
* Select *Install suggested plugins*
* Type *admin* as both *user* and *password*
* Fill in the rest of the fields and press *Save And Finish*
* Click *Start Using Jenkins*


# Jenkins Failover

---

```bash
docker stack ps jenkins

IP=[...]  # Manager private IP

docker -H tcp://$IP:2375 rm -f $(docker -H tcp://$IP:2375 \
    ps -qa -f label=com.docker.swarm.service.name=jenkins_main)

docker stack ps jenkins

exit

open "http://$(terraform output swarm_manager_1_public_ip)/jenkins"
```


### Jenkins Agents

# Jenkins Swarm Plugin

---

```bash
open "http://$(terraform output swarm_manager_1_public_ip)/\
jenkins/pluginManager/available"
```

* Select *Self-Organizing Swarm Plug-in Modules*
* Select *Blue Ocean*
* Click *Install without restart*


### Jenkins Agents

# Initialize Cluster

---

```bash
cat test-swarm.tf

terraform plan -target aws_instance.test-swarm-manager \
  -var swarm_init=true -var test_swarm_managers=1

terraform apply -target aws_instance.test-swarm-manager \
  -var swarm_init=true -var test_swarm_managers=1 -var rexray=true

ssh -i devops21.pem ubuntu@$(terraform output \
  test_swarm_manager_1_public_ip) docker node ls
```


### Jenkins Agents

# Add Nodes

---

```bash
cat test-swarm.tf

export TF_VAR_test_swarm_manager_token=$(ssh -i devops21.pem \
  ubuntu@$(terraform output test_swarm_manager_1_public_ip) \
  docker swarm join-token -q manager)

export TF_VAR_test_swarm_manager_ip=$(terraform \
  output test_swarm_manager_1_private_ip)

terraform plan -target aws_instance.test-swarm-manager

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

docker stack ps registry

docker pull localhost:5000/go-demo

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
        git "https://github.com/vfarcic/go-demo.git"
        sh "docker-compose -f docker-compose-test.yml run --rm unit"
        sh "docker build -t go-demo ."
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
        sh "docker tag go-demo localhost:5000/go-demo"
        sh "docker tag go-demo localhost:5000/go-demo:2.${env.BUILD_NUMBER}"
        sh "docker push localhost:5000/go-demo"
        sh "docker push localhost:5000/go-demo:2.${env.BUILD_NUMBER}"
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
        sh "HOST_IP=${env.PROD_IP} docker-compose -f docker-compose-test-local.yml run --rm production"
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

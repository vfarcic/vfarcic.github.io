## Hands-On Time

---

# Deploying To Production


## Creating a Release

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

source creds

docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:1.0

docker image push $DOCKER_HUB_USER/go-demo-2:1.0
```


## Rolling Updates

---

```bash
docker stack ps -f desired-state=running go-demo-2

docker service update --image $DOCKER_HUB_USER/go-demo-2:1.0 \
  go-demo-2_main

watch "docker stack ps -f desired-state=running go-demo-2"
```


## Creating a Release

---

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:2.0

docker image push $DOCKER_HUB_USER/go-demo-2:2.0
```


## Testing Rolling Updates

---

```bash
docker node ls

PRIVATE_IP=[...]

docker service update --image $DOCKER_HUB_USER/go-demo-2:2.0 \
  go-demo-2_main

watch "curl -i \"http://$PRIVATE_IP/demo/hello\" \
    && docker stack ps -f desired-state=running go-demo-2"
```


## Creating a Release

---

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:3.0

docker image push $DOCKER_HUB_USER/go-demo-2:3.0
```


## Testing Rolling Updates

---

```bash
exit

open "https://github.com/vfarcic/go-demo-2/blob/master/production_test.go"

ssh -i workshop.pem docker@$CLUSTER_IP

source creds

docker service update --image $DOCKER_HUB_USER/go-demo-2:3.0 \
    go-demo-2_main
```


## Testing Rolling Updates

---

```bash
docker container run --rm -it -v $PWD/go-demo-2:/compose \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e HOST_IP=$CLUSTER_DNS \
    vfarcic/compose docker-compose run --rm production
```


## Rolling Updates

---

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:4.0

docker image push $DOCKER_HUB_USER/go-demo-2:4.0

docker service update --image $DOCKER_HUB_USER/go-demo-2:4.0 \
    go-demo-2_main
```


## Rolling Back

---

```bash
CLUSTER_DNS=http://this-address-does-not-exist.com

docker container run --rm -it -v $PWD/go-demo-2:/compose \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e HOST_IP=$CLUSTER_DNS \
    vfarcic/compose docker-compose run --rm production

docker stack ps -f desired-state=running go-demo-2

docker service update --rollback go-demo-2_main

watch "docker stack ps -f desired-state=running go-demo-2"

exit
```


## Jenkins Pipeline

---

```bash
open "http://$CLUSTER_DNS/jenkins/job/go-demo-2/configure"
```


## Jenkins Pipeline

---

```groovy
pipeline {
...
  stages {
    stage("build") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
        stash name: "compose", includes: "docker-compose.yml"
        ...
      }
    }
    ...
    stage("release") {
      steps {
        sh "docker image tag ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER} ${env.DOCKER_HUB_USER}/go-demo-2:${env.BUILD_NUMBER}"
        sh "docker image push $DOCKER_HUB_USER/go-demo-2:${env.BUILD_NUMBER}"
      }
    }
    stage("deploy") {
      agent {
        label "prod"
      }
      steps {
        unstash "compose"
        script {
          try {
            sh "docker service update --image $DOCKER_HUB_USER/go-demo-2:${env.BUILD_NUMBER} go-demo-2_main"
            sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm production"
          } catch (e) {
            sh "docker service update --rollback go-demo-2_main"
            error "Failed to update the service"
          }
        }
      }
    }
    ...
```


## Jenkins Pipeline

---

```groovy
import java.text.SimpleDateFormat

pipeline {
  agent {
    label "test"
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: "2"))
    disableConcurrentBuilds()
  }
  environment {
    SERVICE_PATH = "/demo-${env.BUILD_NUMBER}"
    HOST_IP = "[...]" // This is AWS DNS
    DOCKER_HUB_USER = "[...]" // This is Docker Hub user
  }
  stages {
    stage("build") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
        stash name: "compose", includes: "docker-compose.yml"
        sh "docker image build -t ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER} ."
        withCredentials([usernamePassword(
          credentialsId: "docker",
          usernameVariable: "USER",
          passwordVariable: "PASS"
        )]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker image push ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER}"
      }
    }
    stage("functional") {
      steps {
        sh "TAG=beta-${env.BUILD_NUMBER} docker stack deploy -c stack-test.yml go-demo-2-beta-${env.BUILD_NUMBER}"
        sh "docker image build -f Dockerfile.test -t ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER} ."
        sh "docker image push ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER}"
        sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm functional"
      }
    }
    stage("release") {
      steps {
        sh "docker image tag ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER} ${env.DOCKER_HUB_USER}/go-demo-2:${env.BUILD_NUMBER}"
        sh "docker image push $DOCKER_HUB_USER/go-demo-2:${env.BUILD_NUMBER}"
      }
    }
    stage("deploy") {
      agent {
        label "prod"
      }
      steps {
        unstash "compose"
        script {
          try {
            sh "docker service update --image $DOCKER_HUB_USER/go-demo-2:${env.BUILD_NUMBER} go-demo-2_main"
            sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm production"
          } catch (e) {
            sh "docker service update --rollback go-demo-2_main"
            error "Failed to update the service"
          }
        }
      }
    }
  }
  post {
    always {
      sh "docker stack rm go-demo-2-beta-${env.BUILD_NUMBER}"
      sh "docker system prune -f"
    }
  }
}
```


## Jenkins Pipeline

---

```bash
echo $CLUSTER_DNS
```

* Replace [...]
* Click the *Save* button

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo-2

exit
```

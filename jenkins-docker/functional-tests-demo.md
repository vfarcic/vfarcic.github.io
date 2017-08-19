## Hands-On Time

---

# Functional Testing

Note:
functional-tests-demo.sh


## Production Services

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo-2.yml \
  https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

cat go-demo-2.yml

docker stack deploy -c go-demo-2.yml go-demo-2

docker stack ps go-demo-2

exit

curl -i "http://$CLUSTER_DNS/demo/hello"
```


## Services Under Test

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo-2-test.yml \
  https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack-test.yml

cat go-demo-2-test.yml

TAG=[...] # Find the tag from Docker Hub

SERVICE_PATH=/demo-test \
  docker stack deploy -c go-demo-2-test.yml go-demo-2-test

docker stack ps -f desired-state=running go-demo-2-test
```


## Coexistence

---

```bash
exit

curl -i "http://$CLUSTER_DNS/demo/hello"

curl -i "http://$CLUSTER_DNS/demo-test/hello"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## More Services Under Test

---

```bash
SERVICE_PATH=/demo-something-else \
  docker stack deploy -c go-demo-2-test.yml go-demo-2-another-test

docker stack ps -f desired-state=running go-demo-2-another-test

docker stack ls

docker service ls

exit

curl -i "http://$CLUSTER_DNS/demo/hello"

curl -i "http://$CLUSTER_DNS/demo-test/hello"

curl -i "http://$CLUSTER_DNS/demo-something-else/hello"
```


## Building Functional Tests

---

```bash
open "https://github.com/vfarcic/go-demo-2/blob/master/functional_test.go"

open "https://github.com/vfarcic/docker-flow-stacks/blob/master/docker/compose/Dockerfile"

cd go-demo-2

cat Dockerfile.test

cat run-functional.sh

DOCKER_HUB_USER=[...]

docker image build -f Dockerfile.test \
    -t $DOCKER_HUB_USER/go-demo-2-test:v1 .

docker image push $DOCKER_HUB_USER/go-demo-2-test:v1
```


## Building Functional Tests

---

```bash
docker image build -f Dockerfile.test -t $DOCKER_HUB_USER/go-demo-2-test:v2 .

docker image push $DOCKER_HUB_USER/go-demo-2-test:v2
```


## Running Functional Tests

---

```bash
cat docker-compose.yml

CLUSTER_DNS=[...]

docker container run --rm -it -v $PWD:/compose \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e DOCKER_HUB_USER=$DOCKER_HUB_USER -e TAG=v1 \
    -e SERVICE_PATH="/demo-test" -e HOST_IP=$CLUSTER_DNS \
    vfarcic/compose docker-compose run --rm functional

docker container run --rm -it -v $PWD:/compose \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e DOCKER_HUB_USER=$DOCKER_HUB_USER -e TAG=v2 \
    -e SERVICE_PATH="/demo-something-else" -e HOST_IP=$CLUSTER_DNS \
    vfarcic/compose docker-compose run --rm functional
```


## Removing Testing Services

---

```bash
docker system prune -f

docker stack rm go-demo-2-test

docker stack rm go-demo-2-another-test

docker stack ls

exit
```


## Jenkins Pipeline

---

```bash
open "http://$CLUSTER_DNS/jenkins/job/go-demo-2/configure"

echo $CLUSTER_DNS
```


## Jenkins Pipeline

---

```groovy
pipeline {
...
  environment {
    SERVICE_PATH = "/demo-${env.BUILD_NUMBER}"
    HOST_IP = "[...]" // This is AWS DNS
    DOCKER_HUB_USER = "[...]" // This is Docker Hub user
  }
  stages {
    ...
    stage("functional") {
      steps {
        sh "TAG=beta-${env.BUILD_NUMBER} docker stack deploy -c stack-test.yml go-demo-2-beta-${env.BUILD_NUMBER}"
        sh "docker image build -f Dockerfile.test -t ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER} ."
        sh "docker image push ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER}"
        sleep 10
        sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm functional"
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
  // This is new
  environment {
    SERVICE_PATH = "/demo-${env.BUILD_NUMBER}"
    HOST_IP = "[...]" // This is AWS DNS
    DOCKER_HUB_USER = "[...]" // This is Docker Hub user
  }
  stages {
    stage("build") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
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
    // This is new
    stage("functional") {
      steps {
        sh "TAG=beta-${env.BUILD_NUMBER} docker stack deploy -c stack-test.yml go-demo-2-beta-${env.BUILD_NUMBER}"
        sh "docker image build -f Dockerfile.test -t ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER} ."
        sh "docker image push ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER}"
        sleep 10
        sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm functional"
      }
    }
  }
  // This is new
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

* Change *[...]*
* Click the *Save* button

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"
```

* Click the *Run* button
* Click the row with the new build

```bash
open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags/"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2-test/tags/"
```

## Hands-On Time

---

# Functional Testing


## Production Services

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

curl -o go-demo-2.yml \
  https://raw.githubusercontent.com/vfarcic/go-demo-2/master/stack.yml

cat go-demo-2.yml

TAG=[...] # Find the tag from Docker Hub

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


## Running Functional Tests Locally

---

```bash
git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

cat docker-compose.yml

open "https://github.com/vfarcic/go-demo-2/blob/master/functional_test.go"

SERVICE_PATH="/demo-test" HOST_IP=$CLUSTER_DNS \
  docker-compose run --rm functional-local
```


## Building Functional Tests

---

```bash
docker image build -f Dockerfile.test -t $DOCKER_HUB_USER/go-demo-2-test:v1 .

docker image push $DOCKER_HUB_USER/go-demo-2-test:v1

docker image build -f Dockerfile.test -t $DOCKER_HUB_USER/go-demo-2-test:v2 .

docker image push $DOCKER_HUB_USER/go-demo-2-test:v2

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2-test/tags/"
```


## Running Functional Tests

---

```bash
TAG=v1 SERVICE_PATH="/demo-test" HOST_IP=$CLUSTER_DNS \
  docker-compose run --rm functional

TAG=v2 SERVICE_PATH="/demo-something-else" HOST_IP=$CLUSTER_DNS \
  docker-compose run --rm functional

docker system prune -f
```


## Removing Testing Services

---

```bash
cd ..

ssh -i workshop.pem docker@$CLUSTER_IP

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
    HOST_IP = [...] // This is AWS DNS
    DOCKER_HUB_USER = [...] // This is Docker Hub user
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
        sh "docker push ${env.DOCKER_HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER}"
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

* Change `[...]`
* Click the `Save` button

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"
```

* Click the `Run` button
* Click the row with the new build

```bash
open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags/"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2-test/tags/"
```

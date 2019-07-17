## Hands-On Time

---

# Deploying To Production


## Creating a Release

---

```bash
source creds

docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:workshop-1.0

docker image push $DOCKER_HUB_USER/go-demo-2:workshop-1.0
```


## Testing Rolling Updates

---

```bash
docker image pull vfarcic/go-demo-2-test

docker service update -d  \
    --image $DOCKER_HUB_USER/go-demo-2:workshop-1.0 go-demo-2_main

docker container run --rm -it -v $PWD/go-demo-2:/compose \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e HOST_IP=$CLUSTER_DNS -e DURATION=1 \
    vfarcic/compose docker-compose run --rm production
```


## Rolling Back

---

```bash
docker stack ps -f desired-state=running go-demo-2

docker service update -d --rollback go-demo-2_main

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
            sh "docker service update -d --image $DOCKER_HUB_USER/go-demo-2:${env.BUILD_NUMBER} go-demo-2_main"
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
```

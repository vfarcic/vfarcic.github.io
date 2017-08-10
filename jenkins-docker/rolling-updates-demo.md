## Reqs

```bash
export DOCKER_HUB_USER=[...]

export CLUSTER_DNS=[...]

curl -o proxy.yml https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/proxy/docker-flow-proxy.yml

docker network create -d overlay proxy

docker stack deploy -c proxy.yml proxy

git clone https://github.com/vfarcic/go-demo-2.git

cd go-demo-2

docker stack deploy -c stack.yml go-demo-2

watch "docker stack ps -f desired-state=running go-demo-2"
```

## Rolling Updates

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:1.0

docker image push $DOCKER_HUB_USER/go-demo-2:1.0

docker service update --image $DOCKER_HUB_USER/go-demo-2:1.0 go-demo-2_main

watch "docker stack ps -f desired-state=running go-demo-2"
```

## Testing Rolling Updates

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:2.0

docker image push $DOCKER_HUB_USER/go-demo-2:2.0

docker service update --image $DOCKER_HUB_USER/go-demo-2:2.0 go-demo-2_main

for i in {1..2000}; do
    curl -i "http://localhost/demo/hello"
done

docker stack ps -f desired-state=running go-demo-2
```

## Testing Rolling Updates

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:3.0

docker image push $DOCKER_HUB_USER/go-demo-2:3.0

cat docker-compose.yml

open "https://github.com/vfarcic/go-demo-2/blob/master/functional_test.go"

docker service update --image $DOCKER_HUB_USER/go-demo-2:3.0 go-demo-2_main

HOST_IP=$CLUSTER_DNS docker-compose run --rm production

docker service ps -f desired-state=running go-demo-2_main | grep "$DOCKER_HUB_USER/go-demo-2:3.0" | wc -l
```

## Rolling Back

```bash
docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:4.0

docker image push $DOCKER_HUB_USER/go-demo-2:4.0

docker service update --image $DOCKER_HUB_USER/go-demo-2:4.0 go-demo-2_main

HOST_IP=http://this-address-does-not-exist.com docker-compose run --rm production

docker stack ps -f desired-state=running go-demo-2

docker service update --rollback go-demo-2_main

watch "docker stack ps -f desired-state=running go-demo-2"
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
    stage("functional") {
      steps {
        sh "TAG=beta-${env.BUILD_NUMBER} docker stack deploy -c stack-test.yml go-demo-2-beta-${env.BUILD_NUMBER}"
        sh "docker image build -f Dockerfile.test -t ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER} ."
        sh "docker image push ${env.DOCKER_HUB_USER}/go-demo-2-test:${env.BUILD_NUMBER}"
        sh "TAG=${env.BUILD_NUMBER} docker-compose -p go-demo-2-${env.BUILD_NUMBER} run --rm functional"
      }
    }
    // This is new
    stage("release") {
      steps {
        sh "docker image tag go-demo-2 ${env.DOCKER_HUB_USER}/go-demo-2:4.0:${env.BUILD_NUMBER}"
        sh "docker image push $DOCKER_HUB_USER/go-demo-2:${env.BUILD_NUMBER}"
      }
    }
    // This is new
    stage("deploy") {
      agent {
        label "prod"
      }
      steps {
        try {
          sh "docker service update --image $DOCKER_HUB_USER:5000/go-demo-2:${env.BUILD_NUMBER} go-demo_main"
        } catch (e) {
          sh "docker service update --rollback go-demo-2_main"
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

```bash
# NOTE: Replace [...]
```
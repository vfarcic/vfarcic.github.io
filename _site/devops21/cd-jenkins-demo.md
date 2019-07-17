## Hands-On Time

---

# Continuous Deployment

# With Jenkins


## Jenkins Credentials

---

```bash
open "http://$CLUSTER_DNS/jenkins/credentials/store/system/domain/_/"
```

* Login with *admin*/*admin*
* Click the *Add Credentials* link
* Type your Docker Hub username and password
* Type *docker* as the *ID*
* Click the *OK* button


## Jenkins Pipeline

---

```bash
open "http://$CLUSTER_DNS/jenkins/view/all/newJob"
```

* Type *go-demo-2* as the item name
* Select *Pipeline* as the item type
* Click the *OK* button
* Type the Pipeline script from the next slide


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


## Jenkins Shared Libraries

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Navigate to *Global Pipeline Libraries*


## Shared Libraries Repository

```bash
open "https://github.com/vfarcic/jenkins-shared-libraries/tree/master/vars"
```

* Open dockerBuild.groovy
* Open dockerFunctional.groovy
* Open dockerRelease.groovy
* Open dockerDeploy.groovy
* Open dockerCleanup.groovy


## Jenkinsfile

---

```bash
open "https://github.com/vfarcic/go-demo-2/blob/master/Jenkinsfile"

ssh -i workshop.pem docker@$CLUSTER_IP

source creds

echo "hostIp=$CLUSTER_DNS
dockerHubUser=$DOCKER_HUB_USER
" | docker secret create cluster-info.properties -

docker service update --secret-add cluster-info.properties \
    jenkins-agent-test_main

exit
```


## Cleanup

---

```bash
exit

open "http://$CLUSTER_DNS/jenkins/job/go-demo-2"
```

* Click the *Delete Pipeline* button


## Building All Branches

---

```bash
open "http://$CLUSTER_DNS/jenkins/blue/pipelines"
```

* Click the *New Pipeline* button
* Select *GitHub*
* Enter the access token
* Select *vfarcic* as repository organization
* Choose *New Pipeline*
* Type *go-demo-2* as repository
* Click the *Create Pipeline* button


## Going Back

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP
```
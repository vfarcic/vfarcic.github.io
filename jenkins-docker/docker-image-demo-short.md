## Hands-On Time

---

# Docker Images


## Building Images

---

```bash
cat Dockerfile

sudo rm go-demo

docker image build -t go-demo-2 .

docker image ls
```


## Pushing Images

---

```bash
export DOCKER_HUB_USER=[...]

docker image tag go-demo-2 $DOCKER_HUB_USER/go-demo-2:beta

docker image push $DOCKER_HUB_USER/go-demo-2:beta

exit

export DOCKER_HUB_USER=[...]

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"
```


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
    HUB_USER = "[...]"
  }
  stages {
    stage("build") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
        sh "docker image build -t ${env.HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER} ."
        withCredentials([usernamePassword(
          credentialsId: "docker",
          usernameVariable: "USER",
          passwordVariable: "PASS"
        )]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker image push ${env.HUB_USER}/go-demo-2:beta-${env.BUILD_NUMBER}"
      }
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
open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"
```

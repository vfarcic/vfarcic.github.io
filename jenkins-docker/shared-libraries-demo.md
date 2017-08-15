## Hands-On Time

---

# Reusing Code


## Shared Libraries Repository

```bash
open "https://github.com/vfarcic/jenkins-shared-libraries/tree/workshop"
```

* Click `vars`
* Click `hello.groovy`


## Jenkins Shared Libraries

---

```bash
open "http://localhost/jenkins/configure"
```

* Click `Global Pipeline Libraries` > `Add`
* Set `my-shared-library` as `Name`
* Set `workshop` as `Default version`
* Check `Load implicitly`
* Check `Modern SCM`
* Check `GitHub`
* Set `vfarcic` as `Owner`
* Set `jenkins-shared-libraries` as `Repository`
* Click the `Save` button


# Jenkins Pipeline

```bash
open "http://localhost/jenkins/newJob"
```

* Set `hello` as `Name`
* Select `Pipeline` as type
* Click `OK`

```groovy
node() {
    hello "Viktor"
}
```

* Click `Save`


# Jenkins Pipeline

```bash
open "http://localhost/jenkins/blue/organizations/jenkins/hello/activity"
```

* Click `Run`
* Click the latest build
* Click `Print Message`


## Shared Libraries Repository

```bash
open "https://github.com/vfarcic/jenkins-shared-libraries/blob/workshop/vars/dockerBuild.groovy"

open "https://github.com/vfarcic/jenkins-shared-libraries/blob/workshop/vars/dockerFunctional.groovy"

open "https://github.com/vfarcic/jenkins-shared-libraries/blob/workshop/vars/dockerRelease.groovy"

open "https://github.com/vfarcic/jenkins-shared-libraries/blob/workshop/vars/dockerDeploy.groovy"

open "https://github.com/vfarcic/jenkins-shared-libraries/blob/workshop/vars/dockerCleanup.groovy"
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
    HOST_IP = [...] // This is AWS DNS
    DOCKER_HUB_USER = [...] // This is Docker Hub user
  }
  stages {
    stage("checkout") {
      steps {
        git "https://github.com/vfarcic/go-demo-2.git"
      }
    }
    stage("build") {
      steps {
        dockerBuild("go-demo-2", env.DOCKER_HUB_USER)
      }
    }
    stage("functional") {
      steps {
        dockerFunctional("go-demo-2", env.DOCKER_HUB_USER, env.HOST_IP, "/demo")
      }
    }
    stage("release") {
      steps {
        dockerRelease("go-demo-2", env.DOCKER_HUB_USER)
      }
    }
    stage("deploy") {
      agent {
        label "prod"
      }
      steps {
        dockerDeploy("go-demo-2", env.DOCKER_HUB_USER, env.HOST_IP, "/demo")
      }
    }
  }
  post {
    always {
      dockerCleanup("go-demo-2")
    }
  }
}
```


## Jenkins Pipeline

---

* Replace [...]
* Click the *Save* button

```bash
echo $CLUSTER_DNS

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo-2/activity"

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo-2/tags"

ssh -i workshop.pem docker@$CLUSTER_IP

docker stack ps -f desired-state=running go-demo-2

exit
```
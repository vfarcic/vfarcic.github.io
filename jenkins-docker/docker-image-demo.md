## Hands-On Time

---

# Docker Images


## Building Images

---

```bash
git clone https://github.com/vfarcic/go-demo.git

cat go-demo/Dockerfile

docker image build -t go-demo go-demo/.
```


## Building Images

---

```bash
docker container run -it --rm \
  -v $PWD/go-demo:/tmp -w /tmp golang:1.7 \
  sh -c "go get -d -v -t && go build -v -o go-demo"

ls -l go-demo/

docker image build -t go-demo go-demo/.

docker image ls
```


## Building Images

---

```bash
cat go-demo/Dockerfile.big

docker image build -f go-demo/Dockerfile.big -t go-demo go-demo/.

docker image ls
```


## Building Images

---

```bash
cat go-demo/Dockerfile.multistage

docker image build -f go-demo/Dockerfile.multistage \
  -t go-demo go-demo/.

docker image ls
```


## Pushing Images

---

```bash
export DOCKER_HUB_USER=[...]

docker image tag go-demo $DOCKER_HUB_USER/go-demo

docker image push $DOCKER_HUB_USER/go-demo

docker image tag go-demo $DOCKER_HUB_USER/go-demo:workshop

docker image push $DOCKER_HUB_USER/go-demo:workshop

open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo/tags"
```


## Jenkins Credentials

---

```bash
open "http://$CLUSTER_DNS/jenkins/credentials"
```

* Login with `admin`/`admin`
* Click the `Jenkins` link
* Click the `Global credentials` link
* Click the `Add Credentials` link
* Type your Docker Hub username and password
* Type `docker` as the `ID`
* Click the `OK` button


## Jenkins Pipeline

---

```bash
open "http://$CLUSTER_DNS/jenkins/view/all/newJob"
```

* Type `go-demo` as the item name
* Select `Pipeline` as the item type
* Click the `OK` button
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
    buildDiscarder(logRotator(numToKeepStr: '2'))
    disableConcurrentBuilds()
  }
  stages {
    stage("build") {
      steps {
        script {
          def dateFormat = new SimpleDateFormat("yy.MM.dd")
          currentBuild.displayName = dateFormat.format(new Date()) + "-" + env.BUILD_NUMBER
        }
        git "https://github.com/vfarcic/go-demo.git"
        sh "docker image build -f Dockerfile.multistage -t vfarcic/go-demo ."
      }
    }
    stage("release") {
      steps {
        withCredentials([usernamePassword(
          credentialsId: "docker",
          usernameVariable: "USER",
          passwordVariable: "PASS"
        )]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker push vfarcic/go-demo"
        sh "docker image tag vfarcic/go-demo vfarcic/go-demo:${currentBuild.displayName}"
        sh "docker push vfarcic/go-demo:${currentBuild.displayName}"
      }
    }
  }
}
```


## Jenkins Pipeline

---

* Click the `Save` button

```bash
open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/go-demo/activity"
```

* Click the `Run` button
* Click the row with the new build

```bash
open "https://hub.docker.com/r/$DOCKER_HUB_USER/go-demo/tags"
```

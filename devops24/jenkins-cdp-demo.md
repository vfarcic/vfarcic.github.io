## Hands-On Time

---

# CD With Jenkins


## Setup

---

```bash
helm init --service-account build --tiller-namespace go-demo-3-build

kubectl -n kube-system rollout status deployment tiller-deploy

kubectl create -f ../go-demo-3/k8s/build-ns.yml \
    --save-config --record

kubectl create -f ../go-demo-3/k8s/prod-ns.yml \
    --save-config --record

export LB_ADDR=$(kubectl -n kube-ingress get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

dig +short $LB_ADDR

# If empty, LB is still not fully set up. Wait and repeat.
```


## Setup

---

```bash
LB_IP=$(dig +short $LB_ADDR | tail -n 1)

JENKINS_ADDR="jenkins.$LB_IP.xip.io"

helm install helm/jenkins --name jenkins --namespace jenkins \
    --set jenkins.Master.HostName=$JENKINS_ADDR \
    --set jenkins.Master.AMI=$AMI_ID

kubectl -n jenkins rollout status deployment jenkins

open "http://$JENKINS_ADDR"

alias get-jsecret='kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo'
```


## Setup

---

```bash
get-jsecret
```

* Login with user `admin`

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/newCredentials"
```

* Choose *AWS Credentials* as the *Kind*
* Type *aws* as the *ID*
* Type *aws* as the *Description*


## Setup

---

```bash
echo $AWS_ACCESS_KEY_ID
```

* Copy the output and paste it into the *Access Key ID* field

```bash
echo $AWS_SECRET_ACCESS_KEY
```

* Copy the output and paste it into the *Secret Access Key* field
* Click the *OK* button


## Setup

---

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/newCredentials"
```

* Type DH user to the *Username* field
* Type DH password to the *Password* field
* Type *docker* to the *ID* field
* Type *docker* to the *Description* field
* Click the *OK* button


## Setup

---

```bash
open "http://$JENKINS_ADDR/configure"

cat cluster/devops23.pem
```

* Copy the output and paste it into the *EC2 Key Pair's Private Key* field
* Click the *Test Connection* button
* Click the *Save* button


## Build Stage

---

* Write the script that follows in the *Pipeline Script* field

```groovy
import java.text.SimpleDateFormat

env.GH_USER = "vfarcic" // Replace me
env.DH_USER = "vfarcic" // Replace me
env.PROJECT = "go-demo-3"

podTemplate(
  label: "kubernetes",
  containers: [
    containerTemplate(name: "helm", image: "vfarcic/helm:2.8.2", ttyEnabled: true, command: "cat"),
    containerTemplate(name: "golang", image: "golang:1.10", ttyEnabled: true, command: "cat")
  ],
  namespace: "go-demo-3-build"
) {
  currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
  node("docker") {
    stage("build") {
      git "https://github.com/${env.GH_USER}/${env.PROJECT}.git"
      sh """docker image build \
        -t ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta ."""
      withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS"
      )]) {
        sh "docker login -u $USER -p $PASS"
      }
      sh """docker image push \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
      sh "docker logout"
    }  
  }
}
```


## Build Stage

---

```bash
GH_USER=[...]

open "https://hub.docker.com/r/$GH_USER/go-demo-3/tags/"
```


## Functional Stage

---

* Modify the job with the script that follows

```groovy
import java.text.SimpleDateFormat

env.GH_USER = "vfarcic" // Replace me
env.DH_USER = "vfarcic" // Replace me
env.PROJECT = "go-demo-3"

podTemplate(
  label: "kubernetes",
  containers: [
    containerTemplate(name: "helm", image: "vfarcic/helm:2.8.2", ttyEnabled: true, command: "cat"),
    containerTemplate(name: "golang", image: "golang:1.10", ttyEnabled: true, command: "cat")
  ],
  namespace: "${env.PROJECT}-build",
  serviceAccount: "build"
) {
  currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
  node("docker") {
    stage("build") {
      git "https://github.com/${env.GH_USER}/${env.PROJECT}.git"
      sh """docker image build  \
        -t ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta ."""
      withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS"
      )]) {
        sh "docker login -u $USER -p $PASS"
      }
      sh """docker image push \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
      sh "docker logout"
    }  
  }
  node("kubernetes") {
    stage("func-test") {
      try {
        container("helm") {
          sh "git clone https://github.com/${env.GH_USER}/${env.PROJECT}.git ."
          sh """helm upgrade \
            ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            helm/${env.PROJECT} -i \
            --tiller-namespace ${env.PROJECT}-build \
            --set image.tag=${currentBuild.displayName}-beta \
            --set ingress.path=/${env.PROJECT}-${env.BUILD_NUMBER}-beta/demo"""
          sh """kubectl rollout status \
            deployment ${env.PROJECT}-${env.BUILD_NUMBER}-beta"""
          env.HOST = sh script: """kubectl get \
            ing ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'""",
            returnStdout: true
        }
        container("golang") {
          sh "go get -d -v -t"
          withEnv(["ADDRESS=${env.HOST}/${env.PROJECT}-${env.BUILD_NUMBER}-beta"]) {
            sh """go test ./... -v \
              --run FunctionalTest"""
          }
        }
      } catch(e) {
          error "Failed functional tests"
      } finally {
        container("helm") {
          sh """helm delete \
            ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            --tiller-namespace ${env.PROJECT}-build \
            --purge"""
        }
      }
    }
  }
}
```


## Functional Stage

---

```bash
# While in `func-test` stage

kubectl -n go-demo-3-build get all
```


## Release Stage

---

* Modify the job with the script that follows

```groovy
import java.text.SimpleDateFormat

env.GH_USER = "vfarcic" // Replace me
env.DH_USER = "vfarcic" // Replace me
env.PROJECT = "go-demo-3"

podTemplate(
  label: "kubernetes",
  containers: [
    containerTemplate(name: "helm", image: "vfarcic/helm:2.8.2", ttyEnabled: true, command: "cat"),
    containerTemplate(name: "golang", image: "golang:1.10", ttyEnabled: true, command: "cat")
  ],
  namespace: "${env.PROJECT}-build",
  serviceAccount: "build"
) {
  currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
  node("docker") {
    stage("build") {
      git "https://github.com/${env.GH_USER}/${env.PROJECT}.git"
      sh """docker image build  \
        -t ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta ."""
      withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS"
      )]) {
        sh "docker login -u $USER -p $PASS"
      }
      sh """docker image push \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
      sh "docker logout"
    }  
  }
  node("kubernetes") {
    stage("func-test") {
      try {
        container("helm") {
          sh "git clone https://github.com/${env.GH_USER}/${env.PROJECT}.git ."
          sh """helm upgrade \
            ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            helm/${env.PROJECT} -i \
            --tiller-namespace ${env.PROJECT}-build \
            --set image.tag=${currentBuild.displayName}-beta \
            --set ingress.path=/${env.PROJECT}-${env.BUILD_NUMBER}-beta/demo"""
          sh """kubectl rollout status \
            deployment ${env.PROJECT}-${env.BUILD_NUMBER}-beta"""
          env.HOST = sh script: """kubectl get \
            ing ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'""",
            returnStdout: true
        }
        container("golang") {
          sh "go get -d -v -t"
          withEnv(["ADDRESS=${env.HOST}/${env.PROJECT}-${env.BUILD_NUMBER}-beta"]) {
            sh """go test ./... -v \
              --run FunctionalTest"""
          }
        }
      } catch(e) {
          error "Failed functional tests"
      } finally {
        container("helm") {
          sh """helm delete \
            ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            --tiller-namespace ${env.PROJECT}-build \
            --purge"""
        }
      }
    }
  }
  node("docker") {
    stage("release") {
      sh """docker pull \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
      sh """docker image tag \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}"""
      sh """docker image tag \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta \
        ${env.DH_USER}/${env.PROJECT}:latest"""
      withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS"
      )]) {
        sh "docker login -u $USER -p $PASS"
      }
      sh """docker image push \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}"""
      sh """docker image push \
        ${env.DH_USER}/${env.PROJECT}:latest"""
      sh "docker logout"
    }  
  }
}
```


## Release Stage

---

```bash
# TODO: Release files to GH

# TODO: Manifest

open "https://hub.docker.com/r/$GH_USER/go-demo-3/tags/"
```


## Deploy Stage

---

```groovy
import java.text.SimpleDateFormat

env.GH_USER = "vfarcic" // Replace me
env.DH_USER = "vfarcic" // Replace me
env.PROJECT = "go-demo-3"

podTemplate(
  label: "kubernetes",
  containers: [
    containerTemplate(name: "helm", image: "vfarcic/helm:2.8.2", ttyEnabled: true, command: "cat"),
    containerTemplate(name: "golang", image: "golang:1.10", ttyEnabled: true, command: "cat")
  ],
  namespace: "${env.PROJECT}-build",
  serviceAccount: "build"
) {
  currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
  node("docker") {
    stage("build") {
      git "https://github.com/${env.GH_USER}/${env.PROJECT}.git"
      sh """docker image build  \
        -t ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta ."""
      withCredentials([usernamePassword(
        credentialsId: "docker",
        usernameVariable: "USER",
        passwordVariable: "PASS"
      )]) {
        sh "docker login -u $USER -p $PASS"
      }
      sh """docker image push \
        ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
      sh "docker logout"
    }  
  }
  node("kubernetes") {
    stage("func-test") {
      try {
        container("helm") {
          sh "git clone https://github.com/${env.GH_USER}/${env.PROJECT}.git ."
          sh """helm upgrade \
            ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            helm/${env.PROJECT} -i \
            --tiller-namespace ${env.PROJECT}-build \
            --set image.tag=${currentBuild.displayName}-beta \
            --set ingress.path=/${env.PROJECT}-${env.BUILD_NUMBER}-beta/demo"""
          sh """kubectl rollout status \
            deployment ${env.PROJECT}-${env.BUILD_NUMBER}-beta"""
          env.HOST = sh script: """kubectl get \
            ing ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'""",
            returnStdout: true
        }
        container("golang") {
          sh "go get -d -v -t"
          withEnv(["ADDRESS=${env.HOST}/${env.PROJECT}-${env.BUILD_NUMBER}-beta"]) {
            sh """go test ./... -v \
              --run FunctionalTest"""
          }
        }
      } catch(e) {
        error "Failed functional tests"
      } finally {
        container("helm") {
          sh """helm delete \
            ${env.PROJECT}-${env.BUILD_NUMBER}-beta \
            --tiller-namespace ${env.PROJECT}-build \
            --purge"""
        }
      }
    }
    node("docker") {
      stage("release") {
        sh """docker pull \
          ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
        sh """docker image tag \
          ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta \
          ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}"""
        sh """docker image tag \
          ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta \
          ${env.DH_USER}/${env.PROJECT}:latest"""
        withCredentials([usernamePassword(
          credentialsId: "docker",
          usernameVariable: "USER",
          passwordVariable: "PASS"
        )]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh """docker image push \
          ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}"""
        sh """docker image push \
          ${env.DH_USER}/${env.PROJECT}:latest"""
        sh "docker logout"
      }  
    }
    stage("deploy") {
      try {
        container("helm") {
          sh """helm upgrade \
            ${env.PROJECT} \
            helm/${env.PROJECT} -i \
            --namespace ${env.PROJECT} \
            --tiller-namespace ${env.PROJECT}-build \
            --set image.tag=${currentBuild.displayName}"""
          sh """kubectl rollout status \
            -n ${env.PROJECT} \
            deployment ${env.PROJECT}"""
          env.HOST = sh script: """kubectl get \
            -n ${env.PROJECT} \
            ing ${env.PROJECT} \
            -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'""",
            returnStdout: true
        }
        container("golang") {
          sh "go get -d -v -t"
          withEnv(["ADDRESS=${env.HOST}", "DURATION=1"]) {
            sh """go test ./... -v \
              --run ProductionTest"""
          }
        }
      } catch(e) {
        container("helm") {
          sh """helm rollback \
            ${env.PROJECT} 0 \
            --tiller-namespace ${env.PROJECT}-build"""
          error "Failed production tests"
        }
      }
    }
  }
}
```


## Deploy Stage

---

```bash
open "https://hub.docker.com/r/$GH_USER/go-demo-3/tags/"
```


## What Now?

---

```bash
TODO
```

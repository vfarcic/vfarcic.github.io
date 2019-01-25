## Hands-On Time

---

# Creating A CDP Pipeline With Jenkins


<!-- .slide: data-background="img/cdp-stages.png" data-background-size="contain" -->


## Defining The Build Stage

---


<!-- .slide: data-background="img/cdp-stages-build.png" data-background-size="contain" -->


## Defining The Build Stage

---

```bash
open "http://$JENKINS_ADDR"
```

* Create a Pipeline job called *go-demo-3*


## Defining The Build Stage

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Change me!
env.IMAGE = "vfarcic/go-demo-3" // Change me!
env.TAG_BETA = "${currentBuild.displayName}-${env.BRANCH_NAME}"

node("docker") {
  stage("build") {
    git "${env.REPO}"
    sh "sudo docker image build -t ${env.IMAGE}:${env.TAG_BETA} ."
    withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
      sh "sudo docker login -u $USER -p $PASS"
    }
    sh "sudo docker image push ${env.IMAGE}:${env.TAG_BETA}"
  }
}
```


## Defining The Build Stage

---

```bash
export DH_USER=[...]

open "https://hub.docker.com/r/$DH_USER/go-demo-3/tags/"
```


## The Functional Testing Stage

---


<!-- .slide: data-background="img/cdp-stages-func.png" data-background-size="contain" -->


## The Functional Testing Stage

---

```bash
export ADDR=$LB_IP.nip.io

echo $ADDR

open "http://$JENKINS_ADDR/job/go-demo-3/configure"
```


## The Functional Testing Stage

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Change me!
env.IMAGE = "vfarcic/go-demo-3" // Change me!
env.ADDRESS = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}.acme.com" // Change me!
env.TAG_BETA = "${currentBuild.displayName}-${env.BRANCH_NAME}"
env.CHART_NAME = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}"
def label = "jenkins-slave-${UUID.randomUUID().toString()}"

podTemplate(
  label: label,
  namespace: "go-demo-3-build",
  serviceAccount: "build",
  yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: helm
    image: vfarcic/helm:2.9.1
    command: ["cat"]
    tty: true
  - name: kubectl
    image: vfarcic/kubectl
    command: ["cat"]
    tty: true
  - name: golang
    image: golang:1.9
    command: ["cat"]
    tty: true
"""
) {
  node(label) {
    node("docker") {
      stage("build") {
        git "${env.REPO}"
        sh "sudo docker image build -t ${env.IMAGE}:${env.TAG_BETA} ."
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "sudo docker login -u $USER -p $PASS"
        }
        sh "sudo docker image push ${env.IMAGE}:${env.TAG_BETA}"
      }
    }
    stage("func-test") {
      try {
        container("helm") {
          git "${env.REPO}"
          sh "helm upgrade ${env.CHART_NAME} helm/go-demo-3 -i --tiller-namespace go-demo-3-build --set image.tag=${env.TAG_BETA} --set ingress.host=${env.ADDRESS} --set replicaCount=2 --set dbReplicaCount=1"
        }
        container("kubectl") {
          sh "kubectl -n go-demo-3-build rollout status deployment ${env.CHART_NAME}"
        }
        container("golang") { // Uses env ADDRESS
          sh "go get -d -v -t"
          sh "go test ./... -v --run FunctionalTest"
        }
      } catch(e) {
          error "Failed functional tests"
      } finally {
        container("helm") {
          sh "helm delete ${env.CHART_NAME} --tiller-namespace go-demo-3-build --purge"
        }
      }
    }
  }
}
```


## The Functional Testing Stage

---

```bash
helm ls --tiller-namespace go-demo-3-build

kubectl -n go-demo-3-build get pods

# Wait until the build is finished

helm ls --tiller-namespace go-demo-3-build

kubectl -n go-demo-3-build get pods
```


## Defining The Release Stage

---


<!-- .slide: data-background="img/cdp-stages-release.png" data-background-size="contain" -->


## Defining The Release Stage

---

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/newCredentials"
```

* Type *admin* as both the *Username* and the *Password*
* Set the *ID* and the *Description* to *chartmuseum*
* Click the *OK* button to persist the credentials.

```bash
JENKINS_POD=$(kubectl -n jenkins get pods \
    -l component=jenkins-jenkins-master \
    -o jsonpath='{.items[0].metadata.name}')

echo $JENKINS_POD

kubectl -n jenkins cp \
    $JENKINS_POD:var/jenkins_home/credentials.xml cluster/jenkins

echo $ADDR

open "http://$JENKINS_ADDR/job/go-demo-3/configure"
```


## Defining The Release Stage

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Change me!
env.IMAGE = "vfarcic/go-demo-3" // Change me!
env.ADDRESS = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}.acme.com" // Change me!
env.CM_ADDR = "cm.acme.com" // Change me!
env.TAG = "${currentBuild.displayName}"
env.TAG_BETA = "${env.TAG}-${env.BRANCH_NAME}"
env.CHART_VER = "0.0.1"
env.CHART_NAME = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}"
def label = "jenkins-slave-${UUID.randomUUID().toString()}"

podTemplate(
  label: label,
  namespace: "go-demo-3-build",
  serviceAccount: "build",
  yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: helm
    image: vfarcic/helm:2.9.1
    command: ["cat"]
    tty: true
  - name: kubectl
    image: vfarcic/kubectl
    command: ["cat"]
    tty: true
  - name: golang
    image: golang:1.9
    command: ["cat"]
    tty: true
"""
) {
  node(label) {
    node("docker") {
      stage("build") {
        git "${env.REPO}"
        sh "sudo docker image build -t ${env.IMAGE}:${env.TAG_BETA} ."
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "sudo docker login -u $USER -p $PASS"
        }
        sh "sudo docker image push ${env.IMAGE}:${env.TAG_BETA}"
      }
    }
    stage("func-test") {
      try {
        container("helm") {
          git "${env.REPO}"
          sh "helm upgrade ${env.CHART_NAME} helm/go-demo-3 -i --tiller-namespace go-demo-3-build --set image.tag=${env.TAG_BETA} --set ingress.host=${env.ADDRESS} --set replicaCount=2 --set dbReplicaCount=1"
        }
        container("kubectl") {
          sh "kubectl -n go-demo-3-build rollout status deployment ${env.CHART_NAME}"
        }
        container("golang") {
          sh "go get -d -v -t"
          sh "go test ./... -v --run FunctionalTest"
        }
      } catch(e) {
          error "Failed functional tests"
      } finally {
        container("helm") {
          sh "helm delete ${env.CHART_NAME} --tiller-namespace go-demo-3-build --purge"
        }
      }
    }
    stage("release") {
      node("docker") {
        sh "sudo docker pull ${env.IMAGE}:${env.TAG_BETA}"
        sh "sudo docker image tag ${env.IMAGE}:${env.TAG_BETA} ${env.IMAGE}:${env.TAG}"
        sh "sudo docker image tag ${env.IMAGE}:${env.TAG_BETA} ${env.IMAGE}:latest"
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "sudo docker login -u $USER -p $PASS"
        }
        sh "sudo docker image push ${env.IMAGE}:${env.TAG}"
        sh "sudo docker image push ${env.IMAGE}:latest"
      }
      container("helm") {
        sh "helm package helm/go-demo-3"
        withCredentials([usernamePassword(credentialsId: "chartmuseum", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh """curl -u $USER:$PASS --data-binary "@go-demo-3-${CHART_VER}.tgz" http://${env.CM_ADDR}/api/charts"""
        }
      }
    }
  }
}
```


## Defining The Release Stage

---

```bash
# Wait until the build is finished

open "https://hub.docker.com/r/$DH_USER/go-demo-3/tags/"

curl -u admin:admin "http://$CM_ADDR/index.yaml"
```


## Defining The Deploy Stage

---


<!-- .slide: data-background="img/cdp-stages-deploy.png" data-background-size="contain" -->


## Defining The Deploy Stage

---

```bash
echo $ADDR

open "http://$JENKINS_ADDR/job/go-demo-3/configure"
```


## Defining The Deploy Stage

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Change me!
env.IMAGE = "vfarcic/go-demo-3" // Change me!
env.ADDRESS = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}.acme.com" // Change me!
env.PROD_ADDRESS = "go-demo-3.acme.com" // Change me!
env.CM_ADDR = "cm.acme.com" // Change me!
env.TAG = "${currentBuild.displayName}"
env.TAG_BETA = "${env.TAG}-${env.BRANCH_NAME}"
env.CHART_VER = "0.0.1"
env.CHART_NAME = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}"
def label = "jenkins-slave-${UUID.randomUUID().toString()}"

podTemplate(
  label: label,
  namespace: "go-demo-3-build",
  serviceAccount: "build",
  yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: helm
    image: vfarcic/helm:2.9.1
    command: ["cat"]
    tty: true
  - name: kubectl
    image: vfarcic/kubectl
    command: ["cat"]
    tty: true
  - name: golang
    image: golang:1.9
    command: ["cat"]
    tty: true
"""
) {
  node(label) {
    node("docker") {
      stage("build") {
        git "${env.REPO}"
        sh "sudo docker image build -t ${env.IMAGE}:${env.TAG_BETA} ."
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "sudo docker login -u $USER -p $PASS"
        }
        sh "sudo docker image push ${env.IMAGE}:${env.TAG_BETA}"
      }
    }
    stage("func-test") {
      try {
        container("helm") {
          git "${env.REPO}"
          sh "helm upgrade ${env.CHART_NAME} helm/go-demo-3 -i --tiller-namespace go-demo-3-build --set image.tag=${env.TAG_BETA} --set ingress.host=${env.ADDRESS} --set replicaCount=2 --set dbReplicaCount=1"
        }
        container("kubectl") {
          sh "kubectl -n go-demo-3-build rollout status deployment ${env.CHART_NAME}"
        }
        container("golang") {
          sh "go get -d -v -t"
          sh "go test ./... -v --run FunctionalTest"
        }
      } catch(e) {
          error "Failed functional tests"
      } finally {
        container("helm") {
          sh "helm delete ${env.CHART_NAME} --tiller-namespace go-demo-3-build --purge"
        }
      }
    }
    stage("release") {
      node("docker") {
        sh "sudo docker pull ${env.IMAGE}:${env.TAG_BETA}"
        sh "sudo docker image tag ${env.IMAGE}:${env.TAG_BETA} ${env.IMAGE}:${env.TAG}"
        sh "sudo docker image tag ${env.IMAGE}:${env.TAG_BETA} ${env.IMAGE}:latest"
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "sudo docker login -u $USER -p $PASS"
        }
        sh "sudo docker image push ${env.IMAGE}:${env.TAG}"
        sh "sudo docker image push ${env.IMAGE}:latest"
      }
      container("helm") {
        sh "helm package helm/go-demo-3"
        withCredentials([usernamePassword(credentialsId: "chartmuseum", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh """curl -u $USER:$PASS --data-binary "@go-demo-3-${CHART_VER}.tgz" http://${env.CM_ADDR}/api/charts"""
        }
      }
    }
    stage("deploy") {
      try {
        container("helm") {
          sh "helm upgrade go-demo-3 helm/go-demo-3 -i --tiller-namespace go-demo-3-build --namespace go-demo-3 --set image.tag=${env.TAG} --set ingress.host=${env.PROD_ADDRESS}"
        }
        container("kubectl") {
          sh "kubectl -n go-demo-3 rollout status deployment go-demo-3"
        }
        container("golang") {
          sh "go get -d -v -t"
          sh "DURATION=1 ADDRESS=${env.PROD_ADDRESS} go test ./... -v --run ProductionTest"
        }
      } catch(e) {
        container("helm") {
          sh "helm rollback go-demo-3 0 --tiller-namespace go-demo-3-build"
          error "Failed production tests"
        }
      }
    }
  }
}
```


## Defining The Deploy Stage

---

```bash
# Wait until the build is finished

helm ls --tiller-namespace go-demo-3-build

kubectl -n go-demo-3 get pods

curl "http://go-demo-3.$ADDR/demo/hello"
```


## Global Pipeline Libraries

---

```bash
open "http://$JENKINS_ADDR/configure"
```

* Click the *Add* button in *Global Pipeline Libraries*
* Type *my-library* as the *Name*
* Type *master* as the *Default version*
* Click the *Load implicitly* checkbox
* Select *Modern SCM* from the *Retrieval method* section
* Select *Git* from *Source Code Management*
* Go to [vfarcic/jenkins-shared-libraries.git](https://github.com/vfarcic/jenkins-shared-libraries.git) and fork it
* Copy the address from the *Clone and download* drop-down list, return to Jenkins UI, and paste it into the *Project Repository* field
* Click the *Save* button to persist the changes


## Global Pipeline Libraries

---

```bash
export GH_USER=[...]

open "https://github.com/$GH_USER/jenkins-shared-libraries.git"

kubectl -n jenkins cp \
    $JENKINS_POD:var/jenkins_home/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml \
    cluster/jenkins/secrets

echo $ADDR

open "http://$JENKINS_ADDR/job/go-demo-3/configure"
```


## Global Pipeline Libraries

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.PROJECT = "go-demo-3"
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Change me!
env.IMAGE = "vfarcic/go-demo-3" // Change me!
env.DOMAIN = "acme.com" // Change me!
env.ADDRESS = "go-demo-3.acme.com" // Change me!
env.CM_ADDR = "cm.acme.com" // Change me!
env.CHART_VER = "0.0.1"
def label = "jenkins-slave-${UUID.randomUUID().toString()}"

podTemplate(
  label: label,
  namespace: "go-demo-3-build",
  serviceAccount: "build",
  yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: helm
    image: vfarcic/helm:2.9.1
    command: ["cat"]
    tty: true
  - name: kubectl
    image: vfarcic/kubectl
    command: ["cat"]
    tty: true
  - name: golang
    image: golang:1.9
    command: ["cat"]
    tty: true
"""
) {
  node(label) {
    node("docker") {
      stage("build") {
        git "${env.REPO}"
        k8sBuildImageBeta(env.IMAGE)
      }
    }
    stage("func-test") {
      try {
        container("helm") {
          git "${env.REPO}"
          k8sUpgradeBeta(env.PROJECT, env.DOMAIN)
        }
        container("kubectl") {
          k8sRolloutBeta(env.PROJECT)
        }
        container("golang") {
          k8sFuncTestGolang(env.PROJECT, env.DOMAIN)
        }
      } catch(e) {
          error "Failed functional tests"
      } finally {
        container("helm") {
          k8sDeleteBeta(env.PROJECT)
        }
      }
    }
    stage("release") {
      node("docker") {
        k8sPushImage(env.IMAGE)
      }
      container("helm") {
        k8sPushHelm(env.PROJECT, env.CHART_VER, env.CM_ADDR)
      }
    }
    stage("deploy") {
      try {
        container("helm") {
          k8sUpgrade(env.PROJECT, env.ADDRESS)
        }
        container("kubectl") {
          k8sRollout(env.PROJECT)
        }
        container("golang") {
          k8sProdTestGolang(env.ADDRESS)
        }
      } catch(e) {
        container("helm") {
          k8sRollback(env.PROJECT)
        }
      }
    }
  }
}
```


## Global Pipeline Libraries

---

```bash
open "https://hub.docker.com/r/$DH_USER/go-demo-3/tags/"

helm ls --tiller-namespace go-demo-3-build

helm history go-demo-3 --tiller-namespace go-demo-3-build
```


## Global Pipeline Libraries Docs

---

```bash
open "https://github.com/$GH_USER/jenkins-shared-libraries/tree/master/vars"

curl "https://raw.githubusercontent.com/$GH_USER/jenkins-shared-libraries/master/vars/k8sBuildImageBeta.txt"

open "http://$JENKINS_ADDR/configureSecurity/"
```

* Change *Markup Formatter* to *PegDown*

```bash
open "http://$JENKINS_ADDR/job/go-demo-3/"
```

* Navigate to *Pipeline Syntax* > *Global Variables Reference*


## Using Jenkinsfile & Multistage Builds

---

```bash
cat ../go-demo-3/Jenkinsfile

cat ../go-demo-3/k8s/build-config.yml

cat ../go-demo-3/k8s/build-config.yml \
    | sed -e "s@acme.com@$ADDR@g" \
    | sed -e "s@vfarcic@$DH_USER@g" \
    | kubectl apply -f - --record

open "http://$JENKINS_ADDR/job/go-demo-3/"
```

* Click the *Delete Pipeline* link

```bash
open "http://$JENKINS_ADDR/blue/create-pipeline"
```


## Using Jenkinsfile & Multistage Builds

---

* Choose *GitHub*
* Click the *Create an access token here* link to create a token if you do NOT have it already
* Type *Token description* and click the *Generate token* button
* Click the *Connect* button
* Choose your GitHub organization
* Type *go-demo-3* to filter the repositories and select it
* Click the *Create Pipeline* button
* Stop all the builds except *master*


## What Now?

---

```bash
# If using Docker For Desktop or minikube
cd cd/docker-build

# If using Docker For Desktop or minikube
vagrant suspend

# If using Docker For Desktop or minikube
cd ../..
```
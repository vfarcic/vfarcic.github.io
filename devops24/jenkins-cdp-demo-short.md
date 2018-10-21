## Hands-On Time

---

# Creating A CDP Pipeline With Jenkins


<!-- .slide: data-background="img/cdp-stages.png" data-background-size="contain" -->


## Installing Jenkins

---

```bash
cat ../go-demo-3/k8s/ns.yml

kubectl apply -f ../go-demo-3/k8s/ns.yml --record

helm init --service-account build --tiller-namespace go-demo-3-build
```


## Installing Jenkins

---

```bash
JENKINS_ADDR="go-demo-3-jenkins.$LB_IP.nip.io"

helm dependency build helm/jenkins

cat helm/jenkins/requirements.yaml

cat helm/jenkins/values.yaml

cat helm/jenkins/templates/config.tpl
```


## Installing Jenkins

---

```bash
helm install helm/jenkins --name go-demo-3-jenkins \
    --namespace go-demo-3-jenkins \
    --set jenkins.Master.HostName=$JENKINS_ADDR \
    --set jenkins.Master.CredentialsXmlSecret="" \
    --set jenkins.Master.SecretsFilesSecret=""

kubectl -n go-demo-3-jenkins rollout status deployment \
    go-demo-3-jenkins
```


## Adding Docker Hub Credentials

---

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/newCredentials"

JENKINS_PASS=$(kubectl -n go-demo-3-jenkins get secret \
    go-demo-3-jenkins -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo)

echo $JENKINS_PASS
```

* Type your Docker Hub *Username* and *Password*
* Type *docker* as the *ID* and the *Description*
* Click the *OK* button


## Adding ChartMuseum Credentials

---

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/newCredentials"
```

* Type *admin* as the *Username* and the *Password*
* Type *chartmuseum* as the *ID* and the *Description*
* Click the *OK* button


## Defining CDP Pipeline

---

```bash
open "http://$JENKINS_ADDR/view/all/newJob"
```

* Type *go-demo-3* as the *item name*
* Select *Pipeline* as the *item type*
* Click the *OK* button
* Copy & paste the script that follows


## Defining CDP Pipeline

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Change Me!
env.IMAGE = "vfarcic/go-demo-3" // Change Me!
env.ADDRESS = "go-demo-3-${env.BUILD_NUMBER}-${env.BRANCH_NAME}.acme.nip.io" // Change Me!
env.PROD_ADDRESS = "go-demo-3.acme.nip.io" // Change Me!
env.CM_ADDR = "acme.nip.io" // Change Me!
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
  - name: docker
    image: docker:18.06
    command: ["cat"]
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-socket
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
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
      type: Socket
"""
) {
  node(label) {
    stage("build") {
      container("docker") {
        git "${env.REPO}"
        sh "docker image build -t ${env.IMAGE}:${env.TAG_BETA} ."
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker image push ${env.IMAGE}:${env.TAG_BETA}"
      }
    }
    stage("func-test") {
      try {
        container("helm") {
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
      container("docker") {
        sh "docker pull ${env.IMAGE}:${env.TAG_BETA}"
        sh "docker image tag ${env.IMAGE}:${env.TAG_BETA} ${env.IMAGE}:${env.TAG}"
        sh "docker image tag ${env.IMAGE}:${env.TAG_BETA} ${env.IMAGE}:latest"
        withCredentials([usernamePassword(credentialsId: "docker", usernameVariable: "USER", passwordVariable: "PASS")]) {
          sh "docker login -u $USER -p $PASS"
        }
        sh "docker image push ${env.IMAGE}:${env.TAG}"
        sh "docker image push ${env.IMAGE}:latest"
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


## Running CDP Pipeline

---

```bash
echo $LB_IP
```

* Replace the variables commented with `Change Me!`
* Click the *Apply* button

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/go-demo-3/"
```

* Click the *Run* button


<!-- .slide: data-background="img/cdp-stages-build.png" data-background-size="contain" -->


<!-- .slide: data-background="img/cdp-stages-func.png" data-background-size="contain" -->


<!-- .slide: data-background="img/cdp-stages-release.png" data-background-size="contain" -->


<!-- .slide: data-background="img/cdp-stages-deploy.png" data-background-size="contain" -->


## Running CDP Pipeline

---

```bash
kubectl -n go-demo-3-build get pods

helm ls --tiller-namespace go-demo-3-build

kubectl -n go-demo-3 get pods

curl "http://go-demo-3.$LB_IP.nip.io/demo/hello"
```


## Global Pipeline Libraries

---

```bash
open "https://github.com/vfarcic/jenkins-shared-libraries.git"

open "http://$JENKINS_ADDR/configure"
```


## Global Pipeline Libraries

---

* Fork the repo
* Scroll to *Global Pipeline Libraries*
* Click the *Add* button
* Type *my-library* as the *Name*
* Type *master* as the *Default version*
* Select *Load implicitly*
* Select *Modern SCM*
* Select *Git*
* Type *https://github.com/[YOUR_GITHUB_USER]/jenkins-shared-libraries.git* as the *Project Repository*
* Click the *Apply* button


## Global Pipeline Libraries

---

```bash
export GH_USER=[...]

open "https://github.com/$GH_USER/jenkins-shared-libraries.git"

open "http://$JENKINS_ADDR/job/go-demo-3/configure"
```

* Replace the script with the one that follows


## Global Pipeline Libraries

---

```groovy
import java.text.SimpleDateFormat

currentBuild.displayName = new SimpleDateFormat("yy.MM.dd").format(new Date()) + "-" + env.BUILD_NUMBER
env.PROJECT = "go-demo-3"
env.REPO = "https://github.com/vfarcic/go-demo-3.git" // Replace me!
env.IMAGE = "vfarcic/go-demo-3" // Replace me!
env.DOMAIN = "acme.nip.io" // Replace me!
env.ADDRESS = "go-demo-3.acme.nip.io" // Replace me!
env.CM_ADDR = "acme.nip.io" // Replace me!
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
  - name: docker
    image: docker:18.06
    command: ["cat"]
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-socket
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
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
      type: Socket
"""
) {
  node(label) {
    stage("build") {
      container("docker") {
        git "${env.REPO}"
        k8sBuildImageBeta(env.IMAGE, false)
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
      container("docker") {
        k8sPushImage(env.IMAGE, false)
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
echo $LB_IP
```

* Replace the variables commented with `Change Me!`
* Click the *Apply* button

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/go-demo-3/"
```

* Click the *Run* button
* Wait until the build is finished


## Global Pipeline Libraries

---

```bash
export DH_USER=[...]

open "https://hub.docker.com/r/$DH_USER/go-demo-3/tags/"

helm ls --tiller-namespace go-demo-3-build

helm history go-demo-3 --tiller-namespace go-demo-3-build
```


## Global Pipeline Libraries Docs

---

```bash
curl "https://raw.githubusercontent.com/$GH_USER/jenkins-shared-libraries/master/vars/k8sBuildImageBeta.txt"

open "http://$JENKINS_ADDR/configureSecurity/"
```

* Change *Markup Formatter* to *PegDown*
* Click the *Apply* button

```bash
open "http://$JENKINS_ADDR/job/go-demo-3/pipeline-syntax/globals"
```


## What Now?

---

```bash
helm --tiller-namespace go-demo-3-build delete go-demo-3 --purge
```
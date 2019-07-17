<!-- .slide: data-background="../img/background/setup.jpeg" -->
# Installing CJE

---


# The Release

---

```bash
open "https://downloads.cloudbees.com/cje2/latest/"
```

* Available Online
* Check the date of the latest!
* All versions available
* Two flavors (k8s, OpenShift)
* sha256 digest


# The Release

---

```bash
RELEASE_URL=[...]

curl -o cje.tgz $RELEASE_URL

tar -xvf cje.tgz

cd cje2_*

ls -l
```


# YAML

---

```bash
cat cje.yml
```


# Storage Class

---

```bash
kubectl get sc -o yaml
```


# Installation

---

```bash
kubectl create ns jenkins

cat cje.yml \
    | sed -e "s@https://cje.example.com@http://cje.example.com@g" \
    | sed -e "s@cje.example.com@$CLUSTER_DNS@g" \
    | sed -e "s@ssl-redirect: \"true\"@ssl-redirect: \"false\"@g" \
    | kubectl -n jenkins create -f - --save-config --record

kubectl -n jenkins rollout status sts cjoc

kubectl -n jenkins get all
```


# Setup

---

```bash
open "http://$CLUSTER_DNS/cjoc"

kubectl --namespace jenkins exec cjoc-0 -- \
    cat /var/jenkins_home/secrets/initialAdminPassword
```

* Complete the wizard steps


# Storage

---

```bash
kubectl -n jenkins get pvc

kubectl get pv
```


# Creating A Master

---

* Create a master called *my-master*
* *Jenkins Master Memory in MB* to *1024*
* Set *Jenkins Master CPUs* to *0.5*

```bash
kubectl -n jenkins get all

kubectl -n jenkins describe pod my-master-0

kubectl -n jenkins logs my-master-0
```

* Go to *my-master*
* Complete the wizard steps


# Creating A Job

---

* Create a new Pipeline job called *my-job*


# Creating A Job

---

```groovy
podTemplate(
    label: 'kubernetes',
    containers: [
        containerTemplate(name: 'maven', image: 'maven:alpine', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'golang', image: 'golang:alpine', ttyEnabled: true, command: 'cat')
    ]
) {
    node('kubernetes') {
        container('maven') {
            stage('build') {
                sh "sleep 5"
                sh 'mvn --version'
            }
            stage('unit-test') {
                sh "sleep 5"
                sh 'java -version'
            }
        }
        container('golang') {
            stage('deploy') {
                sh "sleep 5"
                sh 'go version'
            }
        }
    }
}
```


# Running The Job

---

* Run the job *my-job*

```bash
kubectl -n jenkins get pods
```


# A Real Pipeline (namespaces)

---

```bash
kubectl apply -f https://raw.githubusercontent.com/vfarcic/go-demo-3/master/k8s/build-ns.yml

# kubectl apply -n go-demo-3-build \
#     -f https://raw.githubusercontent.com/vfarcic/go-demo-3/master/k8s/jenkins.yml

kubectl apply -f https://raw.githubusercontent.com/vfarcic/go-demo-3/master/k8s/jenkins.yml

curl https://raw.githubusercontent.com/vfarcic/go-demo-3/master/k8s/jenkins.yml \
    | sed -e "s@go-demo-3-build@kube-system@g" \
    | kubectl apply -f -

kubectl create \
    -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml \
    --record --save-config

helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy

LB_HOST=$(kubectl -n kube-ingress get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

export LB_IP="$(dig +short $LB_HOST | tail -n 1)"

echo $LB_IP
```


# A Real Pipeline

---

```groovy
podTemplate(
    label: "kubernetes",
    serviceAccount: "jenkins",
    yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:18.03-git
    command: ["sleep"]
    args: ["100000"]
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run/docker.sock
  - name: golang
    image: golang:1.9
    command: ["sleep"]
    args: ["100000"]
  - name: helm
    image: vfarcic/helm:2.8.2
    command: ["sleep"]
    args: ["100000"]
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
      type: Socket
"""
) {
    node("kubernetes") {
        stage("test") {
            container("golang") {
                env.IP = "[REPLACE_ME]"
                git "https://github.com/vfarcic/go-demo-3.git"
                sh "go get -d -v -t"
                sh "go test --cover -v ./... --run UnitTest"
                sh "go build -v -o go-demo"
            }
        }
        stage("build") {
            container("docker") {
                sh "docker image build -t vfarcic/go-demo-3:workshop-beta-${env.BUILD_NUMBER} -f Dockerfile.old ."
                withCredentials([usernamePassword(
                    credentialsId: "docker",
                    usernameVariable: "USER",
                    passwordVariable: "PASS"
                )]) {
                    sh "docker login -u $USER -p $PASS"
                }
                sh "docker image push vfarcic/go-demo-3:workshop-beta-${env.BUILD_NUMBER}"
                sh "docker logout"
            }
        }
        stage("func-test") {
            try {
                container("helm") {
                    sh """helm upgrade go-demo-3-workshop-beta-${env.BUILD_NUMBER} \
                        helm/go-demo-3 -i \
                        --namespace go-demo-3-build \
                        --set image.tag=workshop-beta-${env.BUILD_NUMBER} \
                        --set ingress.host=go-demo-3-beta-${env.BUILD_NUMBER}.${env.IP}.nip.io"""
                    sh """kubectl rollout status \
                        -n go-demo-3-build \
                        deployment go-demo-3-workshop-beta-${env.BUILD_NUMBER}"""
                    env.HOST = sh script: """kubectl get \
                        ing go-demo-3-workshop-beta-${env.BUILD_NUMBER} \
                        -n go-demo-3-build \
                        -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'""",
                        returnStdout: true
                    sh "echo ${env.HOST}"
                }
                container("golang") {
                    sh "go get -d -v -t"
                    withEnv(["ADDRESS=go-demo-3-beta-${env.BUILD_NUMBER}.${env.IP}.nip.io"]) {
                        sh """go test ./... -v \
                        --run FunctionalTest"""
                    }
                }
            } catch(e) {
                error "Failed functional tests"
            } finally {
                container("helm") {
                    sh """helm delete go-demo-3-workshop-beta-${env.BUILD_NUMBER} --purge"""
                }
            }
        }
    }
}
```


# A Real Pipeline (something)

---

```groovy
podTemplate(
    label: "kubernetes",
    yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker:18.03-git
    command: ["sleep"]
    args: ["100000"]
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run/docker.sock
  - name: helm
    image: vfarcic/helm:2.8.2
    command: ["sleep"]
    args: ["100000"]
  - name: kubectl
    image: vfarcic/kubectl
    command: ["sleep"]
    args: ["100000"]
  - name: golang
    image: golang:1.9
    command: ["sleep"]
    args: ["100000"]
  volumes:
  - name: docker-socket
    hostPath:
      path: /var/run/docker.sock
      type: Socket
"""
) {
    node("kubernetes") {
        stage("build") {
            container("docker") {
                git "https://github.com/vfarcic/go-demo-3.git"
                sh "docker image build -t vfarcic/go-demo-3:workshop-beta-${env.BUILD_NUMBER} -f Dockerfile.old ."
                withCredentials([usernamePassword(
                    credentialsId: "docker",
                    usernameVariable: "USER",
                    passwordVariable: "PASS"
                )]) {
                    sh "docker login -u $USER -p $PASS"
                }
                sh "docker image push vfarcic/go-demo-3:workshop-beta-${env.BUILD_NUMBER}"
            }
        }
        stage("func-test") {
            try {
                container("helm") {
                    sh """helm upgrade \
                        go-demo-3-workshop-beta-${env.BUILD_NUMBER} \
                        helm/go-demo-3 -i \
                        --namespace go-demo-3-workshop \
                        --set image.tag=workshop-beta-${env.BUILD_NUMBER} \
                        --set ingress.path=/go-demo-3-beta-${env.BUILD_NUMBER}/demo"""
                    sh """kubectl rollout status \
                        deployment go-demo-3-workshop-beta-${env.BUILD_NUMBER}"""
                    env.HOST = sh script: """kubectl get \
                        ing go-demo-3-workshop-beta-${env.BUILD_NUMBER} \
                        -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'""",
                        returnStdout: true
                }
                container("golang") {
                    sh "go get -d -v -t"
                    withEnv(["ADDRESS=${env.HOST}/go-demo-3-beta-${env.BUILD_NUMBER}/demo"]) {
                        sh """go test ./... -v \
                        --run FunctionalTest"""
                    }
                }
            } catch(e) {
                error "Failed functional tests"
            } finally {
                container("helm") {
                sh """helm delete \
                    go-demo-3-workshop-beta-${env.BUILD_NUMBER} \
                    --namespace go-demo-3-workshop \
                    --purge"""
                }
            }
        }
        stage("release") {
            node("docker") {
                sh """docker pull ${env.DH_USER}/${env.PROJECT}:${currentBuild.displayName}-beta"""
                sh """docker image tag vfarcic/go-demo-3:workshop-beta-${env.BUILD_NUMBER} vfarcic/go-demo-3:workshop-${env.BUILD_NUMBER}"""
                sh """docker image tag vfarcic/go-demo-3:workshop-beta-${env.BUILD_NUMBER} vfarcic/go-demo-3:latest"""
                withCredentials([usernamePassword(
                    credentialsId: "docker",
                    usernameVariable: "USER",
                    passwordVariable: "PASS"
                    )]) {
                        sh "docker login -u $USER -p $PASS"
                    }
                sh """docker image push vfarcic/go-demo-3:workshop-${env.BUILD_NUMBER}"""
                sh """docker image push vfarcic/go-demo-3:latest"""
                sh "docker logout"
            }
        } 
        stage("deploy") {
            try {
                container("helm") {
                    sh """helm upgrade \
                        go-demo-3-workshop \
                        helm/go-demo-3 -i \
                        --namespace go-demo-3 \
                        --set image.tag=workshop-beta-${env.BUILD_NUMBER} \
                        --set ingress.path=/demo"""
                    sh """kubectl rollout status \
                        -n go-demo-3 \
                        deployment go-demo-3-workshop-${env.BUILD_NUMBER}"""
                    env.HOST = sh script: """kubectl get \
                        -n go-demo-3 \
                        ing go-demo-3 \
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


# Deleting The Master

---

*  Delete the master *my-master*

```bash
kubectl -n jenkins get pvc

kubectl get pv
```

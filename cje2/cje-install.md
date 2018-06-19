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


# Deleting The Master

---

*  Delete the master *my-master*

```bash
kubectl -n jenkins get pvc

kubectl get pv
```

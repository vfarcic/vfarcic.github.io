## Hands-On Time

---

# CD And GitOps


## Defining The Prod Environment

---

```bash
open "https://github.com/vfarcic/k8s-prod.git"
```

* Fork the repo

```bash
cd ..

git clone https://github.com/$GH_USER/k8s-prod.git

cd k8s-prod

cat helm/Chart.yaml

cp helm/requirements-orig.yaml helm/requirements.yaml

cat helm/requirements.yaml

cat helm/values-orig.yaml
```


## Defining The Prod Environment

---

```bash
ls -1 helm/templates

cat helm/templates/ns.yaml

ADDR=$LB_IP.nip.io

echo $ADDR

ADDR_ESC=$(echo $ADDR | sed -e "s@\.@\\\.@g")

echo $ADDR_ESC

cat helm/values-orig.yaml \
    | sed -e "s@acme-escaped.com@$ADDR_ESC@g" \
    | sed -e "s@acme.com@$ADDR@g" | tee helm/values.yaml
```


## Defining The Prod Environment

---

```bash
git add .

git commit -m "Address"

git push

helm dependency update helm

ls -1 helm/charts

helm install helm -n prod --namespace prod
```


## Defining The Prod Environment

---

```bash
kubectl -n prod create secret generic jenkins-credentials \
    --from-file ../k8s-specs/cluster/jenkins/credentials.xml

kubectl -n prod create secret generic jenkins-secrets \
    --from-file ../k8s-specs/cluster/jenkins/secrets

helm ls

kubectl -n prod rollout status deploy prod-chartmuseum

curl "http://cm.$ADDR/health"

kubectl -n prod rollout status deploy prod-jenkins
```


## Defining The Prod Environment

---

```bash
JENKINS_ADDR="jenkins.$ADDR"

open "http://$JENKINS_ADDR"

JENKINS_PASS=$(kubectl -n prod get secret prod-jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo)

echo $JENKINS_PASS
```


## Preparing The Environment

---

```bash
cd ..

git clone https://github.com/$GH_USER/go-demo-5.git

cd go-demo-5

DH_USER=[...]

cat helm/go-demo-5/deployment-orig.yaml \
    | sed -e "s@vfarcic@$DH_USER@g" \
    | tee helm/go-demo-5/templates/deployment.yaml

kubectl apply -f k8s/build.yml --record

helm init --service-account build \
    --tiller-namespace go-demo-5-build
```


## Preparing The Environment

---

```bash
cat Dockerfile
```


## Declarative Pipeline

---

```bash
cat Jenkinsfile.orig

cat KubernetesPod.yaml
```


## Continuous Delivery Job

---

```bash
cat Jenkinsfile.orig | sed -e "s@acme.com@$ADDR@g" \
    | sed -e "s@vfarcic@$DH_USER@g" | tee Jenkinsfile

git add .

git commit -m "Jenkinsfile"

git push
```


## Continuous Delivery Job

---

```bash
cd ..

git clone https://github.com/$GH_USER/jenkins-shared-libraries.git

cd jenkins-shared-libraries

git remote add upstream \
    https://github.com/vfarcic/jenkins-shared-libraries.git

git fetch upstream

git checkout master

git merge upstream/master

cd ../go-demo-5
```


## Continuous Delivery Job

---

```bash
open "http://$JENKINS_ADDR/configure"

open "http://$JENKINS_ADDR/blue/organizations/jenkins/"

curl "http://cm.$ADDR/index.yaml"

VERSION=[...]

helm repo add chartmuseum http://cm.$ADDR

helm repo list

helm repo update

helm inspect chartmuseum/go-demo-5 --version $VERSION
```


## Upgrading The Production

---

```bash
cd ../k8s-prod

cat helm/requirements.yaml

echo "- name: go-demo-5
  repository: \"@chartmuseum\"
  version: $VERSION" | tee -a helm/requirements.yaml

cat helm/requirements.yaml

echo "go-demo-5:
  ingress:
    host: go-demo-5.$ADDR" | tee -a helm/values.yaml

cat helm/values.yaml
```


## Upgrading The Production

---

```bash
git add .

git commit -m "Added go-demo-5"

git push

helm dependency update helm

ls -1 helm/charts
```


## Upgrading The Production

---

```bash
helm upgrade prod helm --namespace prod

kubectl -n prod get pods

kubectl -n prod rollout status deployment prod-go-demo-5

curl -i "http://go-demo-5.$ADDR/demo/hello"

kubectl -n prod describe deploy prod-go-demo-5
```


## Jenkins Job For Prod Env

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/go-demo-5/branches"

cd ../go-demo-5

git add .

git commit -m "Version bump"

git push

open "http://$JENKINS_ADDR/blue/organizations/jenkins/go-demo-5/branches"
```


## Automating Prod Upgrade

---

```bash
cd ../k8s-prod

cat Jenkinsfile.orig

cat Jenkinsfile.orig | sed -e "s@acme.com@$ADDR@g" | tee Jenkinsfile

git add .

git commit -m "Jenkinsfile"

git push

open "http://$JENKINS_ADDR/blue/pipelines"

helm history prod
```


## High-Level Overview

---


<!-- .slide: data-background="img/cdp-stages-full.png" data-background-size="contain" -->


<!-- .slide: data-background="img/cd-stages.png" data-background-size="contain" -->


<!-- .slide: data-background="img/deployment-stage.png" data-background-size="contain" -->


<!-- .slide: data-background="img/cd-high-level.png" data-background-size="contain" -->


## What Now?

---

TODO

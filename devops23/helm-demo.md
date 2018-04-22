## Hands-On Time

---

# Helm


## Setup

---

```bash
open "https://github.com/kubernetes/helm/releases"

# Or https://docs.helm.sh/using_helm/#installing-the-helm-client

cat helm/tiller-rbac.yml

kubectl create -f helm/tiller-rbac.yml --record --save-config

helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy

kubectl -n kube-system get pods
```


## Jenkins

---

```bash
helm repo update

helm search

helm search jenkins

kubectl create ns jenkins

helm install stable/jenkins --name jenkins --namespace jenkins
```


## Jenkins

---

```bash
kubectl -n jenkins get svc jenkins -o json

kubectl -n jenkins get svc jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"

DNS=$(kubectl -n jenkins get svc jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

kubectl -n jenkins get all

open "http://$DNS:8080"

kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo
```


## Jenkins

---

* Login with user `admin`

```bash
helm inspect stable/jenkins

helm ls

helm status jenkins

helm delete jenkins

helm status jenkins

helm delete jenkins --purge

helm status jenkins
```


## Jenkins

---

```bash
helm inspect values stable/jenkins

helm install stable/jenkins --name jenkins \
    --namespace jenkins --set Master.ImageTag=2.112-alpine

kubectl -n jenkins rollout status deployment jenkins

DNS=$(kubectl -n jenkins get svc jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

open "http://$DNS:8080"
```

* Note the version on the bottom-right


## Jenkins

---

```bash
helm upgrade jenkins stable/jenkins \
    --set Master.ImageTag=2.116-alpine

kubectl -n jenkins describe deployment jenkins

kubectl -n jenkins rollout status deployment jenkins

open "http://$DNS:8080/manage"

kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo
```

* Login with user `admin`


## Jenkins

---

```bash
helm list

helm rollback jenkins 1

helm delete jenkins --purge

export LB_ADDR=$(kubectl -n kube-ingress get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

LB_IP=$(dig +short $LB_ADDR | tail -n 1)

JENKINS_ADDR="jenkins.$LB_IP.xip.io"

helm install stable/jenkins --name jenkins --namespace jenkins \
    --values helm/jenkins-values.yml \
    --set Master.HostName=$JENKINS_ADDR
```


## Jenkins

---

```bash
kubectl -n jenkins rollout status deployment jenkins

open "http://$JENKINS_ADDR"

kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo
    
helm get values jenkins

helm delete jenkins --purge

kubectl delete ns jenkins
```


## Creating Charts

---

```bash
cd ../go-demo-3

helm create my-app

helm dependency update

helm package my-app

helm lint my-app

rm -rf my-app

helm install ./my-app-0.1.0.tgz --name my-app

helm delete my-app --purge
```


## Creating Charts

---

```bash
helm lint helm/go-demo-3

helm package helm/go-demo-3 -d helm
```


## Release

---

```bash
TAG=0.0.1

git tag -a $TAG -m 'A new release. Hooray!'

GITHUB_USER=[...]

GITHUB_TOKEN=[...]

git push \
    https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/go-demo-3.git \
    --tags

open "https://github.com/$GITHUB_USER/go-demo-3/tags"
```


## Release

---

```bash
docker container run --rm -e GITHUB_TOKEN=$GITHUB_TOKEN \
    -v $PWD:/src -w /src vfarcic/github-release \
    github-release release --user $GITHUB_USER --repo go-demo-3 \
    --tag $TAG --name "A real release" \
    --description "Read the docs, if you can find them."

open "https://github.com/$GITHUB_USER/go-demo-3/releases"

docker container run --rm -e GITHUB_TOKEN=$GITHUB_TOKEN \
    -v $PWD:/src -w /src vfarcic/github-release \
    github-release upload --user $GITHUB_USER --repo go-demo-3 \
    --tag $TAG --name go-demo-3-0.0.1.tgz \
    --file helm/go-demo-3-0.0.1.tgz

open "https://github.com/$GITHUB_USER/go-demo-3/releases"
```


## Release

---

```bash
HELM_ADDR=https://github.com/$GITHUB_USER/go-demo-3/releases/download/$TAG/go-demo-3-$TAG.tgz

rm helm/go-demo-3-$TAG.tgz

cd ../k8s-specs
```


## Local (Docker For Mac)

---

* Instructions for setting up Docker for Mac/Windows and Kubernetes

```bash
kubectl config set current-context docker-for-desktop

helm inspect values $HELM_ADDR

helm install $HELM_ADDR --name go-demo-3 --set replicaCount=1 \
    --set dbReplicaCount=1 --set service.type=NodePort \
    --set ingress.enabled=false

kubectl -n default rollout status deployment go-demo-3

export NODE_PORT=$(kubectl -n default get svc go-demo-3 \
    -o jsonpath="{.spec.ports[0].nodePort}")

export NODE_IP=localhost

curl http://$NODE_IP:$NODE_PORT/demo/hello
```


## Local (Docker For Mac)

---

```bash
helm delete go-demo-3 --purge

helm install $HELM_ADDR --name go-demo-3 \
    -f ../go-demo-3/helm/dev.yaml

kubectl -n default rollout status deployment go-demo-3

export NODE_PORT=$(kubectl -n default get svc go-demo-3 \
    -o jsonpath="{.spec.ports[0].nodePort}")

export NODE_IP=localhost

curl http://$NODE_IP:$NODE_PORT/demo/hello

helm delete go-demo-3 --purge
```


## Testing

---

```bash
kubectl config set current-context devops23.k8s.local

kubectl create ns go-demo-3-1-0-beta

helm install $HELM_ADDR --name go-demo-3-1-0-beta \
    --namespace go-demo-3-1-0-beta --set image.tag=1.0-beta \
    --set ingress.path=/1-0-beta/demo

kubectl -n go-demo-3-1-0-beta rollout status \
    deployment go-demo-3-1-0-beta

export LB_IP=$(kubectl -n go-demo-3-1-0-beta \
    get ing go-demo-3-1-0-beta \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

curl http://$LB_IP/1-0-beta/demo/hello
```


## Testing

---

```bash
helm delete go-demo-3-1-0-beta --purge

kubectl delete ns go-demo-3-1-0-beta
```


## Production

---

```bash
kubectl create ns go-demo-3

helm upgrade -i go-demo-3 $HELM_ADDR --namespace go-demo-3

kubectl -n go-demo-3 rollout status deployment go-demo-3

export LB_IP=$(kubectl -n go-demo-3 get ing go-demo-3 \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

curl http://$LB_IP/demo/hello

kubectl -n go-demo-3 describe deployment go-demo-3

helm upgrade -i go-demo-3 $HELM_ADDR --namespace go-demo-3 \
    --set image.tag=1.0
```


## Production

---

```bash
kubectl -n go-demo-3 describe deployment go-demo-3

curl http://$LB_IP/demo/hello
```


## What Now?

---

```bash
TODO
```

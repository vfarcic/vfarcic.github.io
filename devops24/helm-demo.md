## Hands-On Time

---

# Packaging Kubernetes Applications


## Installing Helm

---

```bash
# Only if MacOC
brew install kubernetes-helm

# Only if Windows
choco install kubernetes-helm

# Only if Linux
open https://github.com/kubernetes/helm/releases

# Only if Linux
# Download tar.gz file, unpack it, move binary to /usr/local/bin/.

cat helm/tiller-rbac.yml

kubectl create -f helm/tiller-rbac.yml --record --save-config
```


## Installing Helm

---

```bash
helm init --service-account tiller

kubectl -n kube-system rollout status deploy tiller-deploy

kubectl -n kube-system get pods

helm repo update

helm search
```


## Installing Helm Charts

---

```bash
helm search jenkins

helm install stable/jenkins --name jenkins --namespace jenkins

kubectl -n jenkins \
    rollout status deploy jenkins

ADDR=$(kubectl -n jenkins get svc jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"):8080

echo $ADDR

open "http://$ADDR"
```


## Installing Helm Charts

---

```bash
kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo

helm inspect stable/jenkins

helm ls

helm status jenkins

kubectl -n kube-system get cm

kubectl -n kube-system describe cm jenkins.v1
```


## Installing Helm Charts

---

```bash
helm delete jenkins

kubectl -n jenkins get all

helm status jenkins

helm delete jenkins --purge

helm status jenkins
```


## Customizing Helm Installations

---

```bash
helm inspect values stable/jenkins

helm inspect stable/jenkins

helm install stable/jenkins --name jenkins --namespace jenkins \
    --set Master.ImageTag=2.112-alpine

kubectl -n jenkins rollout status deployment jenkins

ADDR=$(kubectl -n jenkins get svc jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"):8080

echo $ADDR

open "http://$ADDR"
```


## Customizing Helm Installations

---

```bash
helm upgrade jenkins stable/jenkins \
    --set Master.ImageTag=2.116-alpine --reuse-values

kubectl -n jenkins describe deployment jenkins

kubectl -n jenkins rollout status deployment jenkins

open "http://$ADDR"
```


## Rolling Back Helm Revisions

---

```bash
helm list

# helm rollback jenkins 1

helm rollback jenkins 0

helm list

kubectl -n jenkins rollout status deployment jenkins

open "http://$ADDR"

helm delete jenkins --purge
```


## Using YAML Values

---

```bash
HOST="jenkins.$LB_IP.xip.io"

echo $HOST

helm inspect values stable/jenkins

cat helm/jenkins-values.yml
```


## Using YAML Values

---

```bash
helm install stable/jenkins --name jenkins --namespace jenkins \
    --values helm/jenkins-values.yml --set Master.HostName=$HOST

kubectl -n jenkins rollout status deployment jenkins

open "http://$HOST"

helm get values jenkins

helm delete jenkins --purge

kubectl delete ns jenkins
```


## Creating Helm Charts

---

```bash
cd ../go-demo-3

git add .

git commit -m "Defining Continuous Deployment chapter"

git push

git remote add upstream https://github.com/vfarcic/go-demo-3.git

git fetch upstream

git checkout master

git merge upstream/master
```


## Creating Helm Charts

---

```bash
helm create my-app

ls -1 my-app

helm dependency update my-app

helm package my-app

helm lint my-app

helm install ./my-app-0.1.0.tgz --name my-app
```


## Creating Helm Charts

---

```bash
helm delete my-app --purge

rm -rf my-app

rm -rf my-app-0.1.0.tgz
```


## Exploring Files From A Chart

---

```bash
ls -1 helm/go-demo-3

cat helm/go-demo-3/Chart.yaml

cat helm/go-demo-3/LICENSE

cat helm/go-demo-3/README.md

cat helm/go-demo-3/values.yaml
```


## Exploring Files From A Chart

---

```bash
ls -1 helm/go-demo-3/templates/

cat helm/go-demo-3/templates/NOTES.txt

cat helm/go-demo-3/templates/_helpers.tpl

cat helm/go-demo-3/templates/deployment.yaml

cat helm/go-demo-3/templates/ing.yaml

helm lint helm/go-demo-3

helm package helm/go-demo-3 -d helm
```


## Upgrading Charts

---

```bash
helm inspect values helm/go-demo-3

HOST="go-demo-3.$LB_IP.xip.io"

echo $HOST

helm upgrade -i go-demo-3 helm/go-demo-3 --namespace go-demo-3 \
    --set image.tag=1.0 --set ingress.host=$HOST --reuse-values

kubectl -n go-demo-3 rollout status deployment go-demo-3

curl http://$HOST/demo/hello
```


## Upgrading Charts

---

```bash
helm upgrade -i go-demo-3 helm/go-demo-3 --namespace go-demo-3 \
    --set image.tag=2.0 --reuse-values
```


## What Now?

---

```bash
helm delete go-demo-3 --purge

kubectl delete ns go-demo-3

cd ../k8s-specs
```

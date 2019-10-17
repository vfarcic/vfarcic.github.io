<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Managing Third-Party Applications

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Application-Specific Dependencies


<!-- .slide: data-background="img/app-dependencies.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments


<!-- .slide: data-background="img/app-dependencies-shared.png" data-background-size="contain" -->


<!-- .slide: data-background="img/app-dependencies-shared-env.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
ENVIRONMENT=[...]

rm -rf environment-$ENVIRONMENT-staging

GH_USER=[...]

git clone \
    https://github.com/$GH_USER/environment-$ENVIRONMENT-staging.git

cd environment-$ENVIRONMENT-staging
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
cat env/requirements.yaml

echo "- name: postgresql
  version: 5.0.0
  repository: https://kubernetes-charts.storage.googleapis.com" \
    | tee -a env/requirements.yaml

git add .

git commit -m "Added PostgreSQL"

git push
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
jx get activities --filter environment-$ENVIRONMENT-staging --watch

NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')

kubectl --namespace $NAMESPACE-staging get pods,services
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
cd ..

rm -rf environment-$ENVIRONMENT-production

git clone \
    https://github.com/$GH_USER/environment-$ENVIRONMENT-production.git

cd environment-$ENVIRONMENT-production
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
echo "- name: postgresql
  version: 5.0.0
  repository: https://kubernetes-charts.storage.googleapis.com" \
    | tee -a env/requirements.yaml

helm inspect values stable/postgresql

echo "postgresql:
  replication:
    enabled: true" \
    | tee -a env/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
git add .

git commit -m "Added PostgreSQL"

git push

jx get activities --filter environment-$ENVIRONMENT-production --watch

kubectl --namespace $NAMESPACE-production get pods,services

cat env/requirements.yaml | sed '$d' | sed '$d' | sed '$d' \
    | tee env/requirements.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
git add .

git commit -m "Removed PostgreSQL"

git push

cd ../environment-$ENVIRONMENT-staging

cat env/requirements.yaml | sed '$d' | sed '$d' | sed '$d' \
    | tee env/requirements.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Permanent Environments

```bash
git add .

git commit -m "Removed PostgreSQL"

git push

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Development Environment

```bash
kubectl get pods

CLUSTER_NAME=[...]

cd environment-$CLUSTER_NAME-dev

cat env/requirements.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Development Environment

```bash
kubectl get ingresses

NEXUS_ADDR=$(kubectl get ingress nexus \
    --output jsonpath="{.spec.rules[0].host}")

open "http://$NEXUS_ADDR"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Development Environment

```bash
git pull

ls -1 env

cat env/nexus/values.yaml

cat env/nexus/values.yaml | sed -e 's@enabled: true@enabled: false@g' \
    | tee env/nexus/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Development Environment

```bash
git add .

git commit -m "Removed Nexus"

git push

jx get activity --filter environment-$CLUSTER_NAME-dev/master --watch

kubectl get ingresses

open "http://$NEXUS_ADDR"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Development Environment

```bash
kubectl get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

* the ability to interactively ask questions to generate values.yaml based on JSON Schema
* the ability to create pull requests against the GitOps repo that manages your team/cluster
* the ability to store secrets in vault
* the ability to upgrade all apps to the latest version


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

**Upcoming**

* integrating kustomize to allow existing charts to be modified
* storing Helm repository credentials in vault
* taking existing values.yaml as defaults when asking questions based on JSON Schema during app upgrade
* only asking new questions during app upgrade
* jx get apps - the ability to list all apps that can be installed
* integration for bash completion


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

```bash
open "https://github.com/jenkins-x-apps"

jx add app jx-app-prometheus

jx get activity --filter environment-$CLUSTER_NAME-dev/master --watch

kubectl get pods --selector app=prometheus

kubectl get ingresses
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

```bash
# If NOT EKS
LB_IP=$(kubectl --namespace kube-system \
    get service jxing-nginx-ingress-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If EKS
LB_HOST=$(kubectl --namespace kube-system \
    get service jxing-nginx-ingress-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If EKS
export LB_IP="$(dig +short $LB_HOST | tail -n 1)"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

```bash
echo $LB_IP

git pull

echo "prometheus:
  server:
    ingress:
      enabled: true
      hosts:
      - prometheus.$LB_IP.nip.io" \
    | tee env/jx-app-prometheus/values.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

```bash
git add .

git commit -m "Prometheus Ingress"

git push

jx get activity --filter environment-$CLUSTER_NAME-dev/master --watch

kubectl get ingresses

open "http://prometheus.$LB_IP.nip.io"
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps

```bash
jx delete app jx-app-prometheus

jx get activity --filter environment-$CLUSTER_NAME-dev/master --watch

kubectl get pods --selector app=prometheus
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps From Helm Charts

```bash
jx add app istio-init \
    --repository https://storage.googleapis.com/istio-release/releases/1.3.2/charts/

jx get activity --filter environment-$CLUSTER_NAME-dev/master --watch

kubectl get crds | grep 'istio.io'

git pull

cp -r env/istio-init env/istio
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps From Helm Charts

```bash
cat env/istio/templates/app.yaml

cat env/istio/templates/app.yaml | sed -e 's@istio-init@istio@g' \
    | sed -e 's@initialize Istio CRDs@install Istio@g' \
    | tee env/istio/templates/app.yaml

cat env/requirements.yaml

echo "- name: istio
  repository: https://storage.googleapis.com/istio-release/releases/1.3.2/charts/
  version: 1.3.2" | tee -a env/requirements.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps From Helm Charts

```bash
git add .

git commit -m "Added Istio"

git push

jx get activity --filter environment-$CLUSTER_NAME-dev/master --watch

kubectl get pods | grep istio
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Jenkins X Apps From Helm Charts

```bash
jx get apps

git pull

jx delete app istio

git pull

jx delete app istio-init
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Which Method Should We Use?

A third-party application that is a dependency of a **single in-house application** should be defined in **the repository of that application**.

Example: a database used by a single application.


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Which Method Should We Use?

A third-party application that is a dependency of **multiple in-house applications** and might need to **run in multiple environments** (e.g., staging, production) should be defined in **repositories associated with those environments**.

Example: a database used by multiple applications.


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Which Method Should We Use?

A third-party application that is a dependency of **multiple in-house applications** and **does not need to run in multiple environments** should be defined as an **App stored in the `dev` repository**.

Example: Prometheus that often runs in a single environment and no in-house applications depend on it.


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 14</div>
<div class="label">Hands-on Time</div>

## Which Method Should We Use?

A third-party application that is a **used by the system as a whole** and **does not need to run in multiple environments** should be defined as an **App stored in the `dev` repository**.

Example: Istio that is a cluster-wide third-party application or, to be more precise, a system (Kubernetes) component.


## What Now?

```bash
cd ..
```

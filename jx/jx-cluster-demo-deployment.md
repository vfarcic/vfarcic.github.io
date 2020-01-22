<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export PROJECT=[...] # Replace `[...]` with the project ID

git clone https://github.com/vfarcic/terraform-gke.git

cd terraform-gke

git checkout jx-deployment

git pull
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
# Create a service account (https://console.cloud.google.com/apis/credentials/serviceaccountkey)

# Download the JSON and store it as account.json in this directory

terraform apply

export CLUSTER_NAME=$(terraform output cluster_name)

export KUBECONFIG=$PWD/kubeconfig
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
gcloud container clusters \
    get-credentials $(terraform output cluster_name) \
    --project $(terraform output project_id) \
        --region $(terraform output region)

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git clone \
    https://github.com/jenkins-x/jenkins-x-boot-config.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

vim jx-requirements.yml

# Set `cluster.clusterName` to `devops-27-demo`
# Set `cluster.environmentGitOwner`
# Set `cluster.project` to `devops-27`
# Set `cluster.zone` to `us-east1`
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx boot

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
glooctl install knative --install-knative-version=0.9.0

istioctl manifest apply --skip-confirmation

kubectl apply \
    --kustomize github.com/weaveworks/flagger/kustomize/istio
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
KNATIVE_IP=$(kubectl --namespace gloo-system \
    get service knative-external-proxy \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: config-domain
  namespace: knative-serving
data:
  $KNATIVE_IP.nip.io: \"\"" \
    | kubectl apply --filename -
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
LB_IP=$(kubectl --namespace kube-system \
    get svc jxing-nginx-ingress-controller \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo "apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: flagger-grafana
  namespace: istio-system
spec:
  rules:
  - host: flagger-grafana.$LB_IP.nip.io
    http:
      paths:
      - backend:
          serviceName: flagger-grafana
          servicePort: 80
" | kubectl create -f -
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Setting The Scene (Serverless)

```bash
jx create quickstart --filter golang-http --project-name jx-knative \
    --deploy-kind knative --batch-mode

jx get activity --filter jx-knative --watch
```


## Setting The Scene (Recreate)

```bash
jx create quickstart --filter golang-http --project-name jx-recreate \
    --deploy-kind default --batch-mode

jx get activity --filter jx-recreate --watch

cd jx-recreate

cat charts/jx-recreate/templates/deployment.yaml | sed -e \
    's@  replicas:@  strategy:\
    type: Recreate\
  replicas:@g' | tee charts/jx-recreate/templates/deployment.yaml
```


## Setting The Scene (Recreate)

```bash
cat charts/jx-recreate/values.yaml \
    | sed -e 's@replicaCount: 1@replicaCount: 5@g' \
    | tee charts/jx-recreate/values.yaml

git add . && git commit -m "Recreate"

git push --set-upstream origin master

jx get activity --filter jx-recreate --watch

cd ..
```


## Setting The Scene (Rolling Update)

```bash
jx create quickstart --filter golang-http --project-name jx-rolling \
    --deploy-kind default --batch-mode

jx get activity --filter jx-rolling --watch

cd jx-rolling

cat charts/jx-rolling/values.yaml \
    | sed -e 's@replicaCount: 1@replicaCount: 5@g' \
    | tee charts/jx-rolling/values.yaml
```


## Setting The Scene (Rolling Update)

```bash
git add . && git commit -m "Rolling"

git push --set-upstream origin master

jx get activity --filter jx-rolling --watch

cd ..
```


## Setting The Scene (Canary)

```bash
jx create quickstart --filter golang-http --project-name jx-canary \
    --deploy-kind default --batch-mode

jx get activity --filter jx-canary --watch

kubectl label namespace jx-staging istio-injection=enabled --overwrite

export GH_USER=[...]

export ISTIO_IP=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')
```


## Setting The Scene (Canary)

```bash
export CANARY_ADDR=staging.jx-canary.$ISTIO_IP.nip.io

jx get activity --filter environment-$CLUSTER_NAME-staging/master --watch

git clone \
    https://github.com/$GH_USER/environment-$CLUSTER_NAME-staging.git

cd environment-$CLUSTER_NAME-staging
```


## Setting The Scene (Canary)

```bash
echo "jx-canary:
  hpa:
    enabled: true
    minReplicas: 5
  canary:
    enabled: true
    host: $CANARY_ADDR
" | tee -a env/values.yaml

git add . && git commit -m "Added progressive deployment" && git push
```


## Setting The Scene (Canary)

```bash
jx get activity --filter environment-$CLUSTER_NAME-staging/master \
    --watch
```

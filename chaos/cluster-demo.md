<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# The Requirements

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## ChaosToolkit

```bash
pip install -U chaostoolkit

chaos --help

# If `chaos` fails, you might want to activate the virtual environment.
source ~/.venvs/chaostk/bin/activate \
    && python3 -m venv ~/.venvs/chaostk

pip install -U chaostoolkit-kubernetes

pip install -U chaostoolkit-istio
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Kubernetes Cluster

```bash
gcloud auth login

# Open https://console.cloud.google.com/cloud-resource-manager to create a new project if you don't have one already

export PROJECT_ID=[...] # Replace [...] with the ID of the project

gcloud container get-server-config --region us-east1

export VERSION=[...] # Replace [...] with k8s version from the `validMasterVersions` section. Make sure that it is v1.14+.
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Kubernetes Cluster

```bash
gcloud container clusters create chaos --project $PROJECT_ID \
    --cluster-version $VERSION --region us-east1 \
    --machine-type n1-standard-2 --enable-autoscaling \
    --num-nodes 1 --max-nodes 3 --min-nodes 1

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Ingress

```bash
kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.0/deploy/static/mandatory.yaml

kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.0/deploy/static/provider/cloud-generic.yaml

export INGRESS_HOST=$(kubectl --namespace ingress-nginx \
    get service ingress-nginx \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $INGRESS_HOST

# Repeat the `export` command if the output is empty
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Istio

```bash
istioctl manifest apply --skip-confirmation

export ISTIO_HOST=$(kubectl --namespace istio-system \
    get service istio-ingressgateway \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $ISTIO_HOST

# Repeat the `export` command if the output of the `echo` command is empty
```

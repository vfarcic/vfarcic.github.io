<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Cluster

```bash
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export PROJECT_ID=dot-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

# Open the URL from the output and enable the Kubernetes API
```


## Cluster

```bash
export KUBECONFIG=$PWD/kubeconfig.yaml

gcloud container clusters create dot --project $PROJECT_ID \
    --region us-east1 --machine-type e2-standard-4 \
    --num-nodes 1 --enable-network-policy \
    --no-enable-autoupgrade
```


## Ingress

```bash
helm upgrade --install traefik traefik \
    --repo https://helm.traefik.io/traefik \
    --namespace traefik --create-namespace --wait

export INGRESS_HOST=$(kubectl --namespace traefik \
    get service traefik \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $INGRESS_HOST
```


## Observability

```bash
helm upgrade --install \
    k8s-event-logger k8s-event-logger \
    --repo https://charts.deliveryhero.io \
    --namespace observability --create-namespace --wait
```


## Crossplane

```bash
helm upgrade --install crossplane crossplane \
    --repo https://charts.crossplane.io/stable \
    --namespace crossplane-system --create-namespace --wait
```


## Kubernetes Composition

```bash
git clone https://github.com/vfarcic/crossplane-kubernetes

cd crossplane-kubernetes

kubectl apply \
    --filename providers/provider-kubernetes-incluster.yaml

kubectl apply \
    --filename providers/provider-helm-incluster.yaml

kubectl apply --filename config.yaml
```


## SQL Composition

```bash
cd ..

git clone https://github.com/vfarcic/crossplane-sql

cd crossplane-sql

kubectl apply --filename config.yaml

# Wait for an hour approx. for the cluster to "stabilize".

kubectl wait --for=condition=healthy provider.pkg.crossplane.io \
    --all --timeout=5m
```


## Crossplane In Google Cloud

```bash
kubectl apply \
    --filename crossplane-config/provider-gcp-official.yaml

echo "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE API*

export SA_NAME=devops-toolkit

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts create $SA_NAME \
    --project $PROJECT_ID
```


## Crossplane In Google Cloud

```bash
export ROLE=roles/admin

gcloud projects add-iam-policy-binding --role $ROLE $PROJECT_ID \
    --member serviceAccount:$SA

gcloud iam service-accounts keys create gcp-creds.json \
    --project $PROJECT_ID --iam-account $SA

kubectl --namespace crossplane-system \
    create secret generic gcp-creds \
    --from-file creds=./gcp-creds.json
```


## Crossplane In Google Cloud

```bash
echo "apiVersion: gcp.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  projectID: $PROJECT_ID
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: gcp-creds
      key: creds" \
    | kubectl apply --filename -
```


## Prometheus

```bash
cd ..

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

kubectl create namespace a-team
```


## Prometheus

```bash
yq --inplace \
    ".grafana.ingress.hosts[0] = \"grafana.$INGRESS_HOST.nip.io\"" \
    examples/observability/prometheus-stack-values-google.yaml

yq --inplace \
    ".grafana.ingress.ingressClassName = \"$INGRESS_CLASS\"" \
    examples/observability/prometheus-stack-values-google.yaml

yq --inplace \
    ".prometheus.ingress.hosts[0] = \"prometheus.$INGRESS_HOST.nip.io\"" \
    examples/observability/prometheus-stack-values-google.yaml

yq --inplace \
    ".prometheus.ingress.ingressClassName = \"$INGRESS_CLASS\"" \
    examples/observability/prometheus-stack-values-google.yaml
```


## Prometheus

```bash
kubectl --namespace observability apply \
    --filename examples/observability/ksm-cm-google.yaml

helm upgrade --install prometheus-stack kube-prometheus-stack \
    --repo https://prometheus-community.github.io/helm-charts \
    --namespace observability --create-namespace \
    --values examples/observability/prometheus-stack-values-google.yaml \
    --wait
```


## Loki

```bash
helm upgrade --install loki-stack grafana/loki-stack \
    --namespace observability --create-namespace \
    --wait
```


## Grafana

```bash
echo "http://grafana.$INGRESS_IP.nip.io"

# Open the address in a browser

# Use `admin` as the username and the initial password

# Add `Loki` as a data source
# URL: http://loki-stack:3100

# Open https://raw.githubusercontent.com/vfarcic/devops-toolkit-crossplane/master/examples/observability/grafana-dashboard-google.json

# Copy the output

# Import the dashboard using the copied output
```


## Production Cluster

```bash
kubectl --namespace a-team apply \
    --filename examples/k8s/gcp-gke-official.yaml
```


## The App

```bash
cd ..

git clone https://github.com/vfarcic/silly-demo

cd silly-demo
```
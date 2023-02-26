<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Cluster

* Create a management Kubernetes cluster with an Ingress controller.
* This demo is using Rancher Desktop but any other Kubernetes cluster should work as well.
* If you're using a local Kubernetes cluster (e.g., Rancher Desktop, Minikube, etc.), make sure that it has at least 8GB of RAM and 4 CPU of memory.


## Ingress

```bash
# If not using Rancher Desktop, please replace `traefik` with
#   the Ingress class name
export INGRESS_CLASS=traefik

# If not using Rancher Desktop, please replace `127.0.0.1` with
#   the external IP of the Ingress service
export INGRESS_IP=127.0.0.1

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane
```


## Observability

```bash
helm repo add prometheus-community \
    https://prometheus-community.github.io/helm-charts

helm repo add deliveryhero https://charts.deliveryhero.io/

helm repo add crossplane-stable

helm repo update

helm upgrade --install \
    k8s-event-logger deliveryhero/k8s-event-logger \
    --namespace observability --create-namespace --wait
```


## Crossplane

```bash
helm upgrade --install crossplane crossplane-stable/crossplane \
    --namespace crossplane-system --create-namespace --wait

kubectl apply \
    --filename crossplane-config/provider-kubernetes-incluster.yaml

kubectl apply --filename crossplane-config/config-sql.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml
```


## Crossplane In Google Cloud

* The demo uses Google Cloud Platform (GCP) but any other cloud provider should work as well.
* If you are NOT using GCP you might need to modify the commands and the manifests

```bash
kubectl apply \
    --filename crossplane-config/provider-gcp-official.yaml

export PROJECT_ID=dot-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID
```


## Crossplane In Google Cloud

```bash
echo "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE API*

echo "https://console.cloud.google.com/apis/library/sqladmin.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE API*

export SA_NAME=devops-toolkit

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts create $SA_NAME --project $PROJECT_ID
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
kubectl get pkgrev

# Wait until all the packages are healthy
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
kubectl create namespace a-team

yq --inplace \
    ".grafana.ingress.hosts[0] = \"grafana.$INGRESS_IP.nip.io\"" \
    examples/observability/prometheus-stack-values-google.yaml

yq --inplace \
    ".grafana.ingress.ingressClassName = \"$INGRESS_CLASS\"" \
    examples/observability/prometheus-stack-values-google.yaml

yq --inplace \
    ".prometheus.ingress.hosts[0] = \"prometheus.$INGRESS_IP.nip.io\"" \
    examples/observability/prometheus-stack-values-google.yaml
```


## Prometheus

```bash
yq --inplace \
    ".prometheus.ingress.ingressClassName = \"$INGRESS_CLASS\"" \
    examples/observability/prometheus-stack-values-google.yaml

kubectl --namespace observability apply \
    --filename examples/observability/ksm-cm-google.yaml

helm upgrade --install \
    prometheus-stack prometheus-community/kube-prometheus-stack \
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
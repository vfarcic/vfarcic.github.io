<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Policies


## Setup

```bash
# If AWS
export CLUSTER_TYPE=eks

# If Azure
export CLUSTER_TYPE=aks

# If Google Cloud
export CLUSTER_TYPE=gke

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl --namespace a-team apply \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml
```


## Setup

```bash
kubectl --namespace a-team get clusterclaims

# Wait until it is `READY`

# If Google
KUBECONFIG=$PWD/kubeconfig.yaml gcloud container clusters \
    get-credentials a-team-gke --project $PROJECT_ID \
    --region us-east1

# If NOT Google
./examples/k8s/get-kubeconfig-$CLUSTER_TYPE.sh
```


## Setup Kyverno

```bash
helm repo add kyverno https://kyverno.github.io/kyverno

helm upgrade  --install kyverno kyverno/kyverno \
    --namespace kyverno --create-namespace --wait

helm upgrade --install \
    kyverno-policies kyverno/kyverno-policies \
    --namespace kyverno --wait

kubectl apply --filename examples/k8s/kyverno.yaml

kubectl --namespace b-team apply \
    --filename examples/k8s/kyverno-b-team.yaml
```


## Policies In Action

```bash
diff examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml \
    examples/k8s/$PROVIDER-$CLUSTER_TYPE-very-large.yaml

kubectl --namespace a-team apply \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE-very-large.yaml

kubectl --namespace b-team apply \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml
```


## Policies Explained

```bash
cat examples/k8s/kyverno.yaml

cat examples/k8s/kyverno-b-team.yaml
```
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Composite Resources


## Create A Database

```bash
# If Azure
export RESOURCE_GROUP=dot$(date +%Y%m%d%H%M%S)

# If Azure
yq --inplace \
    ".spec.id = \"$RESOURCE_GROUP\"" \
    examples/sql/$PROVIDER.yaml

# If Azure
kubectl --namespace crossplane-system \
    create secret generic $RESOURCE_GROUP-creds \
    --from-literal password=ComplexPassword123@
```


## Create A Database

```bash
kubectl apply --filename crossplane-config/config-sql.yaml

kubectl get pkgrev

cat examples/sql/$PROVIDER.yaml

kubectl --namespace a-team apply \
    --filename examples/sql/$PROVIDER.yaml
```


## Explore Configurations

```bash
cat packages/sql/definition.yaml

cat packages/sql/$PROVIDER.yaml

cat packages/sql/crossplane.yaml

cat packages/sql/README.md
```


## Explore Configurations

```bash
cat crossplane-config/config-sql.yaml

# Open https://marketplace.upbound.io/configurations/devops-toolkit/dot-sql

kubectl get crds | grep devopstoolkitseries.com

kubectl explain sqlclaim --recursive
```


## Query Resources

```bash
kubectl --namespace a-team get sqlclaims

kubectl get sqls

kubectl get managed
```


## Access The Database

```bash
# If NOT Azure
kubectl --namespace a-team get secret my-db --output yaml

# If NOT Azure
kubectl --namespace a-team get secret my-db \
    --output jsonpath="{.data}"

# If NOT Azure
kubectl --namespace a-team get secret my-db \
    --output jsonpath="{.data.endpoint}" | base64 -d
```


## Delete The Database

```bash
kubectl --namespace a-team delete \
    --filename examples/sql/$PROVIDER.yaml

kubectl get managed 
```


## Install Kubernetes Config

```bash
# If AWS
export CLUSTER_TYPE=eks

# If Azure
export CLUSTER_TYPE=aks

# If Google Cloud
export CLUSTER_TYPE=gke

cat crossplane-config/config-k8s.yaml

kubectl apply --filename crossplane-config/config-k8s.yaml

kubectl get pkgrev
```


## Create A Cluster

```bash
cat examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml

kubectl --namespace a-team apply \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml
```


## Explore Configurations

```bash
cat packages/k8s/definition.yaml

cat packages/k8s/$CLUSTER_TYPE.yaml

cat packages/k8s/crossplane.yaml

cat packages/k8s/README.md
```


## Explore Configurations

```bash
kubectl get pkgrev

kubectl get crds | grep devopstoolkitseries.com

kubectl explain clusterclaim --recursive
```


## Query Resources

```bash
kubectl --namespace a-team get clusterclaims

kubectl get compositeclusters

kubectl get managed

kubectl --namespace a-team get clusterclaims

# Wait until it's `READY`
```


## Access The Cluster

```bash
kubectl --namespace a-team get secret a-team-$CLUSTER_TYPE \
    --output yaml

# If Google
KUBECONFIG=$PWD/kubeconfig.yaml gcloud container clusters \
    get-credentials a-team-gke --project $PROJECT_ID \
    --region us-east1

# If NOT Google
cat examples/k8s/get-kubeconfig-$CLUSTER_TYPE.sh

# If NOT Google
chmod +x examples/k8s/get-kubeconfig-$CLUSTER_TYPE.sh
```


## Access The Cluster

```bash
# If NOT Google
./examples/k8s/get-kubeconfig-$CLUSTER_TYPE.sh

kubectl --kubeconfig kubeconfig.yaml get namespaces

kubectl --kubeconfig kubeconfig.yaml get crds
```

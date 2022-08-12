<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Composite Resources


## Create A Database

```bash
kubectl apply --filename crossplane-config/config-sql.yaml

kubectl get pkgrev

cat examples/sql/$PROVIDER.yaml

kubectl --namespace a-team apply \
    --filename examples/sql/$PROVIDER.yaml
```


## Eplore Configurations

```bash
cat packages/sql/definition.yaml

cat packages/sql/$PROVIDER.yaml

cat packages/sql/crossplane.yaml

cat packages/sql/README.md
```


## Eplore Configurations

```bash
cat crossplane-config/config-sql.yaml

# Open https://marketplace.upbound.io/configurations/devops-toolkit/dot-sql

kubectl get crds | grep devopstoolkitseries.com

kubectl explain sql --recursive
```


## Query Resources

```bash
kubectl --namespace a-team get sqlclaims

kubectl get sqls

kubectl get managed
```


## Access The Database

```bash
kubectl --namespace a-team get secret my-db --output yaml
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

# TODO: Continue
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

cat packages/sql/$PROVIDER.yaml

cat packages/sql/crossplane.yaml

cat packages/sql/README.md
```


## Explore Configurations

```bash
kubectl get pkgrev

kubectl get crds | grep devopstoolkitseries.com

kubectl explain compositecluster --recursive
```


## Query Resources

```bash
kubectl --namespace a-team get sqlclaims

kubectl get sqls

kubectl get managed
```


## Access The Database

```bash
kubectl --namespace a-team get secret my-db --output yaml
```


## Delete The Database

```bash
kubectl --namespace a-team delete \
    --filename examples/sql/$PROVIDER.yaml

kubectl get managed 
```
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Managed Resources


## Create A Database

```bash
cat examples/sql/$PROVIDER-mrs.yaml

kubectl apply --filename examples/sql/$PROVIDER-mrs.yaml
```


## Crossplane Resource Definitions

```bash
kubectl get crd

# If AWS
kubectl explain rdsinstance --recursive

# If Google Cloud
kubectl explain cloudsqlinstance --recursive

# If AWS
# Open https://marketplace.upbound.io/providers/crossplane/provider-aws

# If Google Cloud
# Open https://marketplace.upbound.io/providers/crossplane/provider-gcp
```


## Crossplane Resource Definitions

```bash
# If AWS
# Seach for `RDSInstance`

# If Google Cloud
# Seach for `CloudSQLInstance`

kubectl get managed

# Wait until all the resources are `READY`
```


## Access The Database

```bash
kubectl --namespace crossplane-system get secret my-db-sql \
    --output yaml
```


## Drift Detection And Reconciliation

```bash
# Delete the database from the provider's console

kubectl get managed 
```


## Delete The Database

```bash
kubectl delete --filename examples/sql/$PROVIDER-mrs.yaml

kubectl get managed 
```
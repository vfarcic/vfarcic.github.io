<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Managed Resources


## Create A Database

```bash
cat examples/sql/$PROVIDER-xrs.yaml

kubectl apply --filename examples/sql/$PROVIDER-xrs.yaml
```


## Crossplane Resource Definitions

```bash
kubectl get crd

# If AWS
kubectl explain rdsinstance --recursive

# If AWS
# Open https://marketplace.upbound.io/providers/crossplane/provider-aws

# If AWS
# Seach for `RDSInstance`
```


## Query Managed Resources

```bash
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
kubectl delete --filename examples/sql/$PROVIDER-xrs.yaml

kubectl get managed 
```
## Cleanup

```bash
kubectl --namespace production delete \
    --filename crossplane-examples/

kubectl get managed

# Wait until all the resources are removed
#   (except `object` and `release`)

# Destroy or reset the cluster
```

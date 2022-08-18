## Cleanup

```bash
kubectl --namespace a-team delete \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml

kubectl get managed

# Wait until all the managed resources are deleted
#   (excluding `object` and `release`)

# If Google Cloud
gcloud projects delete $PROJECT_ID

# Destroy or reset the management cluster
```

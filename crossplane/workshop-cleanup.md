## Cleanup

```bash
# If AWS
kubectl --kubeconfig kubeconfig.yaml --namespace ingress-nginx \
    delete service a-team-eks-ingress-ingress-nginx-controller

kubectl --namespace a-team delete \
    --filename examples/k8s/$PROVIDER-$CLUSTER_TYPE.yaml

kubectl get managed

# Wait until all the managed resources are deleted

# If Google Cloud
gcloud projects delete $PROJECT_ID

# Destroy or reset the management cluster
```

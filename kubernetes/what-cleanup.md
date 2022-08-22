## Cleanup

```bash
kubectl --namespace production get secret a-team-eks \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d | tee kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml --namespace ingress-nginx \
    delete service a-team-eks-ingress-ingress-nginx-controller

kubectl --namespace production delete \
    --filename crossplane-examples/

kubectl get managed

# Wait until all the resources are removed
#   (except `object` and `release`)

# Destroy or reset the cluster
```

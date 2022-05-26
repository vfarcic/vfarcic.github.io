## Cleanup

```bash
kubectl delete --filename examples/vm/digital-ocean.yaml

kubectl --namespace crossplane-system \
    get secret a-team-eks-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d \
    | tee kubeconfig-eks.yaml

kubectl \
    --kubeconfig kubeconfig-eks.yaml \
    --namespace ingress-nginx \
    delete service a-team-eks-ingress-ingress-nginx-controller

kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks.yaml

kubectl get managed

# Wait until all the resources are removed
#   (except `object` and `release`)

# Destroy the management cluster
```

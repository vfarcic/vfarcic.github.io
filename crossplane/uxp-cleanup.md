## Cleanup

```bash
kubectl delete --filename examples/vm/digital-ocean.yaml

kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks.yaml

kubectl get managed

# Wait until all the resources are removed
#   (except `object` and `release`)

# Destroy the management cluster
```

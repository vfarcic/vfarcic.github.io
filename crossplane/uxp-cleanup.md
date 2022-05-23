<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Cleanup

```bash
kubectl delete --filename examples/vm/equinix.yaml

kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks.yaml

kubectl get managed

# Wait until all the resources are removed

# Destroy the management cluster
```

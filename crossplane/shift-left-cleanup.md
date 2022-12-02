## Cleanup

```bash
cd ../devops-toolkit-crossplane

./examples/k8s/get-kubeconfig-eks.sh

kubectl --namespace dev delete --filename examples/sql/aws.yaml

kubectl --namespace ingress-nginx delete service \
    a-team-eks-ingress-ingress-nginx-controller

kubectl get managed

# Wait until all the resources are deleted
#   (ignore `database` resource)
```


## Cleanup

```bash
unset KUBECONFIG

kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks-1-22.yaml

kubectl get managed

# Wait until all the resources are deleted
#   (ignore `release` and `object` resources)

# Destroy or reset the management cluster
```

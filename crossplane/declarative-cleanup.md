## Cleanup

```bash
kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks-official.yaml

kubectl --namespace a-team delete \
    --filename examples/vm/aws-official.yaml
```


## Cleanup

```bash
cd ../devops-catalog-code/terraform-eks/simple

terraform destroy

kubectl get managed

# Wait until all the resources are deleted
```


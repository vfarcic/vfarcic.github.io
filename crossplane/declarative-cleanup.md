## Cleanup

```bash
./examples/k8s/get-kubeconfig-eks.sh

kubectl --kubeconfig kubeconfig.yaml \
    --namespace ingress-nginx \
    delete service a-team-eks-ingress-ingress-nginx-controller

kubectl --namespace a-team delete \
    --filename examples/k8s/aws-eks.yaml

kubectl --namespace a-team delete \
    --filename examples/vm/aws.yaml

cd ../devops-catalog-code/terraform-eks/simple

terraform destroy

kubectl get managed

# Wait until all the resources are deleted
```


## Cleanup

```bash
export KUBECONFIG=$PWD/kubeconfig-2.yaml

aws eks update-kubeconfig --region us-east-1 \
    --name a-team-cluster-2 --kubeconfig $KUBECONFIG

kubectl --namespace traefik delete service traefik

unset KUBECONFIG

kubectl --namespace a-team delete --filename cluster/aws-2.yaml

kubectl --namespace a-team delete --filename db/aws-2.yaml

./destroy.sh

exit
```

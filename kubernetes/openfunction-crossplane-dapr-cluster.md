# Cluster-as-a-Service
## Kubernetes with Everything

```sh
cat cluster/aws-2.yaml
```

[dot-kubernetes](https://marketplace.upbound.io/configurations/devops-toolkit/dot-kubernetes)


## Cluster-as-a-Service

```sh
kubectl --namespace a-team apply --filename cluster/aws-2.yaml

crossplane beta trace clusterclaim cluster-2 --namespace a-team

kubectl --namespace a-team delete --filename cluster/aws-2.yaml

crossplane beta trace clusterclaim cluster --namespace a-team

export KUBECONFIG=$PWD/kubeconfig.yaml
```


## Cluster-as-a-Service

```sh
kubectl get namespaces

kubectl --namespace crossplane-system get secrets

kubectl get clustersecretstores

kubectl --namespace production \
    get externalsecrets.external-secrets.io

kubectl --namespace production get secrets
```

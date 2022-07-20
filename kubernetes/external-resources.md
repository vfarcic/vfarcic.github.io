<!-- .slide: data-background-image="../img/products/kubernetes.png" data-background-opacity="0.2" data-background-size="contain" -->
## Kubernetes

# Manage External Resources


<!-- .slide: data-background="img/what/external-resources-01.png" data-background-size="contain" -->


![](../img/products/crossplane.png)


# External Resources

```bash
cat crossplane-examples/vm.yaml

kubectl apply --filename crossplane-examples/vm.yaml
```


<!-- .slide: data-background="img/what/external-resources-02.png" data-background-size="contain" -->


# External Resources

```bash
kubectl get instances,vpcs,subnets
```


<!-- .slide: data-background="img/what/external-resources-03.png" data-background-size="contain" -->


<!-- .slide: data-background="img/what/external-resources-04.png" data-background-size="contain" -->


<!-- .slide: data-background="img/what/external-resources-05.png" data-background-size="contain" -->


# External Resources

```bash
cat crossplane-examples/postgresql.yaml

kubectl --namespace production apply \
    --filename crossplane-examples/postgresql.yaml

kubectl --namespace production get sqlclaims
```


<!-- .slide: data-background="img/what/external-resources-06.png" data-background-size="contain" -->


<!-- .slide: data-background="img/what/external-resources-07.png" data-background-size="contain" -->


# External Resources

```bash
cat crossplane-examples/aws-eks.yaml

kubectl --namespace production apply \
    --filename crossplane-examples/aws-eks.yaml

kubectl --namespace production get clusterclaims
```


<!-- .slide: data-background="img/what/external-resources-08.png" data-background-size="contain" -->


# External Resources

```bash
kubectl get managed
```
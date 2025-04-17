<!-- .slide: data-background="img/platform-engineering.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-01.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-02.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-03.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-04.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-05.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-06.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-07.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-08.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="../idp/img/idp-present-09.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/day-1.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/day-2.png" data-background-size="contain" data-background-color="black" -->


## Kubernetes

```sh
cat app/error.yaml

kubectl --namespace infra apply --filename app/error.yaml
```


## The Problem

```sh
kubectl --namespace infra get deployments

kubectl --namespace infra describe deployment silly-demo

kubectl --namespace infra get pods

kubectl --namespace infra describe pod \
    --selector app.kubernetes.io/name=silly-demo
```


## Custom Resources

```sh
cat examples/$HYPERSCALER-error.yaml

kubectl --namespace infra apply \
    --filename examples/$HYPERSCALER-error.yaml
```


## The Problem

```sh
kubectl --namespace infra get sqlclaims

kubectl --namespace infra describe sqlclaim my-db

crossplane beta trace sqlclaim my-db --namespace infra

kubectl describe $MANAGED_RESOURCE my-db
```


## The Solution

```sh
yq --inplace \
    '.spec.package = "xpkg.upbound.io/devops-toolkit/dot-sql:v0.8.138"' \
    config.yaml

kubectl apply --filename config.yaml

kubectl --namespace infra describe sqlclaim my-db

kubectl apply \
    --filename examples/provider-config-$HYPERSCALER.yaml

kubectl --namespace infra describe sqlclaim my-db
```


## The Solution

```sh
cat examples/$HYPERSCALER.yaml

kubectl --namespace infra apply \
    --filename examples/$HYPERSCALER.yaml

kubectl --namespace infra describe sqlclaim my-db

kubectl --namespace infra get sqlclaims
```


## How It's Done

```sh
cat package/compositions.yaml
```
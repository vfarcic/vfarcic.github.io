## Database-as-a-Service In Action

* Simple manifest
* Right level of abstraction
* Service provider


## Database-as-a-Service In Action

```sh
cat db/aws.yaml

kubectl --namespace a-team apply --filename db/aws.yaml

crossplane beta trace sqlclaim my-db --namespace a-team
```


## What's Going On?


<!-- .slide: data-background="img/dbaas/diag-02-00.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-01.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-02.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-03.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-04.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-05.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-06.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-07.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-08.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-09.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-10.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-11.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-12.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-13.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dbaas/diag-02-14.png" data-background-size="contain" -->


## What's Going On?

```sh
crossplane beta trace sqlclaim my-db --namespace a-team
```


## I Don't Trust You. Prove It!

```sh
kubectl --namespace a-team get secrets
```

* Show RDS in AWS console

```sh
kubectl --namespace a-team get atlasschemas

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl --namespace production get secrets

kubectl --namespace production get components.dapr.io

gh repo view vfarcic/crossplane-sql --web
```

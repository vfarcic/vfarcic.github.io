## Hands-On Time

---

# Deploys


## Gist

---

[06-deploy.sh](https://gist.github.com/677a0d688f65ceb01e31e33db59a4400) (https://goo.gl/hMDRWz)


## Creating A Cluster

---

```bash
minikube start --vm-driver=virtualbox

kubectl config current-context

cd k8s-specs

git pull
```


## Deploying New Releases

---

```bash
cat deploy/go-demo-2-db.yml

kubectl create -f deploy/go-demo-2-db.yml --record

kubectl get -f deploy/go-demo-2-db.yml

kubectl describe -f deploy/go-demo-2-db.yml

kubectl get all
```


<!-- .slide: data-background="img/seq_deploy_ch06.png" data-background-size="contain" -->


## Updating Deployments

---

```bash
kubectl set image -f deploy/go-demo-2-db.yml db=mongo:3.4 --record

kubectl describe -f deploy/go-demo-2-db.yml

kubectl get all

kubectl edit -f deploy/go-demo-2-db.yml

kubectl create -f deploy/go-demo-2-db-svc.yml --record
```


## Zero-Downtime Deployments

---

```bash
cat deploy/go-demo-2-api.yml

kubectl create -f deploy/go-demo-2-api.yml --record

kubectl get -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:2.0 --record

kubectl rollout status -w -f deploy/go-demo-2-api.yml

kubectl describe -f deploy/go-demo-2-api.yml

kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl get rs
```


<!-- .slide: data-background="img/flow_deploy_ch06.png" data-background-size="contain" -->


## Rolling Back Or Rolling Forward?

---

```bash
kubectl rollout undo -f deploy/go-demo-2-api.yml

kubectl describe -f deploy/go-demo-2-api.yml

kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:3.0 --record

kubectl rollout status -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:4.0 --record

kubectl rollout status -f deploy/go-demo-2-api.yml
```


## Rolling Back Or Rolling Forward?

---

```bash
kubectl rollout history -f deploy/go-demo-2-api.yml

kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:2.0 --record

kubectl rollout undo -f deploy/go-demo-2-api.yml --to-revision=2

kubectl rollout history -f deploy/go-demo-2-api.yml
```


## Rolling Back Failed Deployments

---

```bash
kubectl set image -f deploy/go-demo-2-api.yml \
    api=vfarcic/go-demo-2:does-not-exist --record

kubectl get rs -l type=api

kubectl rollout status -f deploy/go-demo-2-api.yml

echo $?

kubectl rollout undo -f deploy/go-demo-2-api.yml

kubectl rollout status -f deploy/go-demo-2-api.yml
```


## Rolling Back Failed Deployments

---

```bash
kubectl delete -f deploy/go-demo-2-db.yml

kubectl delete -f deploy/go-demo-2-db-svc.yml

kubectl delete -f deploy/go-demo-2-api.yml
```


## Merging Everything

---

```bash
cat deploy/go-demo-2.yml

kubectl create -f deploy/go-demo-2.yml --record --save-config

kubectl get -f deploy/go-demo-2.yml
```


## Updating Multiple Objects

---

```bash
cat deploy/different-app-db.yml

kubectl create -f deploy/different-app-db.yml

kubectl get deployments --show-labels

kubectl get deployments -l type=db,vendor=MongoLabs

kubectl set image deployments -l type=db,vendor=MongoLabs \
    db=mongo:3.4 --record

kubectl describe -f deploy/go-demo-2.yml
```


## Scaling Deployments

---

```bash
cat deploy/go-demo-2-scaled.yml

kubectl apply -f deploy/go-demo-2-scaled.yml

kubectl get -f deploy/go-demo-2-scaled.yml

kubectl scale deployment go-demo-2-api --replicas 8 --record

kubectl get -f deploy/go-demo-2.yml
```


## Deployments

---

* Zero-downtime updates<!-- .element: class="fragment" -->


## What Now?

---

```bash
minikube delete
```

* [Deployment v1beta2 apps](https://kubernetes.io/docs/api-reference/v1.8/#deployment-v1beta2-apps) (https://kubernetes.io/docs/api-reference/v1.8/#deployment-v1beta2-apps)

## Ingress coming next<!-- .element: class="fragment" -->
## Hands-On Time

---

# Deploying Releases With Zero-Downtime


## Deploying New Releases

---

```bash
cat deploy/go-demo-2.yml

kubectl create -f deploy/go-demo-2.yml --record --save-config

kubectl describe deploy go-demo-2-api

kubectl get all
```


<!-- .slide: data-background="img/deployment.png" data-background-size="contain" -->


<!-- .slide: data-background="img/seq_deploy_ch06.png" data-background-size="contain" -->


## Zero-Downtime Deployments

---

```bash
kubectl set image deploy go-demo-2-api api=vfarcic/go-demo-2:2.0 \
    --record

kubectl rollout status -w deploy go-demo-2-api

kubectl describe deploy go-demo-2-api

kubectl rollout history deploy go-demo-2-api

kubectl get rs
```


<!-- .slide: data-background="img/flow_deploy_ch06.png" data-background-size="contain" -->


## Rolling Back Or Rolling Forward?

---

```bash
kubectl rollout undo deploy go-demo-2-api

kubectl describe deploy go-demo-2-api

kubectl rollout history deploy go-demo-2-api

kubectl rollout undo -f deploy/go-demo-2-api.yml --to-revision=2

kubectl rollout history deploy go-demo-2-api
```


## Scaling Deployments

---

```bash
kubectl scale deployment go-demo-2-api --replicas 8 --record

kubectl get pods
```


## Deployments

---

* Zero-downtime updates<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/deploy-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f deploy/go-demo-2.yml
```

## Hands-On Time

---

# Scaling Pods With ReplicaSets


## Creating ReplicaSets

---

```bash
cat rs/go-demo-2.yml

kubectl create -f rs/go-demo-2.yml

kubectl get rs

kubectl describe -f rs/go-demo-2.yml

kubectl get pods
```


<!-- .slide: data-background="img/rs-two-replicas.png" data-background-size="contain" -->


<!-- .slide: data-background="img/seq_pod_ch04.png" data-background-size="contain" -->


<!-- .slide: data-background="img/rs.png" data-background-size="contain" -->


## Operating ReplicaSets

---

```bash
POD_NAME=$(kubectl get pods -o name | tail -1)

kubectl delete $POD_NAME

kubectl get pods
```


## ReplicaSets?

---

* Guarantee that replicas of a Pod are running<!-- .element: class="fragment" -->
* Rarely created independently but through Deployments<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/rs-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f rs/go-demo-2.yml
```

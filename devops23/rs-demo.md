## Hands-On Time

---

# Scaling Pods With ReplicaSets


## Creating ReplicaSets

---

```bash
cat rs/go-demo-2.yml

kubectl create -f rs/go-demo-2.yml

kubectl get rs

kubectl get -f rs/go-demo-2.yml

kubectl describe -f rs/go-demo-2.yml

kubectl get pods --show-labels
```


## Creating ReplicaSets

---

* We created a ReplicaSet
* We demonstrated tha ReplicaSet creates missing controllers


<!-- .slide: data-background="img/rs-two-replicas.png" data-background-size="contain" -->


<!-- .slide: data-background="img/seq_pod_ch04.png" data-background-size="contain" -->


<!-- .slide: data-background="img/rs.png" data-background-size="contain" -->


## Operating ReplicaSets

---

```bash
kubectl delete -f rs/go-demo-2.yml --cascade=false

kubectl get rs

kubectl get pods

kubectl create -f rs/go-demo-2.yml --save-config

kubectl get pods

cat rs/go-demo-2-scaled.yml

kubectl apply -f rs/go-demo-2-scaled.yml

kubectl get pods
```


## Operating ReplicaSets

---

* We deleted the ReplicaSet without removing Pods
* We created a new ReplicaSet and demonstrated that it reused the existing Pods
* We updated the ReplicaSet by changing the number of replicas
* We explored how the updated ReplicaSet increased the number of Pods


## Operating ReplicaSets

---

```bash
POD_NAME=$(kubectl get pods -o name | tail -1)

kubectl delete $POD_NAME

kubectl get pods
```


## Operating ReplicaSets

---

* We similated Pod failure
* We observed how ReplicaSet recreates failed Pods


## Operating ReplicaSets

---

```bash
POD_NAME=$(kubectl get pods -o name | tail -1)

kubectl label $POD_NAME service-

kubectl describe $POD_NAME

kubectl get pods --show-labels

kubectl label $POD_NAME service=go-demo-2

kubectl get pods
```


## Operating ReplicaSets

---

* We removed a matching label from one of the Pods
* We described the Pod to confirm that the label is removed
* We observed that ReplicaSet created a new Pod to satify the desired number of replicas
* We added back the label we removed
* We observed that ReplicaSet removed one of the Pods to satify the desired number of replicas


## ReplicaSets?

---

* Guarantee that replicas of a Pod are running<!-- .element: class="fragment" -->
* Rarely created independently but through Deployments<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/rs-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f rs/go-demo-2-scaled.yml
```

## Hands-On Time

---

# Creating Pods


## Quick And Dirty Way To Run Pods

---

```bash
kubectl run db --image mongo

kubectl get pods

# Wait for a while

kubectl get pods

kubectl delete deployment db
```


## Quick And Dirty Way To Run Pods

---

* We used undocumented way to create Pods (and more)


<!-- .slide: data-background="img/pod-single-container.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
cat pod/db.yml

kubectl create -f pod/db.yml

kubectl get pods

kubectl get pods -o wide

kubectl get pods -o json

kubectl get pods -o yaml

kubectl describe pod db

kubectl describe -f pod/db.yml
```


## Declarative Syntax

---

* We used documented (YAML) way to create Pods
* We explored different means to retrieve information about running Pods


<!-- .slide: data-background="img/seq_pod_ch03.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
kubectl exec db ps aux

kubectl exec -it db sh

echo 'db.stats()' | mongo localhost:27017/test

exit

kubectl logs db

kubectl exec -it db pkill mongod

kubectl get pods
```


## Declarative Syntax

---

* We executed processes inside a Pod
* We retrieved logs of a Pod
* We explored what happens when a container fails


<!-- .slide: data-background="img/pod-failed-container.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
kubectl delete -f pod/db.yml

kubectl get pods

# Wait

kubectl get pods
```


## Declarative Syntax

---

* We deleted the Pod


## Running Multiple Containers

---

```bash
cat pod/go-demo-2.yml

kubectl create -f pod/go-demo-2.yml

kubectl get -f pod/go-demo-2.yml

kubectl get -f pod/go-demo-2.yml -o json

kubectl exec -it -c db go-demo-2 ps aux

kubectl logs go-demo-2 -c db

cat pod/go-demo-2-scaled.yml

kubectl delete -f pod/go-demo-2.yml
```


## Running Multiple Containers

---

* We created a Pod with two containers
* We explored how to execute processes inside a container in a multi-container Pod
* We explored how to retrieve logs of a container in a multi-container Pod
* We explored a Pod with scaled containers and we discarded it as a good solution
* We deleted the Pod


## Monitoring Health

---

```bash
cat pod/go-demo-2-health.yml

kubectl create -f pod/go-demo-2-health.yml

kubectl describe -f pod/go-demo-2-health.yml
```


## Monitoring Health

---

* We used `livenessProbe`
* We explored the effect of a `livenessProbe` that fails


## Pods?

---

* (Almost) Useless (By Themselves)<!-- .element: class="fragment" -->
* Fundamental building block<!-- .element: class="fragment" -->
* Disposable<!-- .element: class="fragment" -->
* (Almost) never created directly<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/pod-components.png" data-background-size="contain" -->


## What Now?

```bash
kubectl delete -f pod/go-demo-2-health.yml
```

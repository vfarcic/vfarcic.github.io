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
```


<!-- .slide: data-background="img/seq_pod_ch03.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
kubectl describe -f pod/db.yml

kubectl exec db ps aux

kubectl exec -it db sh

echo 'db.stats()' | mongo localhost:27017/test

exit

kubectl logs db

kubectl exec -it db pkill mongod

kubectl get pods
```


<!-- .slide: data-background="img/pod-failed-container.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
kubectl delete -f pod/db.yml

kubectl get pods

# Wait

kubectl get pods
```


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


## Monitoring Health

---

```bash
cat pod/go-demo-2-health.yml

kubectl create -f pod/go-demo-2-health.yml

kubectl describe -f pod/go-demo-2-health.yml
```


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

## Hands-On Time

---

# Creating Pods


## Declarative Syntax

---

```bash
cat pod/db.yml

kubectl create -f pod/db.yml

kubectl get pods

kubectl describe pod db
```


<!-- .slide: data-background="img/seq_pod_ch03.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
kubectl exec db ps aux

kubectl exec -it db sh

echo 'db.stats()' | mongo localhost:27017/test

exit

kubectl logs db
```


## Declarative Syntax

---

```bash
kubectl exec -it db pkill mongod

kubectl get pods
```


<!-- .slide: data-background="img/pod-failed-container.png" data-background-size="contain" -->


## Pods?

---

* (Almost) Useless (By Themselves)<!-- .element: class="fragment" -->
* Fundamental building block<!-- .element: class="fragment" -->
* Disposable<!-- .element: class="fragment" -->
* (Almost) never created directly<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/pod-components.png" data-background-size="contain" -->


## What Now?

```bash
kubectl delete -f pod/db.yml
```

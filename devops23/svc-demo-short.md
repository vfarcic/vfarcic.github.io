## Hands-On Time

---

# Using Services To Enable Communication Between Pods


## Enabling Communication

---

```bash
cat svc/go-demo-2.yml

kubectl create -f svc/go-demo-2.yml

kubectl get -f svc/go-demo-2.yml

IP=$(minikube ip)

PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

curl -i "http://$IP:$PORT/demo/hello"
```


<!-- .slide: data-background="img/seq_svc_ch05.png" data-background-size="contain" -->


<!-- .slide: data-background="img/comp_svc_ch05.png" data-background-size="contain" -->


## Services?

---

* Communication between Pods<!-- .element: class="fragment" -->
* Communication from outside the cluster<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/svc-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f svc/go-demo-2.yml
```

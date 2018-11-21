## Hands-On Time

---

# Using Services To Enable Communication Between Pods


## Enabling Communication

---

```bash
# If minikube
cat svc/go-demo-2.yml

# If EKS or GKE
cat svc/go-demo-2-lb.yml

# If minikube
kubectl create -f svc/go-demo-2.yml

# If EKS or GKE
kubectl create -f svc/go-demo-2-lb.yml

kubectl get -f svc/go-demo-2.yml
```


## Enabling Communication

---

```bash
# If EKS
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If GKE
IP=$(minikube ip)

echo $IP
```


## Enabling Communication

---

```bash
# If minikube
PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS or GKE
PORT=8080

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

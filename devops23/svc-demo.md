## Hands-On Time

---

# Using Services To Enable Communication Between Pods


## Exposing Ports

---

```bash
cat svc/go-demo-2-rs.yml

kubectl create -f svc/go-demo-2-rs.yml

kubectl get -f svc/go-demo-2-rs.yml

# If minikube
kubectl expose rs go-demo-2 --name=go-demo-2-svc --target-port=28017 \
    --type=NodePort

# If EKS
kubectl expose rs go-demo-2 --name=go-demo-2-svc --target-port=28017 \
    --type=LoadBalancer
```


## Exposing Ports

---

* We recreated the *go-demo-2* ReplicaSet
* We exposed the port `28017` of the ReplicaSet `go-demo-2` using imperative process

---

* `NodePort` type exposes the port on all of the worker nodes of the cluster
* `LoadBalancer` acts as `NodePort`, but it also creates an external load balancer


<!-- .slide: data-background="img/seq_svc_ch05.png" data-background-size="contain" -->


<!-- .slide: data-background="img/comp_svc_ch05.png" data-background-size="contain" -->


## Exposing Ports

---

```bash
kubectl describe svc go-demo-2-svc

# If minikube
PORT=$(kubectl get svc go-demo-2-svc \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
PORT=28017

# If minikube
IP=$(minikube ip)

# If EKS
IP=$(kubectl get svc go-demo-2-svc \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
```


## Exposing Ports

---

* We described the newly created Service
* We retrieved the port and the IP/address through which we can access the new Service

---

* minikube's address is the IP of the VM
* EKS' address is the address of the ELB
* EKS opened the same port in ELB as the target port, and it forwards requests to the randomly generated NodePort


## Exposing Ports

---

```bash
open "http://$IP:$PORT"

kubectl delete svc go-demo-2-svc
```


## Exposing Ports

---

* We validated that MongoUI is accessible through the Service
* We deleted the Service


<!-- .slide: data-background="img/svc-expose-rs.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
# If minikube
cat svc/go-demo-2-svc.yml

# If EKS
cat svc/go-demo-2-svc-lb.yml

# If minikube
kubectl create -f svc/go-demo-2-svc.yml

# If EKS
kubectl create -f svc/go-demo-2-svc-lb.yml

kubectl get -f svc/go-demo-2-svc.yml
```


## Declarative Syntax

---

* We created a Service using declarative syntax (YAML)
* We retrieved the basic info about the newly created Service

---

* The difference between minikube and EKS Service is in `type` (`NodePort` or `LoadBalancer`)


## Declarative Syntax

---

```bash
# If EKS
IP=$(kubectl get svc go-demo-2 \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
PORT=30001

open "http://$IP:$PORT"
```


## Declarative Syntax

---

* We retrieved the IP/address and the port

---

* minikube's IP is the same as it was, EKS created a new ELB with a new address
* EKS opens the same port in ELB as target port, so it's left unchanged


<!-- .slide: data-background="img/svc-hard-coded-port.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
kubectl delete -f svc/go-demo-2-svc.yml

kubectl delete -f svc/go-demo-2-rs.yml
```


## Declarative Syntax

---

* We deleted the ReplicaSet and the Service


## Communication Through Services

---

```bash
cat svc/go-demo-2-db-rs.yml

kubectl create -f svc/go-demo-2-db-rs.yml

cat svc/go-demo-2-db-svc.yml

kubectl create -f svc/go-demo-2-db-svc.yml

cat svc/go-demo-2-api-rs.yml

kubectl create -f svc/go-demo-2-api-rs.yml
```


## Communication Through Services

---

* We created a ReplicaSet with a DB
* We created a Service type `ClusterIP` for the DB
* We created a ReplicaSet with the API


## Communication Through Services

---

```bash
# If minikube
cat svc/go-demo-2-api-svc.yml

# If EKS
cat svc/go-demo-2-api-svc-lb.yml

# If minikube
kubectl create -f svc/go-demo-2-api-svc.yml

# If EKS
kubectl create -f svc/go-demo-2-api-svc-lb.yml

kubectl get all
```


## Communication Through Services

---

* We created a Service for the API
* We listed all the resources we created

---

* For minikube we used Service type `NodePort`
* For EKS we used Service type `LoadBalancer`


## Communication Through Services

---

```bash
# If EKS
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
PORT=8080

curl -i "http://$IP:$PORT/demo/hello"
```


## Communication Through Services

---

* We retrieved API Service address and port
* We sent a request to the API to confirm that it is accessible

---

* EKS created a new ELB so the IP changed
* The Service in minikube exposed a new random port
* The port of the Service in EKS is the same as the target port


## Communication Through Services

---

```bash
kubectl delete -f svc/go-demo-2-db-rs.yml

kubectl delete -f svc/go-demo-2-db-svc.yml

kubectl delete -f svc/go-demo-2-api-rs.yml

kubectl delete -f svc/go-demo-2-api-svc.yml
```


## Communication Through Services

---

* We deleted all the resources we created


## Multiple Resources In YAML

---

```bash
# If minikube
cat svc/go-demo-2.yml

# If EKS
cat svc/go-demo-2-lb.yml

# If minikube
kubectl create -f svc/go-demo-2.yml

# If EKS
kubectl create -f svc/go-demo-2-lb.yml

kubectl get -f svc/go-demo-2.yml
```


## Multiple Resources In YAML

---

* We created all the resources from a single YAML file
* We retrieved the resources to confirm that all were created


## Multiple Resources In YAML

---

```bash
# If EKS
IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

curl -i "http://$IP:$PORT/demo/hello"

POD_NAME=$(kubectl get pod --no-headers \
    -o=custom-columns=NAME:.metadata.name \
    -l type=api,service=go-demo-2 | tail -1)

kubectl exec $POD_NAME env
```


## Multiple Resources In YAML

---

* We retrieved the IP and the port of the API Service
* We sent a request to confirm that the API is accessible through the Service
* We listed the environment variables in one of the Pods to display Service-specific info

---

* EKS created a new ELB so the IP changed
* The Service in minikube exposed a new random port


<!-- .slide: data-background="img/flow_svc_ch05.png" data-background-size="contain" -->


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

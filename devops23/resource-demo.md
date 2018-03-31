## Hands-On Time

---

# Managing Resources


## Gist

---

[13-resource.sh](https://gist.github.com/cc8c44e1e84446dccde3d377c131a5cd) (https://goo.gl/rcRnn8)


## Creating A Cluster

---

```bash
cd k8s-specs

git pull

minikube start --vm-driver=virtualbox

kubectl config current-context

minikube addons enable ingress

minikube addons enable heapster
```


## Memory And CPU Resources

---

```bash
cat res/go-demo-2-random.yml

kubectl create -f res/go-demo-2-random.yml --record --save-config

kubectl rollout status deployment go-demo-2-api

kubectl describe deploy go-demo-2-api

kubectl describe nodes
```


## Measuring Consumption

---

```bash
kubectl -n kube-system get pods

kubectl -n kube-system expose rc heapster \
    --name heapster-api --port 8082 --type NodePort

kubectl -n kube-system get svc heapster-api -o json

PORT=$(kubectl -n kube-system get svc heapster-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

BASE_URL="http://$(minikube ip):$PORT/api/v1/model/namespaces/default/pods"

curl "$BASE_URL"

DB_POD_NAME=$(kubectl get pods -l service=go-demo-2 -l type=db \
    -o jsonpath="{.items[0].metadata.name}")
```


## Measuring Consumption

---

```bash
curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics"

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics/memory/usage"

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics/cpu/usage_rate"
```


## Resource Discrepancies

---

```bash
cat res/go-demo-2-insuf-mem.yml

kubectl apply -f res/go-demo-2-insuf-mem.yml --record

kubectl get pods

kubectl describe pod go-demo-2-db

cat res/go-demo-2-insuf-node.yml

kubectl apply -f res/go-demo-2-insuf-node.yml --record

kubectl get pods

kubectl describe pod go-demo-2-db
```


## Resource Discrepancies

---

```bash
kubectl apply -f res/go-demo-2-random.yml --record

kubectl rollout status deployment go-demo-2-db

kubectl rollout status deployment go-demo-2-api
```


## Adjusting Resources

---

```bash
DB_POD_NAME=$(kubectl get pods -l service=go-demo-2 \
    -l type=db -o jsonpath="{.items[0].metadata.name}")

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics/memory/usage"

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics/cpu/usage_rate"

API_POD_NAME=$(kubectl get pods -l service=go-demo-2 \
    -l type=api -o jsonpath="{.items[0].metadata.name}")

curl "$BASE_URL/$API_POD_NAME/containers/api/metrics/memory/usage"

curl "$BASE_URL/$API_POD_NAME/containers/api/metrics/cpu/usage_rate"
```


## Adjusting Resources

---

```bash
cat res/go-demo-2.yml

kubectl apply -f res/go-demo-2.yml --record

kubectl rollout status deployment go-demo-2-api
```


## Quality Of Service (QoS)

---


## Guaranteed QoS 

---

* Both memory and CPU limits must be set.
* Memory and CPU requests must be set to the same values as the limits, or they can be left empty, in which case they default to the limits (we'll explore them soon).
* Pods with Guaranteed QoS assigned are the top priority and will never be killed unless they exceed their limits or are unhealthy.


## Burstable QoS

---

* Assigned to Pods that do not meet the criteria for Guaranteed QoS but have at least one container with memory or CPU requests defined.
* Guaranteed minimal (requested) memory usage.


## BestEffort QoS

---

* Pods that do not qualify as Guaranteed or Burstable.
* Consist of containers that have none of the resources defined.
* Can use any available memory they need.
* When in need of more resources, Kubernetes will start killing containers residing in the Pods with BestEffort QoS.


## Quality Of Service (QoS)

---

```bash
kubectl describe pod go-demo-2-db

cat res/go-demo-2-qos.yml

kubectl apply -f res/go-demo-2-qos.yml --record

kubectl rollout status deployment go-demo-2-db

kubectl describe pod go-demo-2-db

kubectl describe pod go-demo-2-api

kubectl delete -f res/go-demo-2-qos.yml
```


## Defaults and Limitations

---

```bash
kubectl create namespace test

cat res/limit-range.yml

kubectl -n test create -f res/limit-range.yml \
    --save-config --record

kubectl describe namespace test

cat res/go-demo-2-no-res.yml

kubectl -n test create -f res/go-demo-2-no-res.yml \
    --save-config --record

kubectl -n test rollout status deployment go-demo-2-api
```


## Defaults and Limitations

---

```bash
kubectl -n test describe pod go-demo-2-db

cat res/go-demo-2.yml

kubectl -n test apply -f res/go-demo-2.yml --record

kubectl -n test get events -w

kubectl -n test run test --image alpine --requests memory=100Mi \
    --restart Never sleep 10000

kubectl -n test run test --image alpine --requests memory=1Mi \
    --restart Never sleep 10000

kubectl delete namespace test
```


## Resource Quotas

---

```bash
cat res/dev.yml

kubectl create -f res/dev.yml --record --save-config

kubectl -n dev describe quota dev

kubectl -n dev create -f res/go-demo-2.yml --save-config --record

kubectl -n dev rollout status deployment go-demo-2-api

kubectl -n dev describe quota dev
```


## Resource Quotas

---

```bash
cat res/go-demo-2-scaled.yml

kubectl -n dev apply -f res/go-demo-2-scaled.yml --record

kubectl -n dev get events

kubectl describe namespace dev

kubectl get pods -n dev

kubectl -n dev apply -f res/go-demo-2.yml --record

kubectl -n dev rollout status deployment go-demo-2-api
```


## Resource Quotas

---

```bash
cat res/go-demo-2-mem.yml

kubectl -n dev apply -f res/go-demo-2-mem.yml --record

kubectl -n dev get events | grep mem

kubectl describe namespace dev

kubectl -n dev apply -f res/go-demo-2.yml --record

kubectl -n dev rollout status deployment go-demo-2-api

kubectl expose deployment go-demo-2-api -n dev \
    --name go-demo-2-api --port 8080 --type NodePort
```


## What Now?

---

```bash
minikube delete
```

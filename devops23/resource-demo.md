## Hands-On Time

---

# Managing Resources


## Enabling Heapster

---

```bash
# If minikube
minikube addons enable heapster

# If EKS
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml

# If EKS
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml

# If EKS
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
```


## Enabling Heapster

---

* We installed Heapster and InfluxDB


## Memory And CPU Resources

---

```bash
cat res/go-demo-2-random.yml

kubectl create -f res/go-demo-2-random.yml --record --save-config

kubectl rollout status deployment go-demo-2-api

kubectl describe deploy go-demo-2-api

kubectl describe nodes
```


## Memory And CPU Resources

---

* We installed *go-demo-2* with randomly defined resource requests and limits
* We described the nodes and observed resource utilization


## Measuring Consumption

---

```bash
kubectl -n kube-system get pods

# If minikube
kubectl -n kube-system expose rc heapster \
    --name heapster-api --port 8082 --type NodePort

# If EKS
kubectl -n kube-system expose deployment heapster \
    --name heapster-api --port 8082 --type LoadBalancer

kubectl -n kube-system get svc heapster-api -o json
```


## Measuring Consumption

---

* We exposed Heapster API and confirmed that the service was created


## Measuring Consumption

---

```bash
# If minikube
PORT=$(kubectl -n kube-system get svc heapster-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
PORT=8082

# If minikube
ADDR=$(minikube ip)

# If EKS
ADDR=$(kubectl -n kube-system get svc heapster-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

BASE_URL="http://$ADDR:$PORT/api/v1/model/namespaces/default/pods"
```


## Measuring Consumption

---

* We retrieved Heapster's address and the port
* We generated a base URL for requests to Heapster


## Measuring Consumption

---

```bash
curl "$BASE_URL"

DB_POD_NAME=$(kubectl get pods -l service=go-demo-2 -l type=db \
    -o jsonpath="{.items[0].metadata.name}")

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics"

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics/memory/usage"

curl "$BASE_URL/$DB_POD_NAME/containers/db/metrics/cpu/usage_rate"
```


## Measuring Consumption

---

* We retrieved from Heapster the Pods from the default Namespace
* We retrieved the name of the DB Pod
* We retrieved the list of the available metrics
* We retrieved DBs memory (~33MB) and CPU (~0.002) usage


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

* We updated the DB by setting insufficient memory
* We retrieved the Pods and observed that the status of the DB is `OOMKilled`
* We described DB Deployment and observed that the `Last State` is `Terminated` for `OOMKilled` reason
* We updated the DB by setting more memory than the size of VMs
* We retrieved the Pods and observed that the status of the DB is `Pending`
* We described DB Pod and observed that there are no nodes available due to insufficient memory


## Resource Discrepancies

---

```bash
kubectl apply -f res/go-demo-2-random.yml --record

kubectl rollout status deployment go-demo-2-db

kubectl rollout status deployment go-demo-2-api
```


## Resource Discrepancies

---

* We updated the application back to the definition that worked


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

* We retrieved memory and CPU usage of the DB and the API Pods


## Adjusting Resources

---

```bash
cat res/go-demo-2.yml

kubectl apply -f res/go-demo-2.yml --record

kubectl rollout status deployment go-demo-2-api
```


## Adjusting Resources

---

* We updated the definitions so that memory and CPU usage and limits reflect the actual usage


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


## Quality Of Service (QoS)

---

* We described DB Pod and observed observed that the QoS is `Burstable`
* We updated the DB to have the same values for `requests` and `limits`
* We updated the API by removing the `requests` and `limits`
* We described the DB Pod and observed that the QoS is `Guaranteed`
* We described the API Pod and observed that the QoS is `BestEffort`
* We deleted the applicaation


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

* We created the `test` Namespace with `LimitRange`
* We described the Namespace and observed the limits
* We installed the application without resources


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


## Defaults and Limitations

---

* We described the DB Pod and observed that it was assigned default limits and requests
* We updated DB by setting memory above the limit and the API by setting memory below the limit
* We observed that creating the API is forbidden because its memory is below the limit and that the DB is forbidden because its memory is above the limit
* We failed to create a new Pod because the requested memory is above the limit
* We failed to create a new Pod because the requested memory is below the limit
* We deleted the `test` Namespace


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

* We created the `dev` Namespace with `ResourceQuota`
* We installed the applicatiton
* We described the `quota` and observed `Used` and `Hard` values


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

* We updated the application by increasing the number of API replicas to `15`.
* We retrieved the events and observed that creating of some Pods was forbidden due to CPU and Pods limits
* We described the `dev` Namespace and observed that we reached the quota for CPU and Pods
* We retrieved the Pods and observed that some are missing
* We updated the application to the previous working version


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


## Resource Quotas

---

* We increased the memory of the API Pods
* We retrieved the events and observed that creation of some Pods was forbidden
* We described the `dev` Namespace and observed that we used almost all the memory quota
* We updated the application to the last known working version
* We failed to expose a `NodePort`


## What Now?

---

```bash
kubectl delete ns dev
```

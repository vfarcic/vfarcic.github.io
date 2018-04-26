## Hands-On Time

---

# Logging


## Cluster Setup
## (if not already running)

---

```bash
source cluster/kops

chmod +x kops/cluster-setup.sh

NODE_COUNT=3 NODE_SIZE=t2.medium \
    ./kops/cluster-setup.sh
```


## kubectl logs

---

```bash
kubectl create -f logs/go-demo-3.yml --save-config --record

kubectl -n go-demo-3 rollout status deployment api

DNS=$(kubectl -n go-demo-3 get ing api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

curl "http://$DNS/demo/hello"

kubectl -n go-demo-3 logs db-0 -c db

kubectl -n go-demo-3 logs -l app=api

kubectl -n go-demo-3 get pods -l app=api
```


## kubectl logs

---

```bash
POD_NAME=$(kubectl -n go-demo-3 get pods -l app=api \
    -o jsonpath="{.items[0].metadata.name}")

kubectl -n go-demo-3 logs $POD_NAME
```


## FluentD + ELK

---

```bash
open "https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch"

kubectl create -f logs/fluentd-elk.yml --save-config --record

kubectl -n kube-system get pods

KIBANA_POD_NAME=$(kubectl -n kube-system get pods \
    -l k8s-app=kibana-logging \
    -o jsonpath="{.items[0].metadata.name}")

kubectl -n kube-system logs $KIBANA_POD_NAME

DNS=$(kubectl -n kube-system get ing kibana-logging \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

open "http://$DNS"
```


## FluentD + ELK

---

* `kubernetes.namespace_name: "go-demo-3"`
* `kubernetes.namespace_name: "go-demo-3" AND kubernetes.container_name: "api"`
* `kubernetes.namespace_name: "go-demo-3" AND kubernetes.container_name: "db"`


## FluentD + ELK

---

```bash
cat logs/logger.yml

kubectl create -f logs/logger.yml

kubectl logs -f random-logger

open "http://$DNS"
```

* `kubernetes.pod_name: "random-logger"`


## What Now?

---

```bash
kubectl delete -f logs/go-demo-3.yml

kubectl delete -f logs/fluentd-elk.yml

kubectl delete -f logs/logger.yml
```

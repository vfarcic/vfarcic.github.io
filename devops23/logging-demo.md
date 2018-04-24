## Hands-On Time

---

# Logging


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

kubectl -n go-demo-3 logs sts db -c db
```


## FluentD + ELK

---

```bash
open "https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch"

kubectl create -f logs/fluentd-elk.yml --save-config --record

kubectl -n kube-system get pods

KIBANA_POD_NAME=[...]

kubectl -n kube-system logs -f $KIBANA_POD_NAME

DNS=$(kubectl -n kube-system get ing kibana-logging \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

open "http://$DNS"
```


## FluentD + ELK

---

```bash
kubectl create -f logs/logger.yml

kubectl logs -f random-logger

open "http://$DNS"
```


## What Now?

---

```bash
TODO
```

## Hands-On Time

---

# Autoscaling Deployments and StatefulSets Based On Resource Usage


## Observing Metrics Server Data

---

> Google and Microsoft already ship Metrics Server as part of their managed Kubernetes clusters (GKE and AKS). There is no need to install it, so please skip the commands that follow.

```bash
helm install stable/metrics-server --name metrics-server \
    --version 2.0.2 --namespace metrics

kubectl -n metrics rollout status deployment metrics-server
```


<!-- .slide: data-background="img/hpa-metrics-server-scheduler.png" data-background-size="contain" -->


## Observing Metrics Server Data

---

```bash
kubectl top nodes

kubectl -n kube-system top pod

kubectl top pods --all-namespaces

kubectl top pods --all-namespaces --containers
```


<!-- .slide: data-background="img/hpa-metrics-server-kubectl.png" data-background-size="contain" -->


## Observing Metrics Server Data

---

```
kubectl get --raw "/apis/metrics.k8s.io/v1beta1" | jq '.'

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods" | jq '.'
```


## Auto-Scaling Pods Based On Resource Utilization

---

```bash
cat scaling/go-demo-5-no-sidecar-mem.yml

kubectl apply -f scaling/go-demo-5-no-sidecar-mem.yml --record

kubectl -n go-demo-5 rollout status deployment api

kubectl -n go-demo-5 get pods
```


<!-- .slide: data-background="img/hpa-without.png" data-background-size="contain" -->


## Auto-Scaling Pods Based On Resource Utilization

---

```bash
cat scaling/go-demo-5-api-hpa.yml

kubectl apply -f scaling/go-demo-5-api-hpa.yml --record

kubectl -n go-demo-5 get hpa

kubectl -n go-demo-5 describe hpa api

kubectl -n go-demo-5 get pods
```


<!-- .slide: data-background="img/hpa-no-resources.png" data-background-size="contain" -->


## Auto-Scaling Pods Based On Resource Utilization

---

```bash
cat scaling/go-demo-5-db-hpa.yml

kubectl apply -f scaling/go-demo-5-db-hpa.yml --record

kubectl -n go-demo-5 get hpa

kubectl -n go-demo-5 describe hpa db

cat scaling/go-demo-5-no-hpa.yml

kubectl apply -f scaling/go-demo-5-no-hpa.yml --record

kubectl -n go-demo-5 get hpa

kubectl -n go-demo-5 get pods
```


## Auto-Scaling Pods Based On Resource Utilization

---

```bash
cat scaling/go-demo-5-api-hpa-low-mem.yml

kubectl apply -f scaling/go-demo-5-api-hpa-low-mem.yml --record

kubectl -n go-demo-5 get hpa

kubectl -n go-demo-5 describe hpa api

kubectl -n go-demo-5 get pods
```


<!-- .slide: data-background="img/hpa-scale-up.png" data-background-size="contain" -->


## Auto-Scaling Pods Based On Resource Utilization

---

```bash
kubectl apply -f scaling/go-demo-5-api-hpa.yml --record

kubectl -n go-demo-5 describe hpa api
```


## What Now?

---

```bash
# If NOT GKE or AKS
helm delete metrics-server --purge

kubectl delete ns go-demo-5
```

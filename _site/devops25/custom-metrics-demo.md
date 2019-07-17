## Hands-On Time

---

# Extending HPA With Custom Metrics


<!-- .slide: data-background="img/custom-metrics-without.png" data-background-size="contain" -->


## Exploring Prometheus Adapter

---

```bash
helm install stable/prometheus-adapter --name prometheus-adapter \
    --version v0.2.0 --namespace metrics --set image.tag=v0.3.0 \
    --set metricsRelistInterval=90s --set prometheus.port=80 \
    --set prometheus.url=http://prometheus-server.metrics.svc

kubectl -n metrics rollout status deployment prometheus-adapter

kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1" | jq "."
```


<!-- .slide: data-background="img/custom-metrics-prom-adapter.png" data-background-size="contain" -->


## Exploring Prometheus Adapter

---

```bash
GD5_ADDR=go-demo-5.$LB_IP.nip.io

helm install \
    https://github.com/vfarcic/go-demo-5/releases/download/0.0.1/go-demo-5-0.0.1.tgz \
    --name go-demo-5 --namespace go-demo-5 \
    --set ingress.host=$GD5_ADDR

kubectl -n go-demo-5 rollout status deployment go-demo-5

for i in {1..100}; do
    curl "http://$GD5_ADDR/demo/hello"
done

kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1" \
    | jq '.resources[] | select(.name 
    | contains("nginx_ingress_controller_requests"))'
```


## Exploring Prometheus Adapter

---

```bash
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1" \
    | jq '.resources[] | select(.name 
    | contains("http_server_resp_time_count"))'

kubectl -n metrics describe cm prometheus-adapter
```


## Creating HPA w/Custom Metrics

---

```bash
cat mon/prom-adapter-values-ing.yml

helm upgrade prometheus-adapter stable/prometheus-adapter \
    --version v0.2.0 --namespace metrics \
    --values mon/prom-adapter-values-ing.yml

kubectl -n metrics rollout status deployment prometheus-adapter

kubectl -n metrics describe cm prometheus-adapter

kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1" | jq "."

cat mon/go-demo-5-hpa-ing.yml

kubectl -n go-demo-5 apply -f mon/go-demo-5-hpa-ing.yml
```


## Creating HPA w/Custom Metrics

---

```bash
kubectl -n go-demo-5 describe hpa go-demo-5

for i in {1..100}; do
    curl "http://$GD5_ADDR/demo/hello"
done

kubectl -n go-demo-5 describe hpa go-demo-5

kubectl -n go-demo-5 get pods

kubectl -n go-demo-5 describe hpa go-demo-5

cat mon/prom-adapter-values-svc.yml
```


## Creating HPA w/Custom Metrics

---

```bash
helm upgrade -i prometheus-adapter stable/prometheus-adapter \
    --version v0.2.0 --namespace metrics \
    --values mon/prom-adapter-values-svc.yml

kubectl -n metrics rollout status deployment prometheus-adapter

kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1" | jq "."

kubectl get --raw \
    "/apis/custom.metrics.k8s.io/v1beta1/namespaces/go-demo-5/services/*/http_req_per_second_per_replica" \
    | jq .

cat mon/go-demo-5-hpa-svc.yml

kubectl -n go-demo-5 apply -f mon/go-demo-5-hpa-svc.yml
```


## Creating HPA w/Custom Metrics

---

```bash
kubectl -n go-demo-5 describe hpa go-demo-5

kubectl -n go-demo-5 run -it test --image=debian --restart=Never \
    --rm -- bash

apt update

apt install -y curl

for i in {1..500}; do
    curl "http://go-demo-5:8080/demo/hello"
done

exit
```


## Creating HPA w/Custom Metrics

---

```bash
kubectl -n go-demo-5 describe hpa go-demo-5

kubectl -n go-demo-5 get pods
```


## Combining Metric Server w/Custom Metrics

---

```bash
cat mon/go-demo-5-hpa.yml

kubectl -n go-demo-5 apply -f mon/go-demo-5-hpa.yml

kubectl -n go-demo-5 describe hpa go-demo-5
```


<!-- .slide: data-background="img/custom-metrics.png" data-background-size="contain" -->


## What Now?

---

```bash
helm delete go-demo-5 --purge

kubectl delete ns go-demo-5
```

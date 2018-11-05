## Hands-On Time

---

# Debugging Issues Discovered Through Metrics And Alerts


## Facing A Disaster

---

```bash
GD5_ADDR=go-demo-5.$LB_IP.nip.io

helm install --name go-demo-5 --namespace go-demo-5 \
    https://github.com/vfarcic/go-demo-5/releases/download/0.0.1/go-demo-5-0.0.1.tgz \
    --set ingress.host=$GD5_ADDR

kubectl -n go-demo-5 rollout status deployment go-demo-5

curl http://$GD5_ADDR/demo/hello

for i in {1..20}; do
    DELAY=$[ $RANDOM % 10000 ]
    curl "http://$GD5_ADDR/demo/hello?delay=$DELAY"
done

open "http://$PROM_ADDR/alerts"
```


## Facing A Disaster

---

[Prometheus expressions]
```
sum(rate(
    nginx_ingress_controller_request_duration_seconds_sum{
        ingress="go-demo-5"
    }[5m]
)) / 
sum(rate(
    nginx_ingress_controller_request_duration_seconds_count{
        ingress="go-demo-5"
    }[5m]
))
```


## Using Instrumentation

---

```bash
open "https://github.com/vfarcic/go-demo-5/blob/master/main.go"

kubectl -n metrics run -it test --image=appropriate/curl \
    --restart=Never --rm -- go-demo-5.go-demo-5:8080/metrics

open "http://$PROM_ADDR/targets"

open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
http_server_resp_time_count

http_server_resp_time_sum{
    kubernetes_name="go-demo-5"
} / 
http_server_resp_time_count{
    kubernetes_name="go-demo-5"
}
```


## Debugging Potential Issues

---

```bash
for i in {1..20}; do
    DELAY=$[ $RANDOM % 10000 ]
    curl "http://$GD5_ADDR/demo/hello?delay=$DELAY"
done

open "http://$PROM_ADDR/alerts"
```

[Prometheus expressions]
```
sum(rate(
    http_server_resp_time_bucket{
        le="0.1",
        kubernetes_name="go-demo-5"
    }[5m]
)) /
sum(rate(
    http_server_resp_time_count{
        kubernetes_name="go-demo-5"
    }[5m]
))
```


## Debugging Potential Issues

---

[Prometheus expressions]
```
sum(rate(
    http_server_resp_time_bucket{
        le="0.1",
        kubernetes_name="go-demo-5"
    }[5m]
)) 
by (method, path) / 
sum(rate(
    http_server_resp_time_count{
        kubernetes_name="go-demo-5"
    }[5m]
)) 
by (method, path)
```


## Debugging Potential Issues

---

[Prometheus expressions]
```
sum(rate(
    http_server_resp_time_bucket{
        le="0.1",
        kubernetes_name="go-demo-5"
    }[5m]
)) 
by (method, path) / 
sum(rate(
    http_server_resp_time_count{
        kubernetes_name="go-demo-5"
    }[5m]
)) 
by (method, path) < 0.99
```


## What Now?

---

```bash
helm delete go-demo-5 --purge

kubectl delete ns go-demo-5
```
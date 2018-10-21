## Hands-On Time

---

# Collecting And Querying Metrics And Sending Alerts


## Prometheus And Alertmanager

---

```bash
cat mon/prom-values-bare.yml

PROM_ADDR=mon.$LB_IP.nip.io

AM_ADDR=alertmanager.$LB_IP.nip.io

helm install stable/prometheus --name prometheus \
    --namespace metrics --version 7.1.3 \
    --set server.ingress.hosts={$PROM_ADDR} \
    --set alertmanager.ingress.hosts={$AM_ADDR} \
    -f mon/prom-values-bare.yml
```


<!-- .slide: data-background="img/prom-flow.png" data-background-size="contain" -->


## Prometheus And Alertmanager

---

```bash
kubectl -n metrics rollout status deploy prometheus-server

kubectl -n metrics describe deployment prometheus-server

kubectl -n metrics describe cm prometheus-server

open "http://$PROM_ADDR/config"

open "http://$PROM_ADDR/targets"

kubectl -n metrics get svc

kubectl -n metrics run -it test --image=appropriate/curl \
    --restart=Never --rm -- prometheus-node-exporter:9100/metrics
```


## Prometheus And Alertmanager

---

```bash
kubectl -n metrics run -it test --image=appropriate/curl \
    --restart=Never --rm \
    -- prometheus-kube-state-metrics:8080/metrics

open "http://$PROM_ADDR/alerts"

open "http://$PROM_ADDR/graph"

kubectl -n metrics run -it test --image=appropriate/curl \
    --restart=Never --rm \
    -- prometheus-kube-state-metrics:8080/metrics \
    | grep "kube_node_info"
```

[Prometheus expressions]
```
kube_node_info

count(kube_node_info)
```


## Prometheus And Alertmanager

---

```bash
diff mon/prom-values-bare.yml mon/prom-values-nodes.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-nodes.yml

open "http://$PROM_ADDR/alerts"

diff mon/prom-values-nodes.yml mon/prom-values-nodes-0.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-nodes-0.yml
```


## Prometheus And Alertmanager

---

```bash
open "http://$PROM_ADDR/alerts"

open "http://$AM_ADDR"

diff mon/prom-values-nodes-0.yml mon/prom-values-nodes-am.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-nodes-am.yml

open "http://slack.devops20toolkit.com"

open "https://devops20.slack.com/messages/CD8QJA8DS/"
```


## Which Metric Types To Use?

---

### Fundamental metrics from Google Site Reliability Engineers (SREs):

* Latency
* Traffic
* Errors
* Saturation


## Latency-Related Issues

---

```bash
GD5_ADDR=go-demo-5.$LB_IP.nip.io

helm install \
    https://github.com/vfarcic/go-demo-5/releases/download/0.0.1/go-demo-5-0.0.1.tgz \
    --name go-demo-5 --namespace go-demo-5 \
    --set ingress.host=$GD5_ADDR

kubectl -n go-demo-5 rollout status deployment go-demo-5

curl "http://$GD5_ADDR/demo/hello"

open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
nginx_ingress_controller_request_duration_seconds_bucket

sum(rate(
  nginx_ingress_controller_request_duration_seconds_count[5m]
)) 
by (ingress)
```


## Latency-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.25"
  }[5m]
)) 
by (ingress)
```


## Latency-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.25"
  }[5m]
)) 
by (ingress) / 
sum(rate(
  nginx_ingress_controller_request_duration_seconds_count[5m]
)) 
by (ingress)
```


## Latency-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.25", 
    ingress="go-demo-5"
  }[5m]
)) 
by (ingress) / 
sum(rate(
  nginx_ingress_controller_request_duration_seconds_count{
    ingress="go-demo-5"
  }[5m]
)) 
by (ingress)
```


## Latency-Related Issues

---

```bash
for i in {1..30}; do
  DELAY=$[ $RANDOM % 1000 ]
  curl "http://$GD5_ADDR/demo/hello?delay=$DELAY"
done
```

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.25", 
    ingress="go-demo-5"
  }[5m]
)) 
by (ingress) / 
sum(rate(
  nginx_ingress_controller_request_duration_seconds_count{
    ingress="go-demo-5"
  }[5m]
)) 
by (ingress)
```


## Latency-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.25"
  }[5m]
)) 
by (ingress) / 
sum(rate(
  nginx_ingress_controller_request_duration_seconds_count[5m]
)) 
by (ingress) < 0.95
```


## Latency-Related Issues

---

```bash
diff mon/prom-values-nodes-am.yml mon/prom-values-latency.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-latency.yml

open "http://$PROM_ADDR/alerts"

for i in {1..30}; do
  DELAY=$[ $RANDOM % 10000 ]
  curl "http://$GD5_ADDR/demo/hello?delay=$DELAY"
done

open "http://$PROM_ADDR/alerts"
```


## Latency-Related Issues

---

```bash
open "https://devops20.slack.com/messages/CD8QJA8DS/"

open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.25", 
    ingress!~"prometheus-server|jenkins"
  }[5m]
)) 
by (ingress) / 
sum(rate(
  nginx_ingress_controller_request_duration_seconds_count{
    ingress!~"prometheus-server|jenkins"
  }[5m]
)) 
by (ingress)
```


## Latency-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_request_duration_seconds_bucket{
    le="0.5", 
    ingress=~"prometheus-server|jenkins"
  }[5m]
)) 
by (ingress) / 
sum(rate(
  nginx_ingress_controller_request_duration_seconds_count{
    ingress=~"prometheus-server|jenkins"
  }[5m]
)) 
by (ingress)
```


## Traffic-Related Issues

---

```bash
for i in {1..100}; do
    curl "http://$GD5_ADDR/demo/hello"
done

open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_requests[5m]
)) 
by (ingress)

kube_deployment_status_replicas

label_join(
  kube_deployment_status_replicas, 
  "ingress", 
  ",", 
  "deployment"
)
```


## Traffic-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_requests[5m]
)) 
by (ingress) / 
sum(label_join(
  kube_deployment_status_replicas, 
  "ingress", 
  ",", 
  "deployment"
)) 
by (ingress)
```

```bash
diff mon/prom-values-latency.yml mon/prom-values-latency2.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-latency2.yml

open "http://$PROM_ADDR/alerts"
```


## Traffic-Related Issues

---

```bash
for i in {1..200}; do
    curl "http://$GD5_ADDR/demo/hello"
done

open "http://$PROM_ADDR/alerts"

open "https://devops20.slack.com/messages/CD8QJA8DS/"
```


## Error-Related Issues

---

```bash
for i in {1..100}; do
    curl "http://$GD5_ADDR/demo/hello"
done

open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
nginx_ingress_controller_requests
```

```bash
for i in {1..100}; do
  curl "http://$GD5_ADDR/demo/random-error"
done

open "http://$PROM_ADDR/graph"
```


## Error-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  nginx_ingress_controller_requests{
    status=~"5.."
  }[5m]
))
by (ingress) /
sum(rate(
  nginx_ingress_controller_requests[5m]
))
by (ingress)
```

```bash
diff mon/prom-values-cpu-memory.yml mon/prom-values-errors.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-errors.yml
```


## Saturation-Related Issues

---

```bash
open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
sum(rate(
  node_cpu_seconds_total{
    mode!="idle", 
    mode!="iowait", 
    mode!~"^(?:guest.*)$"
  }[5m]
)) 
by (instance)

count(
  node_cpu_seconds_total{
    mode="system"
  }
)
```


## Saturation-Related Issues

---

[Prometheus expressions]
```
sum(rate(
  node_cpu_seconds_total{
    mode!="idle", 
    mode!="iowait", 
    mode!~"^(?:guest.*)$"
  }[5m]
)) / 
count(
  node_cpu_seconds_total{
    mode="system"
  }
)

kube_node_status_allocatable_cpu_cores
```


## Saturation-Related Issues

---

[Prometheus expressions]
```
sum(
  kube_node_status_allocatable_cpu_cores
)

kube_pod_container_resource_requests_cpu_cores

sum(
  kube_pod_container_resource_requests_cpu_cores
)

sum(
  kube_pod_container_resource_requests_cpu_cores
) / 
sum(
  kube_node_status_allocatable_cpu_cores
)
```

```bash
diff mon/prom-values-latency2.yml mon/prom-values-cpu.yml
```


## Saturation-Related Issues

---

```bash
helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-cpu.yml

open "http://$PROM_ADDR/alerts"

open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
node_memory_MemTotal_bytes

node_memory_MemAvailable_bytes

1 - 
sum(
  node_memory_MemAvailable_bytes
) / 
sum(
  node_memory_MemTotal_bytes
)
```


## Saturation-Related Issues

---

[Prometheus expressions]
```
kube_node_status_allocatable_memory_bytes

kube_pod_container_resource_requests_memory_bytes

sum(
  kube_pod_container_resource_requests_memory_bytes
)

sum(
  kube_pod_container_resource_requests_memory_bytes
) / 
sum(
  kube_node_status_allocatable_memory_bytes
)
```

```bash
diff mon/prom-values-cpu.yml mon/prom-values-memory.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-memory.yml
```


## Saturation-Related Issues

---

```bash
open "http://$PROM_ADDR/alerts"
```

[Prometheus expressions]
```
sum(rate(
  node_cpu_seconds_total{
    mode!="idle", 
    mode!="iowait", 
    mode!~"^(?:guest.*)$"
  }[5m]
)) 
by (instance) / 
count(
  node_cpu_seconds_total{
    mode="system"
  }
) 
by (instance)
```


## Saturation-Related Issues

---

[Prometheus expressions]
```
1 - 
sum(
  node_memory_MemAvailable_bytes
) 
by (instance) / 
sum(
  node_memory_MemTotal_bytes
) 
by (instance)
```

```bash
diff mon/prom-values-memory.yml mon/prom-values-cpu-memory.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-cpu-memory.yml

open "http://$PROM_ADDR/alerts"
```


## Unschedulable Or Failed Pods

---

```bash
open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
kube_pod_status_phase

sum(
  kube_pod_status_phase
) 
by (phase)

sum(
  kube_pod_status_phase{
    phase=~"Failed|Unknown|Pending"
  }
) 
by (phase)
```

```bash
kubectl run problem --image i-do-not-exist --restart=Never

kubectl get pods
```


## Unschedulable Or Failed Pods

---

```bash
kubectl describe pod problem

diff mon/prom-values-errors.yml mon/prom-values-phase.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-phase.yml

open "https://devops20.slack.com/messages/CD8QJA8DS/"

kubectl delete pod problem
```


## Upgrading Old Pods

---

```bash
open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
kube_pod_start_time

time()

time() - 
kube_pod_start_time

(
  time() - 
  kube_pod_start_time{
    namespace!="kube-system"
  }
) > 60
```


## Upgrading Old Pods

---

[Prometheus expressions]
```
(
  time() - 
  kube_pod_start_time{
    namespace!="kube-system"
  }
) > 
(60 * 60 * 24 * 90)
```

```bash
diff mon/prom-values-phase.yml mon/prom-values-old-pods.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-old-pods.yml

open "https://devops20.slack.com/messages/CD8QJA8DS/"
```


## Containers Mem And CPU Usage

---

```bash
open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
container_memory_usage_bytes

container_memory_usage_bytes{
  container_name!=""
}

container_memory_usage_bytes{
  container_name="prometheus-server"
}

sum(rate(
  container_cpu_usage_seconds_total{
    container_name="prometheus-server"
  }[5m]
)) 
by (pod_name)
```


## Resource Usage Vs Requests

---

```bash
open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
kube_pod_container_resource_requests_memory_bytes{
  container="prometheus-server"
}

sum(label_join(
  container_memory_usage_bytes{
    container_name="prometheus-server"
  }, 
  "pod", 
  ",", 
  "pod_name"
)) 
by (pod)
```


## Resource Usage Vs Requests

---

[Prometheus expressions]
```
sum(label_join(
  container_memory_usage_bytes{
    container_name="prometheus-server"
  }, 
  "pod", 
  ",", 
  "pod_name"
)) 
by (pod) / 
sum(
  kube_pod_container_resource_requests_memory_bytes{
    container="prometheus-server"
  }
) 
by (pod)
```


## Resource Usage Vs Requests

---

[Prometheus expressions]
```
sum(label_join(
  container_memory_usage_bytes{
    namespace!="kube-system"
  }, 
  "pod", 
  ",", 
  "pod_name"
)) 
by (pod) / 
sum(
  kube_pod_container_resource_requests_memory_bytes{
    namespace!="kube-system"
  }
) 
by (pod)
```


## Resource Usage Vs Requests

---

```bash
diff mon/prom-values-old-pods.yml mon/prom-values-req-mem.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-req-mem.yml

diff mon/prom-values-req-mem.yml mon/prom-values-req-cpu.yml

helm upgrade -i prometheus stable/prometheus --namespace metrics \
  --version 7.1.3 --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-req-cpu.yml
```


## Resource Usage Vs Limits

---

```bash
open "http://$PROM_ADDR/graph"
```

[Prometheus expressions]
```
sum(label_join(
  container_memory_usage_bytes{
    namespace!="kube-system"
  }, 
  "pod", 
  ",", 
  "pod_name"
)) 
by (pod) / 
sum(
  kube_pod_container_resource_limits_memory_bytes{
    namespace!="kube-system"
  }
) 
by (pod)
```


## Resource Usage Vs Limits

---

```bash
diff mon/prom-values-req-cpu.yml \
    mon/prom-values-limit-mem.yml

helm upgrade -i prometheus \
  stable/prometheus \
  --namespace metrics \
  --version 7.1.3 \
  --set server.ingress.hosts={$PROM_ADDR} \
  --set alertmanager.ingress.hosts={$AM_ADDR} \
  -f mon/prom-values-limit-mem.yml

open "http://$PROM_ADDR/alerts"
```


## What Now?

---

```bash
helm delete go-demo-5 --purge

kubectl delete ns go-demo-5
```

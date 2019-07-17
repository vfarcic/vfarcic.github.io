## Hands-On Time

---

## Expose metrics from hardware, containers, and the proxy

## Execute ad-hoc queries and create dashboards


## Metrics Stack

---

```bash
curl -o metrics.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/metrics/prometheus-grafana-df-proxy.yml

docker network create -d overlay logging_default

USER=admin PASS=admin docker stack deploy -c metrics.yml metrics

docker stack ps metrics
```


## Prometheus

---

```bash
exit

open "http://$CLUSTER_DNS:9091"

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name!=""}
```


## Grafana

---

```bash
open "http://$CLUSTER_DNS/grafana/"
```

* User/pass admin/admin
* DS: http://metrics_prometheus:9090
* [https://grafana.net/dashboards/704](https://grafana.net/dashboards/704)


## Going Back

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP
```
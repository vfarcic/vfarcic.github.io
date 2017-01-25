## Hands-On Time

---

## Expose metrics from hardware, containers, and the proxy

## Execute ad-hoc queries and create dashboards


# Metrics Stack

---

```bash
ssh -i devops21.pem ubuntu@$(terraform \
  output swarm_manager_1_public_ip)

curl -o metrics.yml https://raw.githubusercontent.com/vfarcic/\
docker-flow-stacks/master/metrics/prometheus-grafana-df-proxy.yml

docker stack deploy -c metrics.yml metrics

docker stack ps metrics
```


# Node Exporter

---

```bash
docker service create --name util2 \
  --network metrics_default \
  --mode global alpine sleep 1000000000

UTIL_ID=$(docker ps -q -f label=com.docker.swarm.service.name=util2)

docker exec -it $UTIL_ID apk add --update curl

docker exec -it $UTIL_ID \
    curl "http://metrics_node-exporter:9100/metrics"
```


# Container Exporter

---

```bash
docker exec -it $UTIL_ID curl http://metrics_cadvisor:8080/metrics
```


# Prometheus

---

```bash
exit

open "http://$(terraform output swarm_manager_1_public_ip):9091"
```

* irate(node_cpu{mode="idle"}[5m])
* container_memory_usage_bytes{id!="/"}
* container_memory_usage_bytes{container_label_com_docker_swarm_service_name="metrics_cadvisor"}


# Grafana

---

```bash
open "http://$(terraform output swarm_manager_1_public_ip):3000"
```

* User/pass admin/admin
* DS: http://metrics_prometheus:9090
* DS: http://logging_elasticsearch:9200
* [https://grafana.net/dashboards/704](https://grafana.net/dashboards/704)
* [https://grafana.net/dashboards/405](https://grafana.net/dashboards/405)
* [https://grafana.net/dashboards/609](https://grafana.net/dashboards/609)

## Hands-On Time

---

# Monitoring


# Prometheus

---

```bash
curl -o prometheus.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/prometheus.yml

cat prometheus.yml

docker stack deploy -c prometheus.yml monitor

exit

open "http://$CLUSTER_DNS:9090"

open "http://$CLUSTER_DNS:9090/config"

ssh -i workshop.pem docker@$CLUSTER_IP
```


<!-- .slide: data-background="img/prometheus-config-image.png" data-background-size="contain" -->


<!-- .slide: data-background="img/prometheus-config-direct.png" data-background-size="contain" -->


<!-- .slide: data-background="img/prometheus-config-network-drive.png" data-background-size="contain" -->


<!-- .slide: data-background="img/dfm-env-vars.png" data-background-size="contain" -->


# DF Monitor

---

```bash
curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-proxy.yml

cat monitor.yml

docker stack rm monitor

docker network create -d overlay monitor

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor
```


# DF Monitor

---

```bash
exit

open "http://$CLUSTER_DNS/monitor/config"

open "http://$CLUSTER_DNS/monitor/flags"

ssh -i workshop.pem docker@$CLUSTER_IP
```


# Exporters

---

```bash
curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters.yml

cat exporters.yml

docker stack deploy -c exporters.yml exporter

exit

open "http://$CLUSTER_DNS/monitor/config"

open "http://$CLUSTER_DNS/monitor/targets"

ssh -i workshop.pem docker@$CLUSTER_IP
```


<!-- .slide: data-background="img/exporters-diag.png" data-background-size="contain" -->


# Exploring Metrics

---

```bash
docker service create --name util --network monitor --mode global \
    alpine sleep 100000000

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID apk add --update curl

docker container exec -it $ID curl node-exporter:9100/metrics

docker container exec -it $ID curl cadvisor:8080/metrics
```


# Querying Metrics

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/graph"

# Execute `haproxy_backend_connections_total`

for ((n=0;n<200;n++)); do
    curl "http://$CLUSTER_DNS/demo/hello"
done
```


# Querying Metrics

---

```bash
# Execute `haproxy_backend_connections_total`

# Execute `container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}`

# Execute `sum by (instance) (node_memory_MemFree)`

# Execute `container_memory_usage_bytes{container_label_com_docker_stack_namespace="exporter"}`

ssh -i workshop.pem docker@$CLUSTER_IP
```


# Service Constraints

---

```bash
curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-mem.yml

cat exporters.yml

docker stack deploy -c exporters.yml exporter

# Execute `container_memory_usage_bytes{container_label_com_docker_stack_namespace="go-demo"}`

curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-mem.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo
```


# Service Constraints

---

```bash
curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-mem.yml

cat monitor.yml

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor

curl -o proxy.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-proxy-mem.yml

cat proxy.yml

docker stack deploy -c proxy.yml proxy
```


# Using Memory Reservations and Limits in Prometheus

---

```bash
# Execute `container_spec_memory_limit_bytes{container_label_com_docker_stack_namespace!=""}`

# Execute `container_memory_usage_bytes{container_label_com_docker_stack_namespace!=""} / container_spec_memory_limit_bytes{container_label_com_docker_stack_namespace!=""} * 100`
```
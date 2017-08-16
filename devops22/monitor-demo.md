## Hands-On Time

---

# Monitoring


# DF Monitor

---

```bash
cat stacks/docker-flow-monitor-proxy.yml

docker network create -d overlay monitor

DOMAIN=$(docker-machine ip swarm-1) GLOBAL_SCRAPE_INTERVAL=1s \
    docker stack deploy -c stacks/docker-flow-monitor-proxy.yml \
    monitor

docker stack ps monitor

open "http://$(docker-machine ip swarm-1)/monitor"
```


# Exporters

---

```bash
cat stacks/exporters-mem.yml

docker stack deploy -c stacks/exporters-mem.yml exporter

docker stack ps exporter

open "http://$(docker-machine ip swarm-1)/monitor/config"

open "http://$(docker-machine ip swarm-1)/monitor/targets"
```


# Metrics

---

```bash
docker service create --name util --network monitor \
    --mode global alpine sleep 100000000

ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=util")

docker container exec -it $ID apk add --update curl

docker container exec -it $ID curl node-exporter:9100/metrics

docker container exec -it $ID curl cadvisor:8080/metrics
```


## Querying Metrics

---

```bash
open "http://$(docker-machine ip swarm-1)/monitor/graph"

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name!=""}

docker stack deploy -c stacks/go-demo.yml go-demo

docker stack ps -f desired-state=running go-demo

open "http://$(docker-machine ip swarm-1)/monitor/graph"

# sum by (instance) (node_memory_MemFree)
```


## Defining Service Resources

---

```bash
cat stacks/go-demo.yml

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}

cat stacks/go-demo-mem.yml

docker stack deploy -c stacks/go-demo-mem.yml go-demo
```

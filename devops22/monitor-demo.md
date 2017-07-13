## Hands-On Time

---

# Monitoring


# DF Monitor

---

```bash
cat stacks/docker-flow-monitor-proxy.yml

docker network create -d overlay monitor

DOMAIN=$(docker-machine ip swarm-1) GLOBAL_SCRAPE_INTERVAL=1s \
    docker stack deploy -c stacks/docker-flow-monitor-proxy.yml monitor

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

open "http://$(docker-machine ip swarm-1)/monitor/graph"

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name!=""}
```

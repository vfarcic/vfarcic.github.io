## Hands-On Time

---

# Monitoring


# DF Monitor

---

```bash
curl -o monitor.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/docker-flow-monitor-mem.yml

cat monitor.yml

docker network create -d overlay monitor

source creds

DOMAIN=$CLUSTER_DNS docker stack deploy -c monitor.yml monitor
```


# Exporters

---

```bash
curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-aws.yml

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

docker container exec -it $ID curl cadvisor:8080/metrics
```


# Querying Metrics

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-instrument-alert-short-2.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

for ((n=0;n<200;n++)); do
    curl "http://$CLUSTER_DNS/demo/hello"
done

open "http://$CLUSTER_DNS/monitor/graph"
```


# Querying Metrics

---

```bash
# Execute `container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}`

# Execute `container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}`

# Execute `container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} / container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} * 100`

ssh -i workshop.pem docker@$CLUSTER_IP
```

## Hands-On Time

---

# Alerting


## Creating Alerts

---

```bash
docker service update --label-add com.df.alertName=mem \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} > 20000000' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/config"

open "http://$CLUSTER_DNS/monitor/rules"

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/monitor/graph"

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}
```


## Creating Alerts

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service update --label-add com.df.alertName=mem \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} > 1000000' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"
```


<!-- .slide: data-background="img/alerts-fire-diag.png" data-background-size="contain" -->


## Creating Alerts

---

```bash
open "http://$CLUSTER_DNS/monitor/graph"

# container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}

ssh -i workshop.pem docker@$CLUSTER_IP

docker service update --label-add com.df.alertName=mem_limit \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo"}/container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo"} > 0.8' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"
```


## Creating Multiple Alerts

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP

docker service update \
    --label-add com.df.alertName.1=mem_load \
    --label-add com.df.alertIf.1='(sum by (instance) (node_memory_MemTotal) - sum by (instance) (node_memory_MemFree + node_memory_Buffers + node_memory_Cached)) / sum by (instance) (node_memory_MemTotal) > 0.8' \
    --label-add com.df.alertName.2=diskload \
    --label-add com.df.alertIf.2='(node_filesystem_size{fstype="aufs"} - node_filesystem_free{fstype="aufs"}) / node_filesystem_size{fstype="aufs"} > 0.8' \
    exporter_node-exporter

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```


<!-- .slide: data-background="img/alerts-exporters-fire-diag.png" data-background-size="contain" -->


## Postponing Alerts Firing

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert-long.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Postponing Alerts Firing

---

```bash
docker service update \
    --label-add com.df.alertIf='container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo_main"}/container_spec_memory_limit_bytes{container_label_com_docker_swarm_service_name="go-demo_main"} > 0.05' \
    go-demo_main

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Alert Labels And Annotations

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert-info.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```


## Using Shortcuts

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo

curl -o exporters.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/exporters-alert.yml

cat exporters.yml

docker stack deploy -c exporters.yml exporter
```


## Using Shortcuts

---

```bash
exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```
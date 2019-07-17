## Hands-On Time

---

## Expose metrics from hardware, containers, and the proxy

## Execute ad-hoc queries and create dashboards


## Metrics Stack

---

```bash
source creds

curl -o metrics.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-stacks/master/metrics/docker-flow-monitor-full.yml

cat metrics.yml

docker network create -d overlay monitor
```


## Metrics Stack

---

```bash
echo "route:
  repeat_interval: 30m
  group_interval: 30m
  receiver: 'slack'

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '[{{ .Status | toUpper }}] {{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$CLUSTER_DNS/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
" | docker secret create alert_manager_config -
```


## Metrics Stack

---

```bash
DOMAIN=$CLUSTER_DNS docker stack deploy -c metrics.yml metrics

docker stack ps -f desired-state=running metrics
```


## Node Exporter

---

```bash
docker service create --name util2 \
  --network monitor --mode global alpine sleep 1000000000

UTIL_ID=$(docker ps -q -f label=com.docker.swarm.service.name=util2)

docker exec -it $UTIL_ID apk add --update curl

docker exec -it $UTIL_ID \
    curl "http://metrics_node-exporter:9100/metrics"
```


## Container Exporter

---

```bash
docker exec -it $UTIL_ID curl http://metrics_cadvisor:8080/metrics
```


## Prometheus

---

```bash
exit

open "http://$CLUSTER_DNS/monitor"

# irate(node_cpu{mode="idle"}[5m])

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name!=""}

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="metrics_cadvisor"}

# container_memory_usage_bytes{container_label_com_docker_swarm_service_name="go-demo-2_main"}
```


## Grafana

---

```bash
open "http://$CLUSTER_DNS/grafana/"
```

* User/pass admin/admin
* DS: http://metrics_monitor:9090/monitor
* DS: http://logging_elasticsearch:9200
* [https://grafana.net/dashboards/704](https://grafana.net/dashboards/704)
* [https://grafana.net/dashboards/405](https://grafana.net/dashboards/405)
* [https://grafana.net/dashboards/609](https://grafana.net/dashboards/609)


## Alerts

---

```bash
open "http://$CLUSTER_DNS/monitor/alerts"
```


## Going Back

---

```bash
ssh -i workshop.pem docker@$CLUSTER_IP
```
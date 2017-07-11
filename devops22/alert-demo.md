## Hands-On Time

---

# Alerting


# Prometheus

---

```bash
cat stacks/exporters-alert.yml

docker stack deploy -c stacks/exporters-alert.yml exporter

open "http://$(docker-machine ip swarm-1)/monitor/rules"

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

docker service update \
    --label-add "com.df.alertIf.1=@node_mem_limit:0.01" \
    exporter_node-exporter

open "http://$(docker-machine ip swarm-1)/monitor/alerts"
```


# Prometheus

---

```bash
docker service update \
    --label-add "com.df.alertIf.1=@node_mem_limit:0.8" \
    exporter_node-exporter

open "http://$(docker-machine ip swarm-1)/monitor/alerts"
```


# Prometheus

---

```bash
cat stacks/go-demo-scale.yml

docker stack deploy -c stacks/go-demo-scale.yml go-demo

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

docker service update \
    --label-add "com.df.alertIf=@service_mem_limit:0.01" \
    go-demo_main

open "http://$(docker-machine ip swarm-1)/monitor/alerts"
```


# Prometheus

---

```bash
docker service update \
    --label-add "com.df.alertIf=@service_mem_limit:0.8" \
    go-demo_main

open "http://$(docker-machine ip swarm-1)/monitor/alerts"
```


# Alertmanager

---

```bash
cat stacks/docker-flow-monitor-slack.yml

echo "route:
  group_by: [service]
  receiver: 'slack'
  repeat_interval: 1h

receivers:
  - name: 'slack'
    slack_configs:
      - send_resolved: true
        title: '{{ .GroupLabels.service }} service is in danger!'
        title_link: 'http://$(docker-machine ip swarm-1)/monitor/alerts'
        text: '{{ .CommonAnnotations.summary}}'
        api_url: 'https://hooks.slack.com/services/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'
" | docker secret create alert_manager_config -
```


# Alertmanager

---

```bash
DOMAIN=$(docker-machine ip swarm-1) docker stack deploy \
    -c stacks/docker-flow-monitor-slack.yml monitor

open "http://$(docker-machine ip swarm-1)/monitor/flags"

docker stack ps monitor

docker service update \
    --label-add "com.df.alertIf=@service_mem_limit:0.01" \
    go-demo_main

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

docker service update \
    --label-add "com.df.alertIf=@service_mem_limit:0.8" \
    go-demo_main
```
## Hands-On Time

---

# Instrumenting Services


## Histograms And Summaries

---

```bash
open "https://github.com/vfarcic/go-demo/blob/master/main.go"

cat stacks/go-demo-instrument-alert-short.yml

docker stack deploy \
    -c stacks/go-demo-instrument-alert-short.yml go-demo

open "http://$(docker-machine ip swarm-1)/monitor/alerts"

docker stack ps -f desired-state=running go-demo

open "http://$(docker-machine ip swarm-1)/monitor/targets"

open "http://$(docker-machine ip swarm-1)/monitor/graph"

# sum(rate(http_server_resp_time_bucket{job="go-demo_main",le="0.1"}[5m])) / sum(rate(http_server_resp_time_count{job="go-demo_main"}[5m]))
```

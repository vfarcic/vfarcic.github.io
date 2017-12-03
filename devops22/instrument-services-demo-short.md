## Hands-On Time

---

# Instrumenting Services


## Histograms

---

```bash
exit

open "https://goo.gl/jc6aUx"

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/monitor/graph"

# sum(rate(http_server_resp_time_bucket{job="go-demo_main",le="0.1"}[5m])) / sum(rate(http_server_resp_time_count{job="go-demo_main"}[5m]))

ssh -i workshop.pem docker@$CLUSTER_IP
```

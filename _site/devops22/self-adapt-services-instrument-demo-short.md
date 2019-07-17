## Hands-On Time

---

# Self-Adapting Instrumented Services


## Querying Response Time

---

```bash
open "http://$CLUSTER_DNS/monitor/graph"

# http_server_resp_time_sum / http_server_resp_time_count

for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
done

# rate(http_server_resp_time_sum[5m]) / rate(http_server_resp_time_count[5m])

# sum(rate(http_server_resp_time_sum[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

# sum(rate(http_server_resp_time_bucket{le="0.1"}[5m])) by (job) / sum(rate(http_server_resp_time_count[5m])) by (job)

# sum(rate(http_server_resp_time_bucket{job="go-demo_main",le="0.1"}[5m])) / sum(rate(http_server_resp_time_count{job="go-demo_main"}[5m]))
```


## Scaling Up

---

```bash
for i in {1..30}; do
    DELAY=$[ $RANDOM % 6000 ]
    curl "http://$CLUSTER_DNS/demo/hello?delay=$DELAY"
done

open "http://$CLUSTER_DNS/monitor/alerts"

open "http://$CLUSTER_DNS/jenkins/blue/organizations/jenkins/service-scale/activity"

ssh -i workshop.pem docker@$CLUSTER_IP

source creds

docker stack ps -f desired-state=running go-demo
```

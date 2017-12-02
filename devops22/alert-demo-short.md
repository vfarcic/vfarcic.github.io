## Hands-On Time

---

# Alerting


## Creating Alerts

---

```bash
curl -o go-demo.yml \
    https://raw.githubusercontent.com/vfarcic/docker-flow-monitor/master/stacks/go-demo-alert.yml

cat go-demo.yml

docker stack deploy -c go-demo.yml go-demo
```


## Creating Alerts

---

```bash
exit

open "http://$CLUSTER_DNS/monitor/alerts"

ssh -i workshop.pem docker@$CLUSTER_IP
```


<!-- .slide: data-background="img/alerts-exporters-fire-diag.png" data-background-size="contain" -->

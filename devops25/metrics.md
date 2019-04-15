<!-- .slide: data-background="../img/background/why.jpg" -->
# A long time ago in a galaxy far, far away...

---


<!-- .slide: data-background="../img/background/servers.jpg" -->
## You thought that
# `top` is great

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You used
# Graphite, Nagios, Sensu,
## or similar tools

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You learned that
# uni-dimensional data
## is useless

---


<!-- .slide: data-background="../img/products/prometheus.png" -->
## You adopted
# Prometheus
## And
# Grafana

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You learned that
# Netflix is better
## than dashboard

---


<!-- .slide: data-background="../img/products/prometheus.png" -->
## You discovered
# Alertmanager

---

```
sum(rate(nginx_ingress_controller_requests{status=~"5.."}[5m]))
by (ingress) /
sum(rate(nginx_ingress_controller_requests[5m]))
by (ingress)
> 0.05
```


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You learned that you are the major generator of
# spam emails

---
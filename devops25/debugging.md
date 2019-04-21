```bash
GD5_ADDR=go-demo-5.$LB_IP.nip.io

helm install \
	https://github.com/vfarcic/go-demo-5/releases/download/0.0.1/go-demo-5-0.0.1.tgz \
    --name go-demo-5 --namespace go-demo-5 \
	--set ingress.host=$GD5_ADDR --wait

for i in {1..1000}; do
    DELAY=$[ $RANDOM % 10000 ]
    curl "http://$GD5_ADDR/demo/hello?delay=$DELAY"
done
```


<!-- .slide: data-background="../img/background/why.jpg" -->
# A long time ago in a galaxy far, far away...

---


<!-- .slide: data-background="../img/background/source-code.jpeg" -->
## You were guessing what was causing
# issues in production

---


<!-- .slide: data-background="../img/background/source-code.jpeg" -->
## You were debugging applications
# in production

---


<!-- .slide: data-background="../img/background/logs.jpeg" -->
## You thought that
# logs
## will tell you when something goes wrong

---


<!-- .slide: data-background="../img/background/metrics.jpg" -->
## You thought that
# generic metrics
## will tell you when something goes wrong

---


<!-- .slide: data-background="../img/products/prometheus.png" -->
## You started
# instrumenting
## your applications

---

```bash
open "https://github.com/vfarcic/go-demo-5/blob/master/main.go#L155"
```


<!-- .slide: data-background="../img/products/prometheus.png" -->
## ... and creating
# alerts

---

```bash
open "http://$PROM_ADDR/graph"
```

```
sum(rate(http_server_resp_time_bucket{le="0.1",
	kubernetes_name="go-demo-5"}[5m])) by (method, path) 
/ sum(rate(http_server_resp_time_count{
	kubernetes_name="go-demo-5"}[5m])) by (method, path)
< 0.99
```


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You learned that you continue being the major generator of
# spam emails

---
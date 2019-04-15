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

```
func recordMetrics(start time.Time, req *http.Request, code int) {
	duration := time.Since(start)
	histogram.With(
		prometheus.Labels{
			"service": serviceName,
			"code":    fmt.Sprintf("%d", code),
			"method":  req.Method,
			"path":    req.URL.Path,
		},
	).Observe(duration.Seconds())
}
```


<!-- .slide: data-background="../img/products/prometheus.png" -->
## ... and creating
# alerts

---

```
sum(rate(
    http_server_resp_time_bucket{
        le="0.1", kubernetes_name="go-demo-5"}[5m]
))
by (method, path) / 
sum(rate(
    http_server_resp_time_count{kubernetes_name="go-demo-5"}[5m]
)) 
by (method, path) < 0.99
```


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You learned that you continue being the major generator of
# spam emails

---
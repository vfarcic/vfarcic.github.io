<!-- .slide: data-background="../img/background/why.jpg" -->
# A long time ago in a galaxy far, far away...

---


<!-- .slide: data-background="../img/background/servers.jpg" -->
## You
# overprovisioned
## nodes just in case

---


<!-- .slide: data-background="../img/background/servers.jpg" -->
## You forced people to open
# JIRA tickets

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You stared at
# dashboards
## to find out when to scale your nodes

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You created
# scaling groups

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You scaled nodes when
## there's not enough
# available resources

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
## You adopted
# Kubernetes

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
## You realized that
# available resources 
## are a silly thing to measure

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
## You discovered
# Cluster Autoscaler

---

```bash
kubectl apply -f scaling/go-demo-5-many.yml

kubectl -n go-demo-5 get pods,nodes
```


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You learned that the
# pending state
## is not enough

---
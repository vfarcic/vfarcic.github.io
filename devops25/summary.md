<!-- .slide: data-background="../img/background/why.jpg" -->
# Today

---


<!-- .slide: data-background="../img/background/why.jpg" -->
## You are combining
# HPA (v2) with Prometheus

---


<!-- .slide: data-background="../img/background/why.jpg" -->
## ... and creating
# custom HPA formulas

---

```
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: go-demo-5
spec:
  ...
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Object
    object:
      metricName: http_req_per_second_per_replica
      target:
        kind: Ingress
        name: go-demo-5
      targetValue: 50m
```


<!-- .slide: data-background="../img/background/why.jpg" -->
## ... and
# autoscaling your nodes


<!-- .slide: data-background="../img/background/why.jpg" -->
## ... and
# notifying the system,
## not humans

---


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You are
# a designer
## and
# the last line of defence

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## ... and not waiting for
# JIRA tickets

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## ... nor thinking that dashboards are
# better than Netflix

---


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You are not waiting for
# problems to happen

---


<!-- .slide: data-background="../img/background/servers.jpg" -->
## You are working on what matters and letting
# machines do the rest

---

<!--
gcloud container clusters delete devops25 --region us-east1 --quiet

gcloud compute disks delete --zone us-east1-b $(gcloud compute disks list --filter="zone:us-east1-b AND -users:*" --format="value(id)")

gcloud compute disks delete --zone us-east1-c $(gcloud compute disks list --filter="zone:us-east1-c AND -users:*" --format="value(id)")

gcloud compute disks delete --zone us-east1-d $(gcloud compute disks list --filter="zone:us-east1-d AND -users:*" --format="value(id)")
-->
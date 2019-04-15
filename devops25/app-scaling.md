<!-- .slide: data-background="../img/background/why.jpg" -->
# A long time ago in a galaxy far, far away...

---


<!-- .slide: data-background="../img/background/source-code.jpeg" -->
## Your applications
# could not be scaled

---


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You knew that your applications should be scaled
# when users complained

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You stared at
# dashboards
## to find out when to scale your applications

---


<!-- .slide: data-background="../img/background/monitoring.jpeg" -->
## You created
# scaling groups

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
## You adopted
# Kubernetes

---


<!-- .slide: data-background="../img/products/kubernetes.png" -->
## You discovered
## HorizontalPodAutoscaler

---

```bash
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
spec:
  ...
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 80
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 80
```


<!-- .slide: data-background="../img/background/angry.jpg" -->
## You learned that
# memory and CPU
## is not enough

---
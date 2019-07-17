<!-- .slide: data-background="../img/background/why.jpg" -->
# Extending HPA With Custom Metrics

---


<!-- .slide: data-background="../img/background/scaling.jpeg" -->
> Adoption of HorizontalPodAutoscaler (HPA) usually goes through three phases: *discovery*, *usage*, and *re-discovery*.

> HPA v2 allows us to extend it to almost any type of metrics and expressions. We can hook HPAs to Prometheus, or nearly any other tool, though adapters. Once we master that, there is almost no limit to the conditions we can set as triggers of automatic scaling of our applications. The only restriction is our ability to transform data into Kubernetes' custom metrics.
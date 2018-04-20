<!-- .slide: data-background="../img/background/why.jpg" -->
# Deploying Stateful Applications At Scale

---


<!-- .slide: data-background="img/storage.jpg" -->
> Stateless and stateful application are quite different in their architecture. Those differences need to be reflected in Kubernetes as well. The fact that we can use Deployments with PersistentVolumes does not mean that is the best way to run stateful applications.

Note:
Most of the applications are deployed to Kubernetes using Deployments. It is, without a doubt, the most commonly used controller. Deployments provide (almost) everything we might need. We can specify the number of replicas when our applications need to be scaled. We can mount volumes through PersistentVolumeClaims. We can communicate with the Pods controlled by Deployments through Services. We can execute rolling updates that will deploy new releases without downtime. There are quite a few other features enabled by Deployments. Does that mean that Deployments are the preferable way to run all types of applications? Is there a feature we might need that is not already available through Deployments and other resources we can associate with them? food for a thought.

When running stateful applications in Kubernetes, we soon realize that Deployments do not offer everything we need. It's not that we require additional features, but that some of those available in Deployments do not behave just as we might want them to. In many cases, Deployments are an excellent fit for stateless applications. However, we might need to look for a different controller that will allow us to run stateful applications safely and efficiently. That controller is StatefulSet.
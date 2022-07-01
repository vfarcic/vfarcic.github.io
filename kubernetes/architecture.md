<!-- .slide: data-background-image="../img/products/kubernetes.png" data-background-opacity="0.2" data-background-size="contain" -->
## Kubernetes

# Architecture


<!-- .slide: data-background="img/what/control-plane.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/worker-node.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/external-resource.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/control-planes.png" data-background-size="cover" -->
Note: Decisions about the cluster (and beyond)<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/what/worker-nodes.png" data-background-size="cover" -->
Note: That's where in-cluster workloads are running


<!-- .slide: data-background="img/what/external-resources.png" data-background-size="cover" -->
Note: Whatever is not inside the cluster


<!-- .slide: data-background="img/what/external-resource-storage.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/external-resource-elb.png" data-background-size="cover" -->


<!-- .slide: data-background="img/what/api.png" data-background-size="cover" -->
Note: Kubernetes front-end, Query and manipulate the state of resources, REST interface


<!-- .slide: data-background="img/what/scheduler.png" data-background-size="cover" -->
Note: Items: Watches resource capacity, Assigns workloads to nodes


<!-- .slide: data-background="img/what/controller-manager.png" data-background-size="cover" -->
Note: Makes sure that the shared state is operating as expected, Oversees various controllers


<!-- .slide: data-background="img/what/key-value.png" data-background-size="cover" -->
Note: Distributed, Contains the state of the cluster, Typically etcd


<!-- .slide: data-background="img/what/kubelet.png" data-background-size="cover" -->
Note: Tracks the state of Pods, Ensures that all the containers in Pods are running


<!-- .slide: data-background="img/what/kube-proxy.png" data-background-size="cover" -->
Note: Maintains network rules


<!-- .slide: data-background="img/what/container-runtime.png" data-background-size="cover" -->
Note: Responsible for running containers


<!-- .slide: data-background="img/what/containers.png" data-background-size="cover" -->
Note: Software package


<!-- .slide: data-background="img/what/pods.png" data-background-size="cover" -->
Note: Groups of containers


<!-- .slide: data-background="img/what/controllers.png" data-background-size="cover" -->
Note: Manages resources, Control loop, Containers inside Pods

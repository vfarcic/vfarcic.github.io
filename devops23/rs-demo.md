<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Scaling Pods With ReplicaSets

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Creating ReplicaSets

```bash
cat rs/go-demo-2.yml

kubectl create -f rs/go-demo-2.yml

kubectl get rs

kubectl get -f rs/go-demo-2.yml

kubectl describe -f rs/go-demo-2.yml

kubectl get pods --show-labels

```
Note:
The key take away in the go-demo-2.yml file is the replicas defined in the spec section. The spec sets the desired number of replicas of the pod. In this case, the ReplicaSets should ensure that two Pods should run concurrently. If we did not specify the value of the replicas, it would default to 1. The next spec section is the selector. We use it to select which pods should be included in the ReplicaSet. It does not distinguish between the Pods created by a ReplicaSet or some other process. In other words, ReplicaSets and Pods are decoupled. If Pods that match the selector exist, ReplicaSet will do nothing. If they don't, it will create as many Pods to match the value of the replicas field. Not only that ReplicaSet creates the Pods that are missing, but it also monitors the cluster and ensures that the desired number of replicas is (almost) always running. In case there are already more running Pods with the matching selector, some will be terminated to match the number set in replicas. We used spec.selector.matchLabels to specify a few labels. They must match the labels defined in the spec.template. In our case, ReplicaSet will look for Pods with type set to backend and service set to go-demo-2.
The last section of the spec field is the template. It is the only required field in the spec, and it has the same schema as a Pod specification. At a minimum, the labels of the spec.template.metadata.labels section must match those specified in the spec.selector.matchLabels. The main purpose of that field is to ensure that the desired number of replicas is running. If they are created by other means, ReplicaSet will do nothing. Otherwise, it'll create them using the information in spec.template.
* We created a ReplicaSet
* We demonstrated that ReplicaSet creates missing controllers


<!-- .slide: data-background="img/rs-two-replicas.png" data-background-size="contain" -->


<!-- .slide: data-background="img/seq_pod_ch04.png" data-background-size="contain" -->

Note:
Sequence of events
1. Kubernetes client (kubectl) sent a request to the API server requesting the creation of a ReplicaSet defined in the rs/ go-demo-2. yml file.
2. The controller is watching the API server for new events, and it detected that there is a new ReplicaSet object.
3. The controller creates two new pod definitions because we have configured replica value as 2 in rs/ go-demo-2. yml file.
4. Since the scheduler is watching the API server for new events, it detected that there are two unassigned Pods.
5. The scheduler decided to which node to assign the Pod and sent that information to the API server.
6. Kubelet is also watching the API server. It detected that the two Pods were assigned to the node it is running on.
7. Kubelet sent requests to Docker requesting the creation of the containers that form the Pod. In our case, the Pod defines two containers based on the mongo and api image. So in total four containers are created.
8. Finally, Kubelet sent a request to the API server notifying it that the Pods were created successfully.


<!-- .slide: data-background="img/rs.png" data-background-size="contain" -->


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Operating ReplicaSets

```bash
kubectl delete -f rs/go-demo-2.yml --cascade=false

kubectl get rs

kubectl get pods

kubectl create -f rs/go-demo-2.yml --save-config

kubectl get pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Operating ReplicaSets

```bash
cat rs/go-demo-2-scaled.yml

kubectl apply -f rs/go-demo-2-scaled.yml

kubectl get pods

POD_NAME=$(kubectl get pods -o name | tail -1)

kubectl delete $POD_NAME

kubectl get pods
```

Note:
* We similated Pod failure
* We observed how ReplicaSet recreates failed Pods


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Operating ReplicaSets

```bash
POD_NAME=$(kubectl get pods -o name | tail -1)

kubectl label $POD_NAME service-

kubectl describe $POD_NAME

kubectl get pods --show-labels

kubectl label $POD_NAME service=go-demo-2

kubectl get pods
```

Note:
* We removed a matching label from one of the Pods
* We described the Pod to confirm that the label is removed
* We observed that ReplicaSet created a new Pod to satisfy the desired number of replicas
* We added back the label we removed
* We observed that ReplicaSet removed one of the Pods to satisfy the desired number of replicas


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## ReplicaSets?

* Guarantee that replicas of a Pod are running<!-- .element: class="fragment" -->
* Rarely created independently but through Deployments<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/rs-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f rs/go-demo-2-scaled.yml
```

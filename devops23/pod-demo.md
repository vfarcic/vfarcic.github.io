## Hands-On Time

---

# Creating Pods


## Quick And Dirty Way To Run Pods

---

```bash
kubectl run db --image mongo

kubectl get pods

# Wait for a while

kubectl get pods

kubectl delete deployment db
```


## Quick And Dirty Way To Run Pods

---

* We used undocumented way to create Pods (and more)

Note:
We used the imperative way to tell Kubernetes what to do. Even though there are cases when that might be useful, most of the time we want to leverage the declarative approach. We want to have a way to define what we need in a file and pass that information to Kubernetes. That way, we can have a documented and repeatable process, that can (and should) be version controlled as well. Moreover, the kubectl run was reasonably simple. In real life, we need to declare much more than the name of the deployment and the image. Commands like kubectl can quickly become too long and, in many cases, very complicated. Instead, we’ll write specifications in YAML format. Soon, we’ll see how we can accomplish a similar result using declarative syntax.


<!-- .slide: data-background="img/pod-single-container.png" data-background-size="contain" -->


## Declarative Syntax

---

```bash
cat pod/db.yml

kubectl create -f pod/db.yml

kubectl get pods

kubectl get pods -o wide

kubectl get pods -o json

kubectl get pods -o yaml

kubectl describe pod db

kubectl describe -f pod/db.yml
```

Note:
We’re using v1 of Kubernetes Pods API. Both apiVersion and kind are mandatory. That way, Kubernetes knows what we want to do (create a Pod) and which API version to use. The next section is metadata.It provides information that does not influence how the Pod behaves. We used metadata to define the name of the Pod (db) and a few labels. Later on, when we move into Controllers, labels will have a practical purpose. For now, they are purely informational. The last section is the spec in which we defined a single container.  The container is defined with the name (db), the image (mongo), the command that should be executed when the container starts (mongod), and, finally, the set of arguments. The arguments are defined as an array with, in this case, two elements (--rest and --httpinterface).
We will explore different means to retrieve information about running Pods


<!-- .slide: data-background="img/seq_pod_ch03.png" data-background-size="contain" -->

Note:
Creating a POD:
1. Kubernetes client (kubectl) sent a request to the API server requesting creation of a Pod defined in the pod/ db.yml file.
2. Since the scheduler is watching the API server for new events, it detected that there is an unassigned Pod.
3. The scheduler decided which node to assign the Pod to and sent that information to the API server.
4. Kubelet is also watching the API server. It detected that the Pod was assigned to the node it is running on.
5. Kubelet sent a request to Docker requesting the creation of the containers that form the Pod. In our case, the Pod defines a single container based on the mongo image.
6. Finally, Kubelet sent a request to the API server notifying it that the Pod was created successfully.


## Declarative Syntax

---

```bash
kubectl exec db ps aux

kubectl exec -it db sh

echo 'db.stats()' | mongo localhost:27017/test

exit

kubectl logs db

kubectl exec -it db pkill mongod

kubectl get pods
```

Note:
* We executed processes inside a Pod
* We retrieved logs of a Pod
* We explored what happens when a container fails


## Declarative Syntax

---

```bash
kubectl delete -f pod/db.yml

kubectl get pods

# Wait

kubectl get pods
```
Note:
* We deleted the Pod


## Running Multiple Containers

---

```bash
cat pod/go-demo-2.yml

kubectl create -f pod/go-demo-2.yml

kubectl get -f pod/go-demo-2.yml

kubectl get -f pod/go-demo-2.yml -o json

kubectl exec -it -c db go-demo-2 ps aux

kubectl logs go-demo-2 -c db

cat pod/go-demo-2-scaled.yml

kubectl delete -f pod/go-demo-2.yml
```

Note:
Pods are designed to run multiple cooperative processes that should act as a cohesive unit. Those processes are wrapped in containers. All the containers that form a Pod are running on the same machine. A Pod cannot be split across multiple nodes. All the processes (containers) inside a Pod share the same set of resources, and they can communicate with each other through localhost. One of those shared resources is storage. A volume defined in a Pod can be accessed by all the containers thus allowing them all to share the same data. We’ll explore storage in more depth later on. For now, let’s take a look at the pod/ go-demo-2. yml specification.

We explored how to execute processes inside a container in a multi-container Pod
We explored how to retrieve logs of a container in a multi-container Pod

For cat pod/go-demo-2-scaled.yml
We defined two containers for the API and named them api-1 and api-2. The only thing left is to create the Pod. But, we’re not going to do that. We should not think of Pods as resources that should do anything beyond a definition of the smallest unit in our cluster. A Pod is a collection of containers that share the same resources. Not much more. Everything else should be accomplished with higher-level constructs. We’ll explore how to scale Pods without changing their definition in one of the next chapters. Let’s go back to our original multi-container Pod that defined api and db containers. That was a terrible design choice since it tightly couples one with the other. As a result, when we explore how to scale Pods (not containers), both would need to match. If, for example, we scale the Pod to three, we’d have three APIs and three DBs. Instead, we should have defined two Pods, one for each container (db and api). That would give us enough flexibility to treat each independently from the other.


## Monitoring Health

---

```bash
cat pod/go-demo-2-health.yml

kubectl create -f pod/go-demo-2-health.yml

kubectl describe -f pod/go-demo-2-health.yml
```


## Monitoring Health

---

* We used `livenessProbe`
* We explored the effect of a `livenessProbe` that fails


## Pods?

---

* (Almost) Useless (By Themselves)<!-- .element: class="fragment" -->
* Fundamental building block<!-- .element: class="fragment" -->
* Disposable<!-- .element: class="fragment" -->
* (Almost) never created directly<!-- .element: class="fragment" -->


<!-- .slide: data-background="img/pod-components.png" data-background-size="contain" -->


## What Now?

```bash
kubectl delete -f pod/go-demo-2-health.yml
```

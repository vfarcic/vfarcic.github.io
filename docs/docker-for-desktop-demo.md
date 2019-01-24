## Hands-On Time

---

# Creating A Docker For Desktop Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Docker For Desktop](https://www.docker.com/products/docker-desktop)


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


## Getting The Code

---

* We cloned the repository that contains (almost) all the examples we'll use in this course


## Configuring Docker For Desktop

---

* Go To Preferences > Kubernetes <!-- .element: class="fragment" -->
* Check Enable Kubernetes <!-- .element: class="fragment" -->
* Check Kubernetes as the default orchestrator <!-- .element: class="fragment" -->
* Click the Advanced tab and set CPUs to 2, and Memory to 4.0 <!-- .element: class="fragment" -->


## Configuring Docker For Desktop

---

```bash
kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
```
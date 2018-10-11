## Hands-On Time

---

# Running A Kubernetes Cluster Locally


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Minikube](https://github.com/kubernetes/minikube/releases)


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


## Exploring Minikube

---

```bash
minikube start --vm-driver virtualbox --cpus 3 --memory 3072
```


## Exploring Minikube

---

* We started a single-node cluster with 3 CPUs and 3 GB RAM


<!-- .slide: data-background="img/minikube-simple.png" data-background-size="contain" -->


## Exploring Minikube

---

```bash
minikube status

minikube dashboard

minikube docker-env

eval $(minikube docker-env)

docker container ls
```


## Exploring Minikube

---

* We retrieved the status of the cluster
* We opened Kubernetes dashboard
* We configured local Docker client to use Docker engine in the minikube VM
* We listed all the containers in the minikube VM


## Exploring Minikube

---

```bash
minikube ssh

docker container ls

exit

kubectl config current-context

kubectl get nodes

minikube stop

minikube start

minikube delete
```


## Exploring Minikube

---

* We entered inside the minikube VM and listed all the containers
* We retrieved the current kubectl context
* We retrieved the nodes of the cluster
* We stopped the cluster, we started it again, and we deleted it


## Exploring Minikube

---

```bash
minikube start --vm-driver=virtualbox --kubernetes-version="v1.9.4"

kubectl version --output=yaml

minikube delete

minikube start --vm-driver virtualbox --cpus 3 --memory 3072
```


## Exploring Minikube

---

* We retrieved all Kubernetes versions supported by minikube
* We started a minikube cluster with a specific Kubernetes version
* We retrieved the version of the client and the server
* We deleted the cluster
* We started a single-node cluster with 3 CPUs and 3 GB RAM

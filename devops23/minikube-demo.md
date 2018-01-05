## Hands-On Time

---

# Minikube


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Minikube](https://github.com/kubernetes/minikube/releases)


## Exploring Minikube

---

```bash
minikube start --vm-driver=virtualbox

minikube status

minikube dashboard

minikube docker-env

eval $(minikube docker-env)

docker container ls
```


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

```bash
minikube get-k8s-versions

minikube start --vm-driver=virtualbox --kubernetes-version="v1.7.0"

kubectl version --output=yaml

minikube delete
```
## Hands-On Time

---

# Using minikube As A Local Kubernetes Cluster


## Exploring Minikube

---

```bash
minikube start --vm-driver virtualbox --cpus 4 --memory 4096

kubectl get nodes

minikube addons enable ingress

minikube addons enable storage-provisioner

minikube addons enable default-storageclass
```


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```
## Hands-On Time

---

# Securing Kubernetes Clusters


## WARNING

---

The next few slides work only on **minikube**. For **EKS**, please follow the instructions from [Managing Users or IAM Roles for your Cluster
](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html). Create a user and a cluster named *jdoe*. Once finished, continue from the **Deploying go-demo-2** slide.


## Accessing Kubernetes API

---

```bash
kubectl config view \
    -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.server}'

kubectl config view \
    -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.certificate-authority}'
```


## Creating Users

---

```bash
openssl version

mkdir keys

openssl genrsa -out keys/jdoe.key 2048

openssl req -new -key keys/jdoe.key -out keys/jdoe.csr \
    -subj "/CN=jdoe/O=devs"

ls -1 ~/.minikube/ca.*

openssl x509 -req -in keys/jdoe.csr -CA ~/.minikube/ca.crt \
    -CAkey ~/.minikube/ca.key -CAcreateserial -out keys/jdoe.crt \
    -days 365
```


## Creating Users

---

```bash
cp ~/.minikube/ca.crt keys/ca.crt

ls -1 keys

SERVER=$(kubectl config view \
    -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.server}')

echo $SERVER

kubectl config set-cluster jdoe \
    --certificate-authority keys/ca.crt --server $SERVER

kubectl config set-credentials jdoe \
    --client-certificate keys/jdoe.crt --client-key keys/jdoe.key
```


## Deploying go-demo-2

---

```bash
kubectl create -f auth/go-demo-2.yml --record --save-config
```


## Creating Users

---

```bash
kubectl config set-context jdoe \
    --cluster jdoe \
    --user jdoe

kubectl config use-context jdoe

kubectl config view

kubectl get pods

kubectl get all
```


## Pre-Defined Cluster Roles

---

```bash
kubectl config use-context minikube

kubectl get all

kubectl auth can-i get pods --as jdoe

kubectl get roles

kubectl get clusterroles

kubectl describe clusterrole view

kubectl describe clusterrole edit

kubectl describe clusterrole admin
```


## Pre-Defined Cluster Roles

---

```bash
kubectl describe clusterrole cluster-admin

kubectl auth can-i "*" "*"
```


## Role And Cluster Role Bindings

---

```bash
kubectl create rolebinding jdoe --clusterrole view --user jdoe \
    -n default --save-config

kubectl get rolebindings

kubectl describe rolebinding jdoe

kubectl -n kube-system describe rolebinding jdoe

kubectl auth can-i get pods --as jdoe

kubectl auth can-i get pods --as jdoe --all-namespaces

kubectl delete rolebinding jdoe
```


## Role And Cluster Role Bindings

---

```bash
cat auth/crb-view.yml

kubectl create -f auth/crb-view.yml --record --save-config

kubectl describe clusterrolebinding view

kubectl auth can-i get pods --as jdoe --all-namespaces

cat auth/rb-dev.yml

kubectl create -f auth/rb-dev.yml --record --save-config

kubectl -n dev auth can-i create deployments --as jdoe

kubectl -n dev auth can-i delete deployments --as jdoe
```


## Role And Cluster Role Bindings

---

```bash
kubectl -n dev auth can-i "*" "*" --as jdoe

cat auth/rb-jdoe.yml

kubectl create -f auth/rb-jdoe.yml --record --save-config

kubectl -n jdoe auth can-i "*" "*" --as jdoe

kubectl describe clusterrole admin

cat auth/crb-release-manager.yml

kubectl create -f auth/crb-release-manager.yml \
    --record --save-config
```


## Role And Cluster Role Bindings

---

```bash
kubectl describe clusterrole release-manager

kubectl -n default auth can-i "*" pods --as jdoe

kubectl -n default auth can-i create deployments --as jdoe

kubectl -n default auth can-i delete deployments --as jdoe

kubectl config use-context jdoe

kubectl -n default run db --image mongo:3.3

kubectl -n default delete deployment db
```


## Role And Cluster Role Bindings

---

```bash
kubectl config set-context jdoe --cluster jdoe --user jdoe \
    --namespace jdoe

kubectl config use-context jdoe

kubectl run db --image mongo:3.3

kubectl delete deployment db

kubectl create rolebinding mgandhi --clusterrole=view \
    --user=mgandhi -n=jdoe
```


## Replacing Users With Groups

---

```bash
openssl req -in keys/jdoe.csr -noout -subject

cat auth/groups.yml

kubectl config use-context minikube

kubectl apply -f auth/groups.yml --record

kubectl -n dev auth can-i create deployments --as jdoe

kubectl config use-context jdoe

kubectl -n dev run new-db --image mongo:3.3
```


## What Now?

---

```bash
# If minikube
kubectl config use-context minikube

# If EKS
kubectl config use-context \
    iam-root-account@devops24.$AWS_DEFAULT_REGION.eksctl.io

kubectl delete deploy db

kubectl delete rolebinding release-manager

kubectl delete ns jdoe dev

kubectl delete -f auth/go-demo-2.yml
```
## Hands-On Time

---

# Securing Kubernetes Clusters


## Creating Users

---

```bash
mkdir -p keys

openssl genrsa -out keys/jdoe.key 2048

openssl req -new -key keys/jdoe.key -out keys/jdoe.csr \
    -subj "/CN=jdoe/O=devs"

openssl x509 -req -in keys/jdoe.csr -CA ~/.minikube/ca.crt \
    -CAkey ~/.minikube/ca.key -CAcreateserial -out keys/jdoe.crt \
    -days 365
```


## Creating Users

---

```bash
cp ~/.minikube/ca.crt keys/ca.crt

SERVER=$(kubectl config view \
    -o jsonpath='{.clusters[?(@.name=="minikube")].cluster.server}')

echo $SERVER

kubectl config set-cluster jdoe \
    --certificate-authority keys/ca.crt --server $SERVER

kubectl config set-credentials jdoe \
    --client-certificate keys/jdoe.crt --client-key keys/jdoe.key
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

kubectl get clusterroles

kubectl describe clusterrole view

kubectl auth can-i "*" "*"
```


## Role And Cluster Role Bindings

---

```bash
kubectl create rolebinding jdoe --clusterrole view --user jdoe \
    -n default --save-config

kubectl auth can-i get pods --as jdoe

kubectl auth can-i get pods --as jdoe --all-namespaces

kubectl delete rolebinding jdoe
```


## Role And Cluster Role Bindings

---

```bash
cat auth/rb-jdoe.yml

kubectl create -f auth/rb-jdoe.yml --record --save-config

kubectl -n jdoe auth can-i "*" "*" --as jdoe

cat auth/crb-release-manager.yml

kubectl create -f auth/crb-release-manager.yml \
    --record --save-config
```


## Role And Cluster Role Bindings

---

```bash
kubectl -n default auth can-i "*" pods --as jdoe

kubectl -n default auth can-i create deployments --as jdoe

kubectl -n default auth can-i delete deployments --as jdoe

kubectl config use-context jdoe

kubectl -n default run db --image mongo:3.3

kubectl -n default delete deployment db
```


## What Now?

---

```bash
kubectl config use-context minikube

kubectl delete deploy db

kubectl delete rolebinding release-manager
```
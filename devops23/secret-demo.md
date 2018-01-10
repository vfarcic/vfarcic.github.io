## Hands-On Time

---

# Secrets


## Gist

---

[10-secret.sh](https://gist.github.com/37b3ef7afeaf9237aeb2b9a8065b10c3) (https://goo.gl/PLL2fm)


## Creating A Cluster

---

```bash
cd k8s-specs

git pull

minikube start --vm-driver=virtualbox

kubectl config current-context
```


## Exploring Built-In Secrets

---

```bash
kubectl create -f secret/jenkins-unprotected.yml \
    --record --save-config

kubectl rollout status deploy jenkins

open "http://$(minikube ip)/jenkins"

kubectl get secrets

kubectl describe pods

POD_NAME=$(kubectl get pods -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME -- ls \
    /var/run/secrets/kubernetes.io/serviceaccount
```


## Creating And Mounting Generic Secrets

---

```bash
kubectl create secret generic my-creds \
    --from-literal=username=jdoe --from-literal=password=incognito

kubectl get secrets

kubectl get secret my-creds -o json

kubectl get secret my-creds -o jsonpath="{.data.username}" \
    | base64 --decode

kubectl get secret my-creds -o jsonpath="{.data.password}" \
    | base64 --decode
```


## Creating And Mounting Generic Secrets

---

```bash
cat secret/jenkins.yml

kubectl apply -f secret/jenkins.yml

kubectl rollout status deploy jenkins

POD_NAME=$(kubectl get pods -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME -- ls /run/secrets

kubectl exec -it $POD_NAME -- cat /run/secrets/jenkins-user

open "http://$(minikube ip)/jenkins"
```


## What Now?

```bash
minikube delete
```

[Secret v1 core](https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#secret-v1-core) (https://v1-8.docs.kubernetes.io/docs/api-reference/v1.8/#secret-v1-core)

## Namespaces coming next<!-- .element: class="fragment" -->

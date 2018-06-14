## Hands-On Time

---

# Using Secrets To Hide Confidential Information


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

kubectl exec -it $POD_NAME -- ls /etc/secrets

kubectl exec -it $POD_NAME -- cat /etc/secrets/jenkins-user

open "http://$(minikube ip)/jenkins"
```


<!-- .slide: data-background="img/secret-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f secret/jenkins.yml

kubectl delete secret my-creds
```

## Hands-On Time

---

# Using Secrets To Hide Confidential Information


## Exploring Built-In Secrets

---

```bash
kubectl create -f secret/jenkins-unprotected.yml \
    --record --save-config

kubectl rollout status deploy jenkins

open "http://$IP/jenkins"

kubectl get secrets

kubectl describe pods

POD_NAME=$(kubectl get pods -l service=jenkins,type=master \
    -o jsonpath="{.items[*].metadata.name}")

kubectl exec -it $POD_NAME -- ls \
    /var/run/secrets/kubernetes.io/serviceaccount
```


## Exploring Built-In Secrets

---

* We created a Jenkins Deployment
* We opened Jenkins UI and confirmed that it's running and that it was unprotected
* We listed the Secrets and discovered that one (`default-token`) is already created
* We described the Pod and discovered that the `default-token` Secret is mounted
* We output the files in the `serviceaccount` directory and discovered that a couple of files were mounted


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

* We created a Secret with a `username` and `password`
* We output the secrets and confirmed that `my-creds` is available
* We output the secret in json format and discovered that it is encoded
* We output and decoded the `username` and the `password`


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

open "http://$IP/jenkins"
```


## Creating And Mounting Generic Secrets

---

* We applied a new Jenkins definition with the Secret (the custom image expects them)
* We retrieved the files from the `jenkins-user` directory and confirmed that both entries of the Secret are avilable as files
* We opened Jenkins and confirmed that authentication works


<!-- .slide: data-background="img/secret-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f secret/jenkins.yml

kubectl delete secret my-creds
```

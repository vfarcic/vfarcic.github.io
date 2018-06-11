## Hands-On Time

---

# Using Ingress To Forward Traffic


## Enabling Ingress Controllers

---

```bash
minikube addons enable ingress

IP=$(minikube ip)

curl -i "http://$IP/healthz"
```


## Ingress Based On Paths

---

```bash
cat ingress/go-demo-2.yml

kubectl create -f ingress/go-demo-2.yml --record --save-config

kubectl rollout status deployment go-demo-2-api

curl -i "http://$IP/demo/hello"
```


<!-- .slide: data-background="img/seq_ingress_ch07.png" data-background-size="contain" -->


## Ingress Based On Domains

---

```bash
cat ingress/devops-toolkit-dom.yml

kubectl apply -f ingress/devops-toolkit-dom.yml --record

kubectl rollout status deployment devops-toolkit

curl -I -H "Host: devopstoolkitseries.com" "http://$IP"

curl -I -H "Host: acme.com" "http://$IP/demo/hello"
```


## Ingress With Default Backends

---

```bash
curl -I -H "Host: acme.com" "http://$IP"

cat ingress/default-backend.yml

kubectl create -f ingress/default-backend.yml

curl -I -H "Host: acme.com" "http://$IP"

open "http://$IP"
```


<!-- .slide: data-background="img/ingress-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f ingress/default-backend.yml

kubectl delete -f ingress/devops-toolkit-dom.yml

kubectl delete -f ingress/go-demo-2.yml
```

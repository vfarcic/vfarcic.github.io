## Hands-On Time

---

# Using Ingress To Forward Traffic


## Services Deficiencies

---

```bash
# If minikube
kubectl create -f ingress/go-demo-2-deploy.yml

# If EKS
kubectl create -f ingress/go-demo-2-deploy-lb.yml

kubectl get -f ingress/go-demo-2-deploy.yml

kubectl get pods
```


## Services Deficiencies

---

```bash
# If minikube
API_IP=$(minikube ip)

# If EKS
API_IP=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
API_PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
API_PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].port}")

curl -i "http://$API_IP:$API_PORT/demo/hello"
```


## Services Deficiencies

---

```bash
# If minikube
kubectl create -f ingress/devops-toolkit-dep.yml \
    --record --save-config

# If EKS
kubectl create -f ingress/devops-toolkit-dep-lb.yml \
    --record --save-config

kubectl get -f ingress/devops-toolkit-dep.yml
```


## Services Deficiencies

---

```bash
# If minikube
T_IP=$(minikube ip)

# If EKS
T_IP=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If minikube
T_PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].nodePort}")

# If EKS
T_PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].port}")

open "http://$T_IP:$T_PORT"

curl "http://$T_IP/demo/hello"

curl -i -H "Host: devopstoolkitseries.com" "http://$T_IP"
```


<!-- .slide: data-background="img/services.png" data-background-size="contain" -->


## Enabling Ingress (minikube)

---

```bash
# If minikube
minikube addons list

# If minikube
minikube addons enable ingress

IP=$(minikube ip)
```


## Enabling Ingress (EKS)

---

```bash
# TODO: Continue
kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/service-l4.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/aws/patch-configmap-l4.yaml

kubectl patch service ingress-nginx \
    -p '{"spec":{"externalTrafficPolicy":"Local"}}' \
    -n ingress-nginx

IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")
```


## Enabling Ingress

---

```bash
curl -i "http://$IP/healthz"

curl -i "http://$IP/something"
```


## Ingress Based On Paths

---

```bash
cat ingress/go-demo-2-ingress.yml

kubectl create -f ingress/go-demo-2-ingress.yml

kubectl get -f ingress/go-demo-2-ingress.yml

curl -i "http://$IP/demo/hello"

kubectl delete -f ingress/go-demo-2-ingress.yml

kubectl delete -f ingress/go-demo-2-deploy.yml
```


## Ingress Based On Paths

---

```bash
cat ingress/go-demo-2.yml

kubectl create -f ingress/go-demo-2.yml --record --save-config

curl -i "http://$IP/demo/hello"

kubectl delete -f ingress/devops-toolkit-dep.yml
```


<!-- .slide: data-background="img/seq_ingress_ch07.png" data-background-size="contain" -->


## Ingress Based On Paths

---

```bash
cat ingress/devops-toolkit.yml

kubectl create -f ingress/devops-toolkit.yml --record --save-config

kubectl get ing

open "http://$IP"

curl "http://$IP/demo/hello"
```


<!-- .slide: data-background="img/ingress.png" data-background-size="contain" -->


## Ingress Based On Domains

---

```bash
cat ingress/devops-toolkit-dom.yml

kubectl apply -f ingress/devops-toolkit-dom.yml --record

curl -I "http://$IP"

curl -I -H "Host: devopstoolkitseries.com" "http://$IP"

curl -H "Host: acme.com" "http://$IP/demo/hello"
```


## Ingress With Default Backends

---

```bash
curl -I -H "Host: acme.com" "http://$IP"

cat ingress/default-backend.yml

kubectl create -f ingress/default-backend.yml

curl -I -H "Host: acme.com" "http://$IP"
```


<!-- .slide: data-background="img/ingress-components.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete -f ingress/default-backend.yml

kubectl delete -f ingress/devops-toolkit-dom.yml

kubectl delete -f ingress/go-demo-2.yml
```

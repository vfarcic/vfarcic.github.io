## Hands-On Time

---

# Ingress


## Gist

---

[07-ingress.sh](https://gist.github.com/54ef6592bce747ff2d1b089834fc755b) (https://goo.gl/yg2fB9)


## Creating A Cluster

---

```bash
cd k8s-specs

git pull

minikube start --vm-driver=virtualbox

kubectl config current-context
```


## Services Deficiencies

---

```bash
kubectl create -f ingress/go-demo-2-deploy.yml

kubectl get -f ingress/go-demo-2-deploy.yml

kubectl get pods

IP=$(minikube ip)

PORT=$(kubectl get svc go-demo-2-api \
    -o jsonpath="{.spec.ports[0].nodePort}")

curl -i "http://$IP:$PORT/demo/hello"
```


## Services Deficiencies

---

```bash
kubectl create -f ingress/devops-toolkit-dep.yml \
    --record --save-config

kubectl get -f ingress/devops-toolkit-dep.yml

PORT=$(kubectl get svc devops-toolkit \
    -o jsonpath="{.spec.ports[0].nodePort}")

open "http://$IP:$PORT"

curl "http://$IP/demo/hello"

curl -i -H "Host: devopstoolkitseries.com" "http://$IP"
```


<!-- .slide: data-background="img/services.png" data-background-size="contain" -->


## Enabling Ingress Controllers

---

```bash
minikube addons list

minikube addons enable ingress

eval $(minikube docker-env)

docker container ps --format "table {{.Names}}\t{{.Status}}" \
    -f name=8s_nginx-ingress-controller

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

cat ingress/devops-toolkit.yml

kubectl delete -f ingress/devops-toolkit-dep.yml
```


## Ingress Based On Paths

---

```bash
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


## What Now?

---

```bash
minikube delete
```

* [Ingress v1beta1 extensions](https://kubernetes.io/docs/api-reference/v1.8/#ingress-v1beta1-extensions) (https://kubernetes.io/docs/api-reference/v1.8/#ingress-v1beta1-extensions)

## Volumes coming next<!-- .element: class="fragment" -->
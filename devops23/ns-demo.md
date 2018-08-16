## Hands-On Time

---

# Dividing A Cluster Into Namespaces


## Deploying The First Release

---

```bash
cat ns/go-demo-2.yml

IMG=vfarcic/go-demo-2

TAG=1.0

cat ns/go-demo-2.yml | sed -e "s@image: $IMG@image: $IMG:$TAG@g" \
    | kubectl create -f -

kubectl rollout status deploy go-demo-2-api
```


## Deploying The First Release

---

* We deployed *go-demo-2* resources with a specific image tag
* We waited until the deployment rolls out


## Exploring Virtual Clusters

---

```bash
# If minikube
IP=$(minikube ip)

# If EKS
IP=$(kubectl -n ingress-nginx get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

curl -H "Host: go-demo-2.com" "http://$IP/demo/hello"

kubectl get all
```


## Exploring Virtual Clusters

---

* We retrieved the IP of the cluster
* We sent a request to the production release tied to the `go-demo-2.com` domain
* We retrieved the list of all the resources


<!-- .slide: data-background="img/go-demo-2.png" data-background-size="contain" -->


## Exploring The Existing Namespaces

---

```bash
kubectl get ns
```


## Exploring The Existing Namespaces

---

* We retrieved the list of all the Namespaces


<!-- .slide: data-background="img/default-ns.png" data-background-size="contain" -->


## Exploring The Existing Namespaces

---

```bash
kubectl -n kube-public get all

kubectl -n kube-system get all
```


## Exploring The Existing Namespaces

---

* We retrieved the list of all the resources in `kube-public` and `kube-system` Namespaces


<!-- .slide: data-background="img/kube-system-ns.png" data-background-size="contain" -->


## Deploying To A New Namespace

---

```bash
kubectl create ns testing

kubectl get ns

# If minikube
kubectl config set-context testing --namespace testing \
    --cluster minikube --user minikube

# If EKS
kubectl config set-context testing --namespace testing \
    --cluster devops24.$AWS_DEFAULT_REGION.eksctl.io \
    --user iam-root-account@devops24.$AWS_DEFAULT_REGION.eksctl.io

kubectl config view

kubectl config use-context testing
```


## Deploying To A New Namespace

---

* We created a new Namespace called `testing`
* We retrieved the list of all the Namespaces and confirmed that `testing` is available
* We created a new context with the `testing` Namespace as the default
* We viewed the `kubectl` configuration and observed that the current context is still using the `default` Namespace
* We switched to the `testing` context


## Deploying To A New Namespace

---

```bash
kubectl get all

TAG=2.0

DOM=go-demo-2.com

cat ns/go-demo-2.yml | sed -e "s@image: $IMG@image: $IMG:$TAG@g" \
    | sed -e "s@host: $DOM@host: $TAG\.$DOM@g" \
    | kubectl create -f -

kubectl rollout status deploy go-demo-2-api
```


## Deploying To A New Namespace

---

* We listed all the resources in the `testing` Namespace
* We installed `go-demo-2` with the tag `2.0` and a new domain in the `testing` Namespace
* We checked the `rollout status` of the new installation


<!-- .slide: data-background="img/testing-ns.png" data-background-size="contain" -->


## Deploying To A New Namespace

---

```bash
curl -H "Host: go-demo-2.com" "http://$IP/demo/hello"

curl -H "Host: 2.0.go-demo-2.com" "http://$IP/demo/hello"
```


## Deploying To A New Namespace

---

* We confirmed that both installations are running (in separate Namespaces) by sending a request to each


## Communicating Btw Namespaces

---

```bash
# If minikube
kubectl config use-context minikube

# If EKS
kubectl config use-context iam-root-account@devops24.$AWS_DEFAULT_REGION.eksctl.io

kubectl run test --image=alpine --restart=Never sleep 10000

kubectl get pod test

kubectl exec -it test -- apk add -U curl

kubectl exec -it test -- curl "http://go-demo-2-api:8080/demo/hello"

kubectl exec -it test \
    -- curl "http://go-demo-2-api.testing:8080/demo/hello"
```


## Communicating Btw Namespaces

---

* We switched back to the previous context
* We run a Pod based on `alpine`
* Inside the container of the new Pod, we installed `curl`
* We sent a request to the API in the same Namespace
* We sent a request to the API in the `testing` Namespace


## Deleting A Namespace

---

```bash
kubectl delete ns testing

kubectl -n testing get all

kubectl get all

curl -H "Host: go-demo-2.com" "http://$IP/demo/hello"

kubectl set image deployment/go-demo-2-api \
    api=vfarcic/go-demo-2:2.0 --record

curl -H "Host: go-demo-2.com" "http://$IP/demo/hello"
```


## Deleting A Namespace

---

* We deleted the `testing` Namespace
* We observed that all the resources from the Namespace were deleted as well
* We confirmed that the resources from the `default` Namespace are still intact and the release `1.0` is still running
* We upgraded the release to `2.0` and confirmed that it is running


## What Now?

---

```bash
kubectl delete -f ns/go-demo-2.yml

kubectl delete pod test
```

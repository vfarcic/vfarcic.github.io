## Hands-On Time

---

# Manual CD


## Cluster Setup
## (if not already running)

---

```bash
source cluster/kops

chmod +x kops/cluster-setup.sh

NODE_COUNT=3 NODE_SIZE=t2.medium \
    ./kops/cluster-setup.sh
```


## Preparing build ns

---

```bash
cat ../go-demo-3/k8s/build-ns.yml

kubectl create -f ../go-demo-3/k8s/build-ns.yml \
    --save-config --record

kubectl -n go-demo-3-build describe rolebinding build

kubectl -n go-demo-3-build describe clusterrole admin

cat ../go-demo-3/k8s/prod-ns.yml

kubectl create -f ../go-demo-3/k8s/prod-ns.yml \
    --save-config --record
```


## Build, UT, and release beta

---

```bash
kubectl create ns go-demo-3-1-0-beta

cat cd/docker-socket.yml

kubectl -n go-demo-3-1-0-beta create -f cd/docker-socket.yml \
    --save-config --record

kubectl -n go-demo-3-1-0-beta get pods

kubectl -n go-demo-3-1-0-beta describe pod docker

kubectl -n go-demo-3-1-0-beta exec -it docker -- sh

docker version

docker container ls
```


## Build, UT, and release beta

---

* Fork https://github.com/vfarcic/go-demo-3.git
* Change `vfarcic` to your GH user in *k8s/build.yml*, *k8s/prod.yml*, and *k8s/functional.yml*

```bash
export GH_USER=[...]

git clone https://github.com/$GH_USER/go-demo-3.git

# It should be a specific commit

cd go-demo-3

export DH_USER=[...]

docker login -u $DH_USER

docker image build -t $DH_USER/go-demo-3:1.0-beta .

exit
```


## Build, UT, and release beta

---

* Docker might be too old
* Socket is exposed
* The node is logged in

```bash
kubectl delete ns go-demo-3-1-0-beta

export GH_USER=[...]

rm -rf ../go-demo-3

git clone https://github.com/$GH_USER/go-demo-3.git ../go-demo-3

export DH_USER=[...]
```

* Docker must be 17.05+

```bash
docker image build -t $DH_USER/go-demo-3:1.0-beta ../go-demo-3/

docker image ls
```


## Build, UT, and release beta

---

```bash
docker image push $DH_USER/go-demo-3:1.0-beta

docker login -u $DH_USER

docker image push $DH_USER/go-demo-3:1.0-beta
```


## Functional Tests

---

```bash
cat ../go-demo-3/k8s/kubectl.yml

open "https://github.com/vfarcic/kubectl/blob/master/Dockerfile"

open "https://hub.docker.com/r/vfarcic/kubectl/tags/"

kubectl apply -f ../go-demo-3/k8s/kubectl.yml

kubectl -n go-demo-3-build get pods
```

* Need to figure out how to deploy kubectl without kubectl

```bash
kubectl -n go-demo-3-build cp ../go-demo-3/k8s/build.yml \
    kubectl:/tmp/build.yml

kubectl -n go-demo-3-build exec -it kubectl -- sh

kubectl auth can-i create deployment

kubectl -n go-demo-3 auth can-i create sts

kubectl -n default auth can-i create deployment
```


## Functional Tests

---

```bash
kubectl auth can-i create ns

cat /tmp/build.yml | sed -e "s@:latest@:1.0-beta@g" | tee build.yml

kubectl apply -f /tmp/build.yml --record

exit
```

* We won't do this any more. It's painful and unintuitive, but we'll need something similar later.

```bash
kubectl -n go-demo-3-build rollout status deployment api

kubectl -n go-demo-3-build get pods

kubectl describe ns go-demo-3-build

DNS=$(kubectl -n go-demo-3-build get ing api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

curl "http://$DNS/beta/demo/hello"
```


## Functional Tests

---

```bash
kubectl -n go-demo-3-build run golang --quiet --restart Never \
    --env GH_USER=$GH_USER --env DNS=$DNS --image golang:1.9 \
    sleep 1000000
```

* It'll be slow because of low defaults

```bash
kubectl -n go-demo-3-build get pods

kubectl -n go-demo-3-build exec -it golang -- sh

git clone https://github.com/$GH_USER/go-demo-3.git

cd go-demo-3
```


## Functional Tests

---

```bash
export ADDRESS=api:8080

go get -d -v -t

go test ./... -v --run FunctionalTest

export ADDRESS=$DNS/beta

go test ./... -v --run FunctionalTest

exit
```


## Functional Tests

---

* Can't delete the Namespace since it's set up by a cluster admin. Also, we still need that Namespace.

```bash
kubectl delete -f ../go-demo-3/k8s/build.yml

kubectl -n go-demo-3-build get all
```


## Release

---

```bash
docker image tag $DH_USER/go-demo-3:1.0-beta \
    $DH_USER/go-demo-3:1.0

docker image push $DH_USER/go-demo-3:1.0

docker image tag $DH_USER/go-demo-3:1.0-beta \
    $DH_USER/go-demo-3:latest

docker image push $DH_USER/go-demo-3:latest
```


## Deploy

---

```bash
cat ../go-demo-3/k8s/prod.yml | sed -e "s@:latest@:1.0@g" \
    | tee prod.yml

kubectl apply -f prod.yml --record

kubectl -n go-demo-3 rollout status deployment api

kubectl -n go-demo-3 get pods

curl "http://$DNS/demo/hello"
```


## Production Testing

---

```bash
kubectl -n go-demo-3-build exec -it golang -- sh

cd go-demo-3

export ADDRESS=$DNS

go test ./... -v --run ProductionTest

exit
```


## Cleaning Up

---

```bash
kubectl -n go-demo-3-build get pods
```

* Still left with "tool" Pods. Need to figure out how to remove them automatically.

```bash
kubectl -n go-demo-3-build delete pods --all 
```


## What Now?

---

```bash
kubectl delete ns go-demo-3 go-demo-3-build
```

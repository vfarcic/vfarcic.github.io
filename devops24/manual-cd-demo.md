## Hands-On Time

---

# Defining CD


## Cluster Setup
## (if not already running)

---

```bash
source cluster/kops

chmod +x kops/cluster-setup.sh

NODE_COUNT=3 NODE_SIZE=t2.medium \
    ./kops/cluster-setup.sh
```


<!-- .slide: data-background="img/manual-cd-stages.png" data-background-size="contain" -->


## Creating Namespaces

---

```bash
open "https://github.com/vfarcic/go-demo-3"

# Fork the repository

cd ..

rm -rf go-demo-3

export GH_USER=[...]

git clone https://github.com/$GH_USER/go-demo-3.git

cd go-demo-3

git pull
```


## Creating Namespaces

---

```bash
cat k8s/build-ns.yml

kubectl apply -f k8s/build-ns.yml --record

cat k8s/prod-ns.yml

kubectl apply -f k8s/prod-ns.yml --record
```


## Defining A Pod With The Tools

---

```bash
cat k8s/cd.yml

kubectl apply -f k8s/cd.yml --record
```


## Executing Continuous Integration Inside Containers

---

```bash
kubectl -n go-demo-3-build exec -it cd -c docker -- sh

docker container ls

export GH_USER=[...]

git clone https://github.com/$GH_USER/go-demo-3.git .

export DH_USER=[...]

docker login -u $DH_USER
```


## Executing Continuous Integration Inside Containers

---

```bash
cat Dockerfile

docker image build -t $DH_USER/go-demo-3:1.0-beta .

docker image ls

docker image push $DH_USER/go-demo-3:1.0-beta

exit
```


<!-- .slide: data-background="img/manual-cd-steps-build.png" data-background-size="contain" -->


## Running Functional Tests

---

```bash
kubectl -n go-demo-3-build exec -it cd -c kubectl -- sh

cat k8s/build.yml

diff k8s/build.yml k8s/prod.yml

cat k8s/build.yml | sed -e "s@:latest@:1.0-beta@g" | \
    tee /tmp/build.yml

kubectl apply -f /tmp/build.yml --record

kubectl rollout status deployment api

echo $?
```


## Running Functional Tests

---

```bash
ADDR=$(kubectl -n go-demo-3-build get ing api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")/beta

echo $ADDR | tee /workspace/addr

exit

kubectl -n go-demo-3-build exec -it cd -c golang -- sh

curl "http://$(cat addr)/demo/hello"

go get -d -v -t

export ADDRESS=api:8080

go test ./... -v --run FunctionalTest
```


## Running Functional Tests

---

```bash
export ADDRESS=$(cat addr)

go test ./... -v --run FunctionalTest

exit

kubectl -n go-demo-3-build exec -it cd -c kubectl -- sh

kubectl delete -f /workspace/k8s/build.yml

kubectl -n go-demo-3-build get all

exit
```


<!-- .slide: data-background="img/manual-cd-steps-func.png" data-background-size="contain" -->


## Creating Production Releases

---

```bash
kubectl -n go-demo-3-build exec -it cd -c docker -- sh

export DH_USER=[...]

docker image tag $DH_USER/go-demo-3:1.0-beta $DH_USER/go-demo-3:1.0

docker image push $DH_USER/go-demo-3:1.0

docker image tag $DH_USER/go-demo-3:1.0-beta \
    $DH_USER/go-demo-3:latest

docker image push $DH_USER/go-demo-3:latest

exit
```


<!-- .slide: data-background="img/manual-cd-steps-release.png" data-background-size="contain" -->


## Deploying To Production

---

```bash
kubectl -n go-demo-3-build exec -it cd -c kubectl -- sh

cat k8s/prod.yml | sed -e "s@:latest@:1.0@g" | tee /tmp/prod.yml

kubectl apply -f /tmp/prod.yml --record

kubectl -n go-demo-3 rollout status deployment api

echo $?

ADDR=$(kubectl -n go-demo-3 get ing api \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo $ADDR | tee /workspace/prod-addr

exit
```


<!-- .slide: data-background="img/manual-cd-steps-deploy.png" data-background-size="contain" -->


## Running Production Tests

---

```bash
kubectl -n go-demo-3-build exec -it cd -c golang -- sh

export ADDRESS=$(cat prod-addr)

go test ./... -v --run ProductionTest

exit
```


<!-- .slide: data-background="img/manual-cd-steps-prod.png" data-background-size="contain" -->


## Cleaning Up Pipeline Leftovers

---

```bash
kubectl -n go-demo-3-build delete pods --all
```


<!-- .slide: data-background="img/manual-cd-steps-cleanup.png" data-background-size="contain" -->


## What Now?

---

```bash
kubectl delete ns go-demo-3 go-demo-3-build
```
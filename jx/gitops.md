<!-- .slide: data-background="../img/products/git.png" -->
# Code Repository

---


<!-- .slide: data-background="../img/background/why.jpg" -->
# The Only Source Of Truth?

---


<!-- .slide: data-background="../img/background/manual.jpg" -->
# Importing A Project

---

```bash
jx create quickstart -l go -p jx-go -b

cd jx-go
```


<!-- .slide: data-background="../img/background/god.jpg" -->


<!-- .slide: data-background="../img/products/git.png" -->
# 1.

---

# Git Is The Only Source Of Truth


<!-- .slide: data-background="img/gitops-apps.png" data-background-size="contain" -->


<!-- .slide: data-background="../img/background/manual.jpg" -->
## Git Is The Only Source Of Truth

---

```bash
cat main.go | sed -e "s@golang http@GitOps@g" | tee main.go

git add .

git commit -m "This is GitOps"

git push

jx get activities -f jx-go -w
```


<!-- .slide: data-background="../img/products/git.png" -->
# 2.

---

## Everything must be tracked,
### every action must be reproducible,
### and everything must be idempotent


<!-- .slide: data-background="img/confused.jpg" -->


<!-- .slide: data-background="img/king.jpg" -->


<!-- .slide: data-background="img/slave.jpg" -->


<!-- .slide: data-background="../img/background/servers.jpg" -->


<!-- .slide: data-background="../img/background/communication.jpeg" -->


<!-- .slide: data-background="img/restaurant.jpg" -->


<!-- .slide: data-background="../img/background/communication.jpeg" -->
# 3.

---

## Communication between processes must be asynchronous


<!-- .slide: data-background="img/gitops-webhooks.png" data-background-size="contain" -->


<!-- .slide: data-background="img/butler.jpg" -->


<!-- .slide: data-background="img/buckingham-palace.jpg" -->


<!-- .slide: data-background="img/hogwarts.jpg" -->


<!-- .slide: data-background="img/staff.jpg" -->


<!-- .slide: data-background="../img/background/servers.jpg" -->
# 4.

---

## Processes should run 
## for as long as needed,
## but not longer


<!-- .slide: data-background="img/gitops-agents.png" data-background-size="contain" -->


<!-- .slide: data-background="../img/background/manual.jpg" -->
## Processes should run 
## for as long as needed,
## but not longer

---

```bash
kubectl get pods
```


<!-- .slide: data-background="../img/background/servers.jpg" -->
# 5.

---

## All binaries must be stored 
## in registries


<!-- .slide: data-background="img/gitops-registries.png" data-background-size="contain" -->


<!-- .slide: data-background="../img/background/manual.jpg" -->
## Processes should run 
## for as long as needed,
## but not longer

---

```bash
CM_ADDR=$(kubectl get ing chartmuseum \
    -o jsonpath="{.spec.rules[0].host}")

curl "http://$CM_ADDR/index.yaml"
```


<!-- .slide: data-background="../img/background/why.jpg" -->
# Where do we store environments definition?

---


<!-- .slide: data-background="../img/products/git.png" -->
# 6.

---

### Information about all the releases
## must be stored in 
### environment-specific repositories
## or branches


<!-- .slide: data-background="../img/background/manual.jpg" -->
### Information about all the releases
## must be stored in 
### environment-specific repositories
## or branches

---

```bash
open "https://github.com/vfarcic/environment-jx-rocks-staging/blob/master/env/requirements.yaml"
```


<!-- .slide: data-background="../img/background/best-practices.jpg" -->
# 7.

---

## Everything must follow
## the same coding practices


<!-- .slide: data-background="img/gitops-env.png" data-background-size="contain" -->


<!-- .slide: data-background="../img/background/manual.jpg" -->
## Everything must follow
## the same coding practices

---

```bash
open "https://github.com/vfarcic/environment-jx-rocks-staging/pulls"
```


<!-- .slide: data-background="../img/background/deployment.png" -->
# 8.

---

## All deployments must be
# idempotent


<!-- .slide: data-background="img/desire.jpg" -->


<!-- .slide: data-background="../img/background/manual.jpg" -->
## All deployments must be
# idempotent

---

```bash
cd ..

git clone https://github.com/vfarcic/environment-jx-rocks-staging.git

cd environment-jx-rocks-staging/env

CM_ADDR=$(kubectl get ing chartmuseum \
    -o jsonpath="{.spec.rules[0].host}")

cat requirements.yaml | sed -e \
    "s@http://jenkins-x-chartmuseum:8080@http://$CM_ADDR@g" \
    | tee requirements.yaml

jx step helm apply --namespace jx-staging

kubectl -n jx-staging get pods
```


<!-- .slide: data-background="../img/products/git.png" -->
# 9.

---

# Git webhooks
### are the only ones allowed to initiate 
# a change
### that will be applied to the system


<!-- .slide: data-background="../img/background/manual.jpg" -->
# Git webhooks
### are the only ones allowed to initiate 
# a change
### that will be applied to the system

---

```bash
open "https://github.com/vfarcic/jx-go/settings/hooks"
```


<!-- .slide: data-background="../img/background/communication.jpeg" -->
# 10.

---

# All the tools
### must be able to speak with each other
# through APIs


<!-- .slide: data-background="../img/background/manual.jpg" -->
# All the tools
### must be able to speak with each other
# through APIs

---

```bash
jx get applications -e staging

VERSION=[...]

jx promote go-demo-6 --version $VERSION --env production -b

cd ..
```


<!-- .slide: data-background="../img/background/god.jpg" -->
### Git Is The Only Source Of Truth

---

#### Everything must be tracked, every action must be reproducible, and everything must be idempotent

---

### Communication between processes must be asynchronous

---

### Processes should run for as long as needed, but not longer

---

### All binaries must be stored in registries


<!-- .slide: data-background="../img/background/god.jpg" -->
#### Information about all the releases must be stored in environment-specific repositories or branches

---

## Everything must follow the same coding practices

---

### All deployments must be idempotent

---

#### Git webhooks are the only ones allowed to initiate a change that will be applied to the system

---

### All the tools must be able to speak with each other through APIs


<!-- .slide: data-background="../img/background/hell.jpg" -->
# Or...

---
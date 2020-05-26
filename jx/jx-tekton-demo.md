<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Running Serverless Continuous Delivery

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Where Is Jenkins?

```bash
kubectl get pods

kubectl top pods
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Starting A New Project

```bash
jx create quickstart --language go --project-name jx-serverless \
    --name jx-serverless

cd jx-serverless

ls -1

cat Dockerfile

ls -1 charts/jx-serverless

cat skaffold.yaml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Starting A New Project

```bash
cat jenkins-x.yml

kubectl get pods

jx get activities --filter jx-serverless --watch

jx get applications
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Defining Owners

```bash
export GH_USER=[...]

export GH_APPROVER=[...]

echo "approvers:
- $GH_USER
- $GH_APPROVER
reviewers:
- $GH_USER
- $GH_APPROVER" \
    | tee OWNERS
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Defining Owners

```bash
git commit -am "Added the other me"

git push --set-upstream origin master
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Creating A Pull Request

```bash
git checkout -b my-pr

echo "I'm lazy" | tee README.md

git add .

git commit -m "My first PR with serverless jx"

git push --set-upstream origin my-pr

jx repo --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Approving The Pull Request

* Comment `/close`
* Comment `/reopen`
* Comment `/meow`
* Comment `/lgtm`


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Promoting To Production

```bash
jx get applications

export VERSION=[...]

jx promote jx-serverless --version $VERSION --env production \
    --batch-mode

open "https://github.com/$GH_USER/environment-tekton-production"

jx get applications

export PROD_ADDR=[...]
```


<!-- .slide: class="dark" -->
<div class="eyebrow"></div>
<div class="label">Hands-on Time</div>

## Promoting To Production

```bash
curl $PROD_ADDR

cd ..
```

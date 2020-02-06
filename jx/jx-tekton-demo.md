## Hands-On Time

---

# Running Serverless CD


## Where Is Jenkins?

---

```bash
kubectl get pods

kubectl top pods
```


## Starting A New Project

---

```bash
jx create quickstart --language go --project-name jx-serverless \
    --batch-mode

cd jx-serverless

ls -1

cat Dockerfile

ls -1 charts/jx-serverless

cat skaffold.yaml

cat jenkins-x.yml
```


## Starting A New Project

---

```bash
kubectl get pods --watch

jx get activities --filter jx-serverless --watch

jx get applications
```


## Defining Owners

---

```bash
GH_USER=[...]

GH_APPROVER=[...]

echo "approvers:
- $GH_USER
- $GH_APPROVER
reviewers:
- $GH_USER
- $GH_APPROVER" \
    | tee OWNERS

git commit -am "Added the other me"

git push

jx repo --batch-mode
```


## Creating A Pull Request

---

```bash
git checkout -b my-pr

echo "I'm lazy" | tee README.md

git add .

git commit -m "My first PR with serverless jx"

git push --set-upstream origin my-pr

jx create pullrequest --title "My PR" --body "What I can say?" \
    --batch-mode
```


## Approving The Pull Request

---

* Comment `/close`
* Comment `/reopen`
* Comment `/meow`
* Comment `/lgtm`


## Promoting To Production

---

```bash
jx get applications

VERSION=[...]

jx promote jx-serverless --version $VERSION --env production \
    --batch-mode

open "https://github.com/$GH_USER/environment-tekton-production"

jx get applications

PROD_ADDR=[...]

open "$PROD_ADDR"
```

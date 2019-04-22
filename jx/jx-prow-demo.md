## Hands-On Time

---

# Implementing ChatOps


## The Basic PR Process

---

```bash
jx create quickstart -l go -p jx-prow -b

cd jx-prow

jx get activities -f jx-prow -w

git checkout -b chat-ops

echo "ChatOps" | tee README.md

git add .

git commit -m "My first PR with prow"

git push --set-upstream origin chat-ops

jx create pr -t "PR with prow" --body "What I can say?" -b
```

* Open the link from the output


## The Basic PR Process

---

* Type the text and press the *Comment* button

```
/assign

This PR is urgent, so please review it ASAP
```

* Type `/unassign` and click the *Comment* button
* Type `/assign @GH_USER` and click the *Comment* button
* Type `/lgtm` and click the *Comment* button
* Type `/unassign` and click the *Comment* button


## The Basic PR Process

---

```bash
git checkout master

cat OWNERS

GH_USER=[...]

GH_APPROVER=[...]

echo "approvers:
- $GH_USER
- $GH_APPROVER
reviewers:
- $GH_USER
- $GH_APPROVER
" | tee OWNERS
```


## The Basic PR Process

---

```bash
git add .

git commit -m "Added an owner"

git push

open "https://github.com/$GH_USER/jx-prow/settings/collaboration"
```

* Type `/assign @GH_APPROVER` and click the *Comment* button
* As the approver, type `/approve` and click the *Comment* button


## Additional Slash Commands

---

```bash
git checkout master

git pull

git checkout -b my-pr

echo "My PR" | tee README.md

git add .

git commit -m "My second PR with prow"

git push --set-upstream origin my-pr

jx create pr -t "My PR" --body "What I can say?" -b
```


## Additional Slash Commands

---

* Comment `/hold`
* Comment `/hold cancel`
* Comment `/close`
* Comment `/reopen`
* Comment `/lifecycle frozen`
* Comment `/lifecycle stale`
* Comment `/lifecycle rotten`
* Comment `/remove-lifecycle stale`
* Comment `/meow`
* As the approver, comment `/lgtm`


## Available Slash Commands

---

```bash
kubectl -n cd describe cm plugins
```

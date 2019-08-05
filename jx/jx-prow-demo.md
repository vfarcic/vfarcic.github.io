<!-- .slide: class="center dark" -->
<!-- .slide: data-background="img/hands-on.jpg" -->
# Implementing ChatOps

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## The Basic PR Process

```bash
jx create quickstart --filter golang-http --project-name jx-prow \
    --batch-mode

cd jx-prow

git checkout -b chat-ops

echo "ChatOps" | tee README.md

git add . && git commit -m "My first PR with prow"

git push --set-upstream origin chat-ops
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## The Basic PR Process

```bash
jx create pr --title "PR with prow" --body "What I can say?" \
    --batch-mode
```

* Open the link from the output
* Type the text and click *Comment*

```
This PR is urgent, so please review it ASAP

/assign
```

* Type `/lgtm` and click *Comment*
* Type `/unassign` and click *Comment*


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## The Basic PR Process

```bash
git checkout master

cat OWNERS

GH_USER=[...]

GH_APPROVER=[...]
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## The Basic PR Process

```bash
echo "approvers:
- $GH_USER
- $GH_APPROVER
reviewers:
- $GH_USER
- $GH_APPROVER
" | tee OWNERS

git add . && git commit -m "Added an owner" && git push

open "https://github.com/$GH_USER/jx-prow/settings/collaboration"
```

* Add the new collaborator, confirm it, and go back to the PR
* Type `/assign @GH_APPROVER` and click *Comment*
* As the approver, type `/approve` and click *Comment*


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## Additional Slash Commands

```bash
git checkout master && git pull

git checkout -b my-pr

echo "My PR" | tee README.md

git add . && git commit -m "My second PR with prow"

git push --set-upstream origin my-pr

jx create pr --title "My PR" --body "What I can say?" --batch-mode
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## Additional Slash Commands

* Comment `/hold`
* Comment `/hold cancel`
* Comment `/close`
* Comment `/reopen`
* Comment `/lifecycle frozen`
* Comment `/lifecycle stale`
* Comment `/lifecycle rotten`
* Comment `/remove-lifecycle rotten`
* Comment `/meow`
* As the approver, comment `/lgtm`


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 9</div>
<div class="label">Hands-on Time</div>

## Available Slash Commands

```bash
kubectl -n $NAMESPACE describe cm plugins

cd ..
```

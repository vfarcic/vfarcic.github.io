## Hands-On Time

---

# Working With Pull Requests And Preview Environments


## In case you messed it up

---

```bash
cd go-demo-6

git pull

git checkout dev

git merge -s ours master --no-edit

git checkout master

git merge dev

echo "buildPack: go" | tee jenkins-x.yml

git add . && git commit -m "Added jenkins-x.yml"

git push
```


<!-- .slide: data-background="img/pr.png" data-background-size="contain" -->


## Creating Pull Requests

---

```bash
git checkout -b my-new-pr

cat main.go | sed -e "s@hello, devpod with tests@hello, PR@g" \
    | tee main.go

cat main_test.go | sed -e "s@hello, devpod with tests@hello, PR@g" \
    | tee main_test.go

echo "

db:
  enabled: false
  
preview-db:
  persistence:
    enabled: false" | tee -a charts/preview/values.yaml
```


## Creating Pull Requests

---

```bash
git add .

git commit -m "This is a PR"

git push --set-upstream origin my-new-pr

jx create pullrequest \
    --title "My PR" \
    --body "This is the text that describes the PR" \
    --batch-mode
```

* Open the link


## Creating Pull Requests

---

```bash
jx get previews

PR_ADDR=[...]

curl "$PR_ADDR/demo/hello"
```


## Merging a PR

---

* Open the pull request screen in GitHub
* Click *Merge pull request* button
* Click the *Confirm merge* button.

```bash
jx get activity -f go-demo-6 -w

jx get applications

STAGING_ADDR=[...] # Replace `[...]` with the URL

curl "$STAGING_ADDR/demo/hello"
```


## jx Garbage Collection

---

```bash
kubectl get cronjobs

jx get previews

jx gc previews

jx get previews
```

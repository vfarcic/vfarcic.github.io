## Hands-On Time

---

# Creating And Previewing Pull Requests


## Creating a PR

---

```bash
cd jx-go

git checkout -b my-pr

cat main.go | sed -e "s@http example@http PR@g" | tee main.go

git add . && git commit -m "This is a PR"

git push --set-upstream origin my-pr

open "https://github.com/$GH_USER/jx-go/pull/new/my-pr"
```

* Click the `Create pull request` button


## Creating a PR

---

```bash
jx get activity -f jx-go -w

helm ls

PR=[...]

PREVIEW_ADDR=$(kubectl -n jx-vfarcic-jx-go-pr-$PR \
    get ing jx-go -o jsonpath="{.spec.rules[0].host}")

curl "http://$PREVIEW_ADDR"

jx get build log $GH_USER/jx-go/PR-$PR
```


## Merging a PR

---

```bash
open "https://github.com/$GH_USER/jx-go/pull/$PR"
```

* Click the *Merge pull request* button
* Click the *Confirm merge* button

```bash
jx get activity -f jx-go/master -w

curl "http://$STAGING_ADDR"
```

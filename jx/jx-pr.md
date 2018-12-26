## Exploring The Jenkinsfile

---

```bash
cat Jenkinsfile
```


## Creating a PR

---

```bash
git checkout -b my-pr

cat main.go | sed -e "s@hello, world@hello, PR@g" | tee main.go

git add . && git commit -m "This is a PR"

git push --set-upstream origin my-pr

open "https://github.com/$GH_USER/go-demo-6/pull/new/my-pr"
```

* Click the `Create pull request` button

```bash
jx get activity -f go-demo-6 -w

URL=[...] # Copy the address from `Preview Application`

curl "$URL/demo/hello"

helm ls

jx get build log
```


# Something

---

TODO: Add `rollout status`

```bash
# TODO: open "https://github.com/$GH_USER/go-demo-6/blob/master/Makefile"
```

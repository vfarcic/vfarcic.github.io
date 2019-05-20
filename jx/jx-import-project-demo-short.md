## Hands-On Time

---

# Importing Existing Projects Into Jenkins X


## Importing A Project

---

```bash
open "https://github.com/vfarcic/go-demo-6"
```

* Fork it.

```bash
GH_USER=[...]

git clone https://github.com/$GH_USER/go-demo-6.git

cd go-demo-6
```


## Importing A Project

---

```bash
git checkout orig

git merge -s ours master --no-edit

git checkout master

git merge orig

rm -rf charts

git push

jx import --batch-mode

ls -1
```


## Importing A Project

---

```bash
jx get activities --filter go-demo-6 --watch # Stop with *ctrl*c*

jx get applications

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

kubectl --namespace cd-staging logs -l app=jx-go-demo-6
```


## Fixing The Helm Chart

---

```bash
git checkout buildpack

git merge -s ours master --no-edit

git checkout master

git merge buildpack

git push

jx get activities --filter go-demo-6 --watch # Stop with *ctrl*c*

curl "$STAGING_ADDR/demo/hello"
```

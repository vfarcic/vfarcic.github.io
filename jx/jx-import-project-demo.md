## Hands-On Time

---

# Importing Existing Projects Into Jenkins X


## Importing A Project

---

```bash
open "https://github.com/vfarcic/go-demo-6"
```

* Fork the repo

```
cd ..

git clone https://github.com/$GH_USER/go-demo-6.git

cd go-demo-6
```


## Importing A Project

---

```bash
git checkout orig

git merge -s ours master

git checkout master

git merge orig

rm -rf charts

git push

jx import --pack go -b
```


## Importing A Project

---

```bash
jx get activity -f go-demo-6 -w
```

* Stop the watch with `ctrl+c`
* Open the `PullRequest` link
* Open the `Update` link

```bash
STAGING_URL=[PROMOTED]/demo/hello

curl $STAGING_URL
```

* Got `505`

```bash
kubectl -n jx-staging logs -l app=jx-staging-go-demo-6

kubectl -n jx-staging get pods

helm ls
```


## Adding Dependencies

---

```bash
vim charts/go-demo-6/templates/deployment.yaml
```

* Add the code that follows to the container

```yaml
        env:
        - name: DB
          value: {{ template "fullname" . }}-db
```

* Save and exit with `:wq`

```bash
cat charts-orig/go-demo-6/templates/sts.yaml

cp charts-orig/go-demo-6/templates/sts.yaml \
  charts/go-demo-6/templates/

cp charts-orig/go-demo-6/templates/rbac.yaml \
  charts/go-demo-6/templates/
```


## Adding Dependencies

---

```bash
echo "
---
" | tee -a charts/go-demo-6/templates/service.yaml

cat charts-orig/go-demo-6/templates/service.yaml \
  | tee -a charts/go-demo-6/templates/service.yaml

git add . && git commit -m "Added dependencies" && git push

jx get activity -f go-demo-6 -w
```

* Promotion failed

```bash
kubectl -n jx-staging get pods

kubectl -n jx-staging describe pod -l app=jx-staging-go-demo-6
```


## Updating Values

---

```bash
vim charts/go-demo-6/values.yaml
```

* Change `probePath` value to `/demo/hello?health=true`

```bash
git add . && git commit -m "Added dependencies" && git push

jx get activity -f go-demo-6 -w

kubectl -n jx-staging get pods

kubectl -n jx-staging describe pod -l app=jx-staging-go-demo-6

curl $STAGING_URL
```

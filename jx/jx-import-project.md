## Importing A Project

---

```bash
open "https://github.com/vfarcic/go-demo-6"

# Fork it

cd ..

git clone https://github.com/$GH_USER/go-demo-6.git

cd go-demo-6

git checkout master

jx import
```


## Importing A Project

---

```bash
jx get activity -f go-demo-6 -w
```

* Stop the watch with `ctrl+c`
* Open the `PullRequest` link
* Open the `Update` link

```
STAGING_URL=[PROMOTED]/demo/hello

curl $STAGING_URL

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
          value: {{ template "helm.fullname" . }}-db
```

```bash
cat charts/go-demo-6-orig/templates/sts.yaml

cp charts/go-demo-6-orig/templates/sts.yaml \
  charts/go-demo-6/templates/

cp charts/go-demo-6-orig/templates/rbac.yaml \
  charts/go-demo-6/templates/

cat charts/go-demo-6-orig/templates/service.yaml \
  | tee -a charts/go-demo-6/templates/service.yaml

git add . && git commit -m "Added dependencies" && git push
```


## Adding Dependencies

---

```bash
jx get activity -f go-demo-6 -w

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

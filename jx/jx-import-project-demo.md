## Hands-On Time

---

# Importing Existing Projects Into Jenkins X


## Importing A Project

---

```bash
open "https://github.com/vfarcic/go-demo-6"

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

jx repo -b

ls -1
```


## Importing A Project

---

```bash
jx import -b

ls -1

jx get activities -f go-demo-6 -w

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

kubectl -n jx-staging logs -l app=jx-staging-go-demo-6
```


## Fixing The Helm Chart

---

```bash
vi charts/go-demo-6/templates/deployment.yaml
```

* Press `i` to enter into the insert mode
* Locate the code that follows

```yaml
...
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
...
```

* Add the `env` section as in the following snippet

```yaml
...
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        env:
        - name: DB
          value: {{ template "fullname" . }}-db
        ports:
...
```


## Fixing The Helm Chart

---

* Exit the insert mode by pressing the `ecs` key
* Save the changes by typing `:wq` and pressing enter

```bash
echo "dependencies:
- name: mongodb
  alias: go-demo-6-db
  version: 5.3.0
  repository:  https://kubernetes-charts.storage.googleapis.com
" | tee charts/go-demo-6/requirements.yaml

echo "go-demo-6-db:
  replicaSet:
    enabled: true
" | tee -a charts/go-demo-6/values.yaml
```


## Fixing The Helm Chart

---

```bash
git add .

git commit -m "Added dependencies"

git push

jx get activity -f go-demo-6 -w
```

* Stop watching with `ctrl+c`

```bash
kubectl -n jx-staging get pods

kubectl -n jx-staging describe pod -l app=jx-staging-go-demo-6
```


## Fixing The Helm Chart

---

```bash
vi charts/go-demo-6/values.yaml
```

* Press `i` to enter into the insert mode
* Locate the code that follows

```yaml
...
probePath: /
...
```

* Change to the code that follows

```yaml
...
probePath: /demo/hello?health=true
...
```


## Fixing The Helm Chart

---

```bash
git add .

git commit -m "Added dependencies"

git push

jx get activity -f go-demo-6 -w

kubectl -n jx-staging get pods

curl "$STAGING_ADDR/demo/hello"
```

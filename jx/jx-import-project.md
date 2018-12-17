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
```


## Adding Dependencies

---

* Create `charts/go-demo-6/requirements.yaml`
* And add the code that follows

```yaml
dependencies:
- alias: db
  name: mongodb
  repository: https://kubernetes-charts.storage.googleapis.com
  version: 4.10.1
```

```bash
git add . && git commit -m "Added dependencies" && git push

jx get activity -f go-demo-6 -w
```

* Stop the watch with `ctrl+c`


## Adding Dependencies

---

```bash
vim charts/go-demo-6/deployment.yaml
```

* Add the code that follows to the only container

```yaml
        env:
        - name: DB
          value: {{ .Release.Name }}-db
```

```bash
git add . && git commit -m "Added dependencies" && git push

jx get activity -f go-demo-6 -w
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
```


## Something Else

---

```bash
jx get build logs vfarcic/go-demo-6/master

jx console

jx get pipelines

jx get applications
```


## Cleanup

---

```bash
# Delete the cluster

# Delete the LB

# Delete the environment repos

# Delete the golang-http repo

rm -rf golang-http
```
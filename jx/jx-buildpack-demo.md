## Hands-On Time

---

# Creating Custom Buildpacks


## Buildpack For Go With MongoDB

---

```bash
open "https://github.com/jenkins-x-buildpacks/jenkins-x-kubernetes"

# Fork it!

GH_USER=[...]

git clone https://github.com/$GH_USER/jenkins-x-kubernetes

cd jenkins-x-kubernetes

ls -1 packs

ls -1 packs/go

cp -R packs/go packs/go-mongo
```


## Buildpack For Go With MongoDB

---

```bash
cat packs/go-mongo/charts/templates/deployment.yaml | sed -e \
    's@ports:@env:\
        - name: DB\
          value: {{ template "fullname" . }}-db\
        ports:@g' \
    | tee packs/go-mongo/charts/templates/deployment.yaml

echo "dependencies:
- name: mongodb
  alias: REPLACE_ME_APP_NAME-db
  version: 5.3.0
  repository:  https://kubernetes-charts.storage.googleapis.com
" | tee packs/go-mongo/charts/requirements.yaml
```


## Buildpack For Go With MongoDB

---

```bash
echo "REPLACE_ME_APP_NAME-db:
  replicaSet:
    enabled: true
" | tee -a packs/go-mongo/charts/values.yaml
```


## Buildpack For Go With MongoDB

---

```bash
ls -1 packs/go-mongo/preview

cat packs/go-mongo/preview/requirements.yaml

cat packs/go-mongo/preview/requirements.yaml \
    | sed -e \
    's@  # !! "alias@- name: mongodb\
  alias: preview-db\
  version: 5.3.0\
  repository:  https://kubernetes-charts.storage.googleapis.com\
\
  # !! "alias@g' \
    | tee packs/go-mongo/preview/requirements.yaml

echo '
' | tee -a packs/go-mongo/preview/requirements.yaml 
```


## Buildpack For Go With MongoDB

---

```bash
git add .

git commit -m "Added go-mongo buildpack"

git push

jx edit buildpack \
    -u https://github.com/$GH_USER/jenkins-x-kubernetes \
    -r master -b
```


## Testing The New Buildpack

---

```bash
cd ..

cd go-demo-6

jx delete application $GH_USER/go-demo-6 -b

kubectl -n jx delete act -l owner=$GH_USER \
  -l sourcerepository=go-demo-6
```


## Testing The New Buildpack

---

```bash
git checkout orig

git merge -s ours master --no-edit

git checkout master

git merge orig

rm -rf charts

git push

jx import --pack go-mongo -b

ls -1 \
  ~/.jx/draft/packs/github.com/$GH_USER/jenkins-x-kubernetes/packs
```


## Testing The New Buildpack

---

```bash
jx get activity -f go-demo-6 -w

kubectl -n jx-staging get pods

kubectl -n jx-staging describe pod -l app=jx-staging-go-demo-6

cat charts/go-demo-6/values.yaml

cat charts/go-demo-6/values.yaml | sed -e \
    's@probePath: /@probePath: /demo/hello?health=true@g' \
    | tee charts/go-demo-6/values.yaml

echo '
  probePath: /demo/hello?health=true' \
    | tee -a charts/preview/values.yaml
```


## Testing The New Buildpack

---

```bash
git add .

git commit -m "Fixed the probe"

git push

jx get activity -f go-demo-6 -w

kubectl -n jx-staging get pods

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"
```

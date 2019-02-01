## Hands-On Time

---

# Creating Buildpacks


## Creating Buildpacks

---

```bash
PACKS_PATH="$HOME/.jx/draft/packs/github.com/jenkins-x-buildpacks/jenkins-x-kubernetes/packs"

ls -1 $PACKS_PATH

ls -1 $PACKS_PATH/go

cp -R $PACKS_PATH/go $PACKS_PATH/go-mongo
```


## Creating Buildpacks

---

```bash
cat $PACKS_PATH/go-mongo/charts/templates/deployment.yaml \
    | sed -e 's@ports:@env:\
        - name: DB\
          value: {{ template "fullname" . }}-db\
        ports:@g' \
    | tee $PACKS_PATH/go-mongo/charts/templates/deployment.yaml

echo "dependencies:
- name: mongodb
  alias: REPLACE_ME_APP_NAME-db
  version: 5.3.0
  repository:  https://kubernetes-charts.storage.googleapis.com
" | tee $PACKS_PATH/go-mongo/charts/requirements.yaml
```


## Creating Buildpacks

---

```bash
echo "REPLACE_ME_APP_NAME-db:
  replicaSet:
    enabled: true
" | tee -a $PACKS_PATH/go-mongo/charts/values.yaml
```


## Creating Buildpacks

---

```bash
ls -1 $PACKS_PATH/go-mongo/preview

cat $PACKS_PATH/go-mongo/preview/requirements.yaml

cat $PACKS_PATH/go-mongo/preview/requirements.yaml \
    | sed -e \
    's@  # !! "alias@- name: mongodb\
  alias: preview-db\
  version: 5.3.0\
  repository:  https://kubernetes-charts.storage.googleapis.com\
\
  # !! "alias@g' \
    | tee $PACKS_PATH/go-mongo/preview/requirements.yaml
```


## Creating Buildpacks

---

```bash
jx delete application $GH_USER/go-demo-6 -b

git checkout orig

git merge -s ours master --no-edit

git checkout master

git merge orig

rm -rf charts

git push
```


## Creating Buildpacks

---

```bash
jx import --pack go-mongo -b

jx get activity -f go-demo-6 -w

kubectl -n jx-staging get pods

kubectl -n jx-staging describe pod -l app=jx-staging-go-demo-6
```


## Creating Buildpacks

---

```bash
cat charts/go-demo-6/values.yaml | sed -e \
    's@probePath: /@probePath: /demo/hello?health=true@g' \
    | tee charts/go-demo-6/values.yaml

cat charts/preview/values.yaml

echo '
  probePath: /demo/hello?health=true' \
    | tee -a charts/preview/values.yaml

git add .

git commit -m "Fixed the probe"

git push
```


## Creating Buildpacks

---

```bash
jx get activity -f go-demo-6 -w

kubectl -n jx-staging get pods

curl "$STAGING_ADDR/demo/hello"
```

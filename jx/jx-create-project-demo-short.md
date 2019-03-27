## Hands-On Time

---

# Creating A Quickstart Project


## Creating A Project

---

```bash
jx create quickstart -l go -p jx-go -b

export GH_USER=[...] # Replace with your GitHub user

open "https://github.com/$GH_USER/jx-go"

ls -l jx-go

cat jx-go/Dockerfile

cat jx-go/jenkins-x.yml

cat jx-go/Makefile
```


## Creating A Project

---

```bash
cat jx-go/skaffold.yaml

ls -l jx-go/charts

ls -l jx-go/charts/jx-go

ls -l jx-go/charts/preview

open "https://github.com/$GH_USER/jx-go/settings/hooks"
```


## Browsing The Project

---

```bash
kubectl get pods

jx get activities

jx get activities -f jx-go -w # Cancel with ctrl+c

jx get build logs # Cancel with ctrl+c

jx get build logs -f jx-go # Cancel with ctrl+c

jx get build logs $GH_USER/jx-go/master
```


## Browsing The Project

---

```bash
jx get pipelines

jx get applications

jx get env

jx get applications -e staging

open "https://github.com/$GH_USER/jx-go/releases"

STAGING_ADDR=$(kubectl -n jx-staging get ing jx-go \
    -o jsonpath="{.spec.rules[0].host}")

curl "http://$STAGING_ADDR"
```

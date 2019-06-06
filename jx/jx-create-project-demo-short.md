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

jx get activities --filter jx-go --watch # Cancel with ctrl+c

jx get build logs --filter jx-go
```


## Browsing The Project

---

```bash
jx get pipelines

jx get env

jx get applications -e staging

open "https://github.com/$GH_USER/jx-go/releases"

jx get applications

STAGING_ADDR=[...]

curl "$STAGING_ADDR"
```


<!-- .slide: data-background="../img/background/developer.jpeg" -->
## You Do NOT Need To Do Any Of That

---

# Focus On What You Should Do
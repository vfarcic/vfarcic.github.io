# Cleanup

---

```bash
gcloud container clusters delete $NAME --zone $ZONE --quiet

gcloud compute disks delete $(gcloud compute disks list \
    --filter="-users:*" --format="value(id)")
```


# Cleanup

---

```bash
hub delete -y $GH_USER/environment-jx-rocks-staging

hub delete -y $GH_USER/environment-jx-rocks-production

hub delete -y $GH_USER/jx-go

git checkout master

git branch -d my-pr

rm -rf ~/.jx/environments/$GH_USER/environment-jx-rocks-*
```


# Cleanup

---

```bash
cd ..

rm -rf jx-go

rm -rf environment-jx-rocks-staging

rm -rf environment-jx-rocks-production

rm -f ~/.jx/jenkinsAuth.yaml
```

# Cleanup

---

```bash
gcloud container clusters delete jx-rocks --zone us-east1-b --quiet

gcloud compute disks delete $(gcloud compute disks list \
    --filter="-users:*" --format="value(id)")
```


# Cleanup

---

```bash
hub delete -y $GH_USER/environment-jx-rocks-staging

hub delete -y $GH_USER/environment-jx-rocks-production

hub delete -y $GH_USER/jx-go

rm -rf ~/.jx/environments/$GH_USER/environment-jx-rocks-*

cd ..

rm -rf jx-go

rm -rf environment-jx-rocks-*

rm -f ~/.jx/jenkinsAuth.yaml
```

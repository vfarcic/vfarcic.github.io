## Cleanup

---

```bash
gcloud container clusters delete jx-rocks --region us-east1 --quiet

gcloud compute disks delete --zone us-east1-b $(gcloud compute disks \
    list --filter="zone:us-east1-b AND -users:*" \
    --format="value(id)") --quiet
gcloud compute disks delete --zone us-east1-c $(gcloud compute disks \
    list --filter="zone:us-east1-c AND -users:*" \
    --format="value(id)") --quiet
gcloud compute disks delete --zone us-east1-d $(gcloud compute disks \
    list --filter="zone:us-east1-d AND -users:*" \
    --format="value(id)") --quiet
```


## Cleanup

---

```bash
hub delete -y $GH_USER/environment-tekton-staging

hub delete -y $GH_USER/environment-tekton-production

hub delete -y $GH_USER/jx-knative

hub delete -y $GH_USER/jx-recreate

hub delete -y $GH_USER/jx-rolling

hub delete -y $GH_USER/jx-canary

hub delete -y $GH_USER/jx-go
```


## Cleanup

---

```bash
cd ..

rm -rf jx-knative

rm -rf jx-recreate

rm -rf jx-rolling

rm -rf jx-canary

rm -rf jx-go

rm -rf ~/.jx/environments/$GH_USER/environment-tekton-*
```

<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

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


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
hub delete -y $GH_USER/environment-tekton-staging

hub delete -y $GH_USER/environment-tekton-production

hub delete -y $GH_USER/jx-knative

hub delete -y $GH_USER/jx-recreate

hub delete -y $GH_USER/jx-rolling

hub delete -y $GH_USER/jx-canary
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
rm -rf jx-knative

rm -rf jx-recreate

rm -rf jx-rolling

rm -rf jx-canary

rm -rf ~/.jx/environments/$GH_USER/environment-tekton-*
```

<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
gcloud container clusters delete chaos --region us-east1 --quiet \
    --project $PROJECT_ID
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
# Remove unused disks to avoid reaching the quota (and save a bit of money)
gcloud compute disks delete --project $PROJECT_ID --zone us-east1-b \
    $(gcloud compute disks list --filter="zone:us-east1-b AND -users:*" \
    --format="value(id)" --project $PROJECT_ID)
gcloud compute disks delete --project $PROJECT_ID --zone us-east1-c \
    $(gcloud compute disks list --filter="zone:us-east1-b AND -users:*" \
    --format="value(id)" --project $PROJECT_ID)
gcloud compute disks delete --project $PROJECT_ID --zone us-east1-d \
    $(gcloud compute disks list --filter="zone:us-east1-b AND -users:*" \
    --format="value(id)" --project $PROJECT_ID)
```

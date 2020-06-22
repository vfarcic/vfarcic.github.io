<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
rm -rf jx-infra

rm -rf jenkins-x-boot-config
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
hub delete -y $GH_USER/jx-infra

hub delete -y $GH_USER/environment-jenkins-x-staging

hub delete -y $GH_USER/environment-jenkins-x-production

hub delete -y $GH_USER/environment-jenkins-x-dev

gcloud projects delete $PROJECT_ID
```

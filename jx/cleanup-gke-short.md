<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
gcloud projects delete $PROJECT_ID

rm -rf jx-infra
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
hub delete -y $GH_USER/environment-jenkins-x-staging

hub delete -y $GH_USER/environment-jenkins-x-production

hub delete -y $GH_USER/environment-jenkins-x-dev

hub delete -y $GH_USER/jx-go

hub delete -y $GH_USER/jx-serverless

hub delete -y $GH_USER/jx-prow
```


<!-- .slide: class="center" -->
<!-- .slide: data-background="data-background="linear-gradient(to bottom right, rgba(25,151,181,0.8), rgba(87,185,72,0.8)), url(../img/background/cleanup.jpg) center / cover" -->
## Cleanup

```bash
hub delete -y $GH_USER/jx-knative

rm -rf jx-go

rm -rf jx-serverless

rm -rf jx-prow

rm -rf jx-knative

rm -rf environment-jenkins-x-*

rm -rf jenkins-x-boot-config
```

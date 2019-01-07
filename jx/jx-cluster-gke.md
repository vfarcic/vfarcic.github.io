## Hands-On Time

---

### Creating A
# Jenkins-X
## Cluster


<!-- .slide: data-background="../img/background/why.jpg" -->
### How long does it take to create a
## fully operational 
## and secure cluster,
## that is fault tollerant,
# with autoscaling,
## and with all the
## CD software pre-installed?


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/)
* [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) and GCP admin permissions


## Creating A Cluster With jx

---

```bash
PROJECT=[...] # e.g. devops24-book

NAME=jx-rocks && ZONE=us-east1-b && MACHINE=n1-standard-2

MIN_NODES=3 && MAX_NODES=5 && PASS=admin

jx create cluster gke -n $NAME -p $PROJECT -z $ZONE -m $MACHINE \
    --min-num-nodes $MIN_NODES --max-num-nodes $MAX_NODES \
    --default-admin-password=$PASS -b

jx console
```

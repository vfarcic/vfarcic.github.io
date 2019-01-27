## Hands-On Time

---

### Creating A
# Jenkins-X
## Cluster


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
open "https://console.cloud.google.com/cloud-resource-manager"

PROJECT=[...] # e.g. devops24-book

NAME=jx-rocks && ZONE=us-east1-b && MACHINE=n1-standard-2

MIN_NODES=3 && MAX_NODES=5 && PASS=admin

echo "nexus:
  enabled: false
" | tee myvalues.yaml
```


## Creating A Cluster With jx

---

```bash
jx create cluster gke -n $NAME -p $PROJECT -z $ZONE -m $MACHINE \
    --min-num-nodes $MIN_NODES --max-num-nodes $MAX_NODES \
    --default-admin-password=$PASS \
    --default-environment-prefix jx-rocks

jx console
```

* Use `admin` as the username and password

```bash
kubectl -n jx get pods
```

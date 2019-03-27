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

echo "nexus:
  enabled: false
" | tee myvalues.yaml
```


## Creating A Cluster With jx

---

```bash
jx create cluster gke -n jx-rocks -p $PROJECT -z us-east1-b \
    -m n1-standard-2 --min-num-nodes 3 --max-num-nodes 5 \
    --default-admin-password=admin \
    --default-environment-prefix jx-rocks \
    --prow --tekton --no-tiller

kubectl -n jx get pods
```

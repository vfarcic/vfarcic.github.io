### Creating A
# Jenkins-X
## Cluster

---

```bash
PROJECT=[...] # e.g. devops26

jx create cluster gke -n jx-rocks -p $PROJECT -r us-east1 \
    -m n1-standard-2 --min-num-nodes 1 --max-num-nodes 2 \
    --default-admin-password=admin --default-environment-prefix tekton \
    --git-provider-kind github --namespace cd --prow --tekton -b
```

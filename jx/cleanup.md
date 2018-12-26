# Cleanup

---

```bash
# If GKE
gcloud container clusters delete $NAME --region $REGION --quiet

# If AKS
# TODO: Delete LB

# If AKS
eksctl delete cluster -n $NAME
```


# Cleanup

---

```bash
# Delete the environment repos

# Delete the my-pr branch

# Delete the golang-http repo

rm -rf ~/.jx/environments/vfarcic/environment-jx-rocks-production

rm -rf ~/.jx/environments/vfarcic/environment-jx-rocks-staging
```

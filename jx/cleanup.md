# Cleanup

---

```bash
# If GKE
gcloud container clusters delete $NAME --region $REGION --quiet

# If AKS
# TODO: Delete LB

# If AKS
eksctl delete cluster -n $NAME

# If minikube
minikube delete
```


# Cleanup

---

```bash
# Delete the environment repos

# Delete the PR branches

# Delete the golang-http repo

rm -rf ~/.jx/environments/$GH_USER/environment-jx-rocks-*

rm -f ~/.jx/jenkinsAuth.yaml
```

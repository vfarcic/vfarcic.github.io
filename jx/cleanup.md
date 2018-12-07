# Cleanup

```bash
# If GKE
gcloud container clusters delete $NAME --region $REGION --quiet

# If AKS
eksctl delete cluster -n $NAME
```

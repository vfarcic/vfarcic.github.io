## Cleanup

```bash
rm apps/*.yaml

git add .

git commit -m "Destroy"

git push

kubectl get managed

# Wait until all the managed resources are removed

# Destroy or reset the Kubernetes cluster
```

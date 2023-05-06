# User-Friendly Interfaces


<!-- .slide: data-background-image="../img/products/crossplane.png" data-background-size="contain" -->


# Crossplane

```bash
kubectl get crds | grep devopstoolkitseries

kubectl explain appclaims.devopstoolkitseries.com --recursive

cat crossplane/app.yaml

# kubectl --namespace production apply \
#     --filename crossplane/app.yaml
```


# Checklist

* ~Control plane~
* ~User-friendly interfaces~
* Syncronization From Git With GitOps
* Schema management
* Secrets management
* Graphical User Interface (GUI)
* CI/CD Pipeline

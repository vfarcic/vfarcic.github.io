# Secrets Management


<!-- .slide: data-background-image="../img/products/external-secrets.webp" data-background-size="contain" -->


## External Secrets Operator (ESO)

```bash
cp argocd/external-secrets.yaml infra/.

git add . && git commit -m "External Secrets" && git push

# Wait for a few moments for Argo CD to sync...

cp eso/secret-store-$HYPERSCALER.yaml infra/.

git add . && git commit -m "External Secrets Store" && git push
```


# Checklist

* ~Control plane~
* ~User-friendly interfaces~
* ~Syncronization From Git With GitOps~
* ~Schema management~
* ~Secrets management~
* Graphical User Interface (GUI)
* CI/CD Pipeline

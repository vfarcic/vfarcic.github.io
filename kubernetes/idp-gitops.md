# Syncronization From Git With GitOps


<!-- .slide: data-background-image="../img/products/argo.png" data-background-size="contain" -->


# Argo CD

```bash
helm upgrade --install argocd argo-cd \
    --repo https://argoproj.github.io/argo-helm \
    --namespace argocd --create-namespace \
    --values argocd/helm-values.yaml --wait

echo "http://gitops.$INGRESS_HOST.nip.io"

# Open the URL in a browser

# Use `admin` as the user and `admin123` as the password.

kubectl apply --filename argocd/project.yaml

kubectl apply --filename argocd/apps.yaml
```


# Checklist

* ~Control plane~
* ~User-friendly interfaces~
* ~Syncronization From Git With GitOps~
* Schema management
* Secrets management
* Graphical User Interface (GUI)
* CI/CD Pipeline

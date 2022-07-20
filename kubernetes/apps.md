<!-- .slide: data-background-image="../img/products/kubernetes.png" data-background-opacity="0.2" data-background-size="contain" -->
## Kubernetes

# Manage Applications


# Manage Applications

```bash
kubectl --namespace production apply --filename silly-demo/

kubectl --namespace production get all
```


<!-- .slide: data-background="img/what/apps.png" data-background-size="contain" -->


# Manage Applications

```bash
yq --inplace \
    ".spec.template.spec.containers[0].image = \"vfarcic/silly-demo:1.0.7\"" \
    silly-demo/deployment.yaml

kubectl --namespace production apply --filename silly-demo/

watch kubectl --namespace production get all
```


<!-- .slide: data-background="img/what/apps-update-01.png" data-background-size="contain" -->


<!-- .slide: data-background="img/what/apps-update-02.png" data-background-size="contain" -->


<!-- .slide: data-background="img/what/apps-update-03.png" data-background-size="contain" -->

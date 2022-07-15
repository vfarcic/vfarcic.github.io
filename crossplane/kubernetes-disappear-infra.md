<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Infra For Devs

## Hands-on Time


## Infra For Devs

```bash
# Open the Upbound control plane

# Create a new `ClusterClaim` with the following values:
# - metadata.name = a-team-eks
# - metadata.namespace = upbound-system
# - spec.id = a-team-eks
# - spec.parameters.nodeSize = medium
# - spec.compositionSelector.matchLabels[0] = provider=aws
# - spec.compositionSelector.matchLabels[1] = cluster=eks
# - spec.parameters.minNodeCount = 3
# - spec.writeConnectionSecretToRef.name = a-team-eks

# Click the `Continue` button
```


## Infra For Devs

```bash
# Create a new `GitOpsClaim` with the following values:
# - metadata.name = a-team-gitops
# - metadata.namespace = upbound-system
# - spec.id = a-team-gitops
# - spec.parameters.kubeConfig.secretName = a-team-eks
# - spec.compositionSelector.matchLabels[0] = provider=argo
# - spec.parameters.gitOpsRepo = https://github.com/vfarcic/devops-toolkit-crossplane.git
# - spec.parameters.kubeConfig.secretNamespace = upbound-system

# Click the `Continue` button
```


## Infra For Ops

```bash
kubectl get managed

cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml

cat packages/gitops/definition.yaml

cat packages/gitops/argo-cd.yaml
```


## Infra For Ops

```bash
kubectl --namespace upbound-system get secret a-team-eks \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

kubectl --kubeconfig kubeconfig.yaml get namespaces

kubectl --kubeconfig kubeconfig.yaml --namespace argocd \
    get applications

kubectl --kubeconfig kubeconfig.yaml --namespace argocd \
    port-forward svc/a-team-gitops-argocd-server \
    8080:443 &
```


## Infra For Devs

```bash
# Open http://localhost:8080 in a browser

# User `admin`, password `admin123`
```


<!-- .slide: data-background="../img/products/crossplane.png" data-background-size="contain" -->
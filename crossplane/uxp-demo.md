<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Demo

<div class="label">Hands-on Time</div>


# Cloud Resources

```bash
cat examples/vm/digital-ocean.yaml

kubectl apply --filename examples/vm/digital-ocean.yaml
```


# Tailor-Made Services

```bash
cat examples/k8s/aws-eks.yaml

kubectl --namespace a-team apply \
    --filename examples/k8s/aws-eks.yaml

kubectl --namespace a-team get clusterclaims
```


# Universal API & CP

```bash
kubectl get managed
```


# Tailor-Made Platforms

```bash
cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml
```


# Shift-Left

```bash
cat examples/app/backend-aws-postgresql.yaml

cat examples/gitops/argo-cd-no-claim.yaml
```


# Raise above clouds

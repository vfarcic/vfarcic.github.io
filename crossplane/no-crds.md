# What Is An App In Kubernetes?


```bash
kubectl kustomize --enable-helm \
    https://github.com/vfarcic/silly-demo/kustomize/overlays/stateful-db \
    | kubectl --namespace production apply --filename -

kubectl --namespace production \
    get all,configmaps,secrets,ingresses
```


<!-- .slide: data-background="img/crds/01.jpg" data-background-size="cover" -->


```bash
kubectl kustomize --enable-helm \
    https://github.com/vfarcic/silly-demo/kustomize/overlays/stateful-db \
    | kubectl --namespace production delete --filename -
```


# Still Easy?


![](../img/products/argo.png)


![](../img/products/knative.png)


![](../img/products/crossplane.png)


```bash
kubectl get crds
```


<!-- .slide: data-background="img/krs/01.jpg" data-background-size="cover" -->


# Still Easy?


# Context?


```yaml
apiVersion: admissionregistration.k8s.io/v1alpha1
kind: ValidatingAdmissionPolicy
metadata:
  name: max-replicas
spec:
  failurePolicy: Fail
  matchConstraints:
    resourceRules:
    - apiGroups:   ["apps"]
      apiVersions: ["v1"]
      operations:  ["CREATE", "UPDATE"]
      resources:   ["deployments", "statefulsets"]
  validations:
  - expression: "object.spec.replicas <= 5"
    message: "replicas must be less than or equal to 5"
```


# What Should We Do?

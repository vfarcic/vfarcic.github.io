# Why Kubernetes Admission Controllers?


# What Are Kubernetes Admission Controllers?


<!-- .slide: data-background="img/vap/01.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/02.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/03.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/04.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/05.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/06.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/07.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/08.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/09.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/10.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/11.jpg" data-background-size="contain" data-background-color="white" -->


<!-- .slide: data-background="img/vap/12.jpg" data-background-size="contain" data-background-color="white" -->


# What Is Kubernetes Validating Admission Policy?


# Policies Baked Into Kubernetes


```yaml
apiVersion: admissionregistration.k8s.io/v1alpha1
kind: ValidatingAdmissionPolicy
metadata:
  name: "demo-policy.example.com"
spec:
  failurePolicy: Fail
  matchConstraints:
    resourceRules:
    - apiGroups:   ["apps"]
      apiVersions: ["v1"]
      operations:  ["CREATE", "UPDATE"]
      resources:   ["deployments"]
  validations:
    - expression: "object.spec.replicas <= 5"
```


```yaml
apiVersion: admissionregistration.k8s.io/v1alpha1
kind: ValidatingAdmissionPolicyBinding
metadata:
  name: "demo-binding-test.example.com"
spec:
  policyName: "demo-policy.example.com"
  matchResources:
    namespaceSelector:
      matchLabels:
        environment: test
```


# Easy?


# Does It Work?

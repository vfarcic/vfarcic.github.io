## Hands-On Time

---

# Installing and Setting Up Jenkins


## Running Jenkins

---

```bash
JENKINS_ADDR="jenkins.$LB_IP.nip.io"

echo $JENKINS_ADDR

helm install stable/jenkins --name jenkins --namespace jenkins \
    --values helm/jenkins-values.yml \
    --set Master.HostName=$JENKINS_ADDR

kubectl -n jenkins rollout status deployment jenkins
```


## Running Jenkins

---

```bash
open "http://$JENKINS_ADDR"

JENKINS_PASS=$(kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo)

echo $JENKINS_PASS
```


## Using Pods to Run Tools

---

```bash
open "http://$JENKINS_ADDR/job/my-k8s-job/configure"
```


## Using Pods to Run Tools

---

```groovy
podTemplate(label: "kubernetes", yaml: """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: vfarcic/kubectl
    command: ["sleep"]
    args: ["100000"]
  - name: oc
    image: vfarcic/openshift-client
    command: ["sleep"]
    args: ["100000"]
  - name: golang
    image: golang:1.9
    command: ["sleep"]
    args: ["100000"]
  - name: helm
    image: vfarcic/helm:2.8.2
    command: ["sleep"]
    args: ["100000"]
"""
) {
    node("kubernetes") {
        container("kubectl") {
            stage("kubectl") {
                sh "kubectl version"
            }
        }
        container("oc") {
            stage("oc") {
                sh "oc version"
            }
        }
        container("golang") {
            stage("golang") {
                sh "go version"
            }
        }
        container("helm") {
            stage("helm") {
                sh "helm version"
            }
        }
    }
}
```


<!-- .slide: data-background="img/jenkins-setup-agent-same-ns.png" data-background-size="contain" -->


## Using Pods to Run Tools

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/my-k8s-job/activity"

kubectl -n jenkins get pods
```


<!-- .slide: data-background="img/jenkins-setup-agent-to-tiller-in-kube-system.png" data-background-size="contain" -->


## Using Pods to Run Tools

---

```bash
kubectl -n jenkins get pods
```


## What Now?

---

```bash
helm delete $(helm ls -q) --purge

kubectl delete ns go-demo-3 go-demo-3-build jenkins
```

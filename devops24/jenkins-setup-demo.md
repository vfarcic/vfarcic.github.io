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

```groovy
podTemplate(
    label: "kubernetes",
    containers: [
        containerTemplate(name: "maven", image: "maven:alpine", ttyEnabled: true, command: "cat"),
        containerTemplate(name: "golang", image: "golang:alpine", ttyEnabled: true, command: "cat")
    ]
) {
    node("kubernetes") {
        container("maven") {
            stage("build") {
                sh "mvn --version"
            }
            stage("unit-test") {
                sh "java -version"
            }
        }
        container("golang") {
            stage("deploy") {
                sh "go version"
            }
        }
    }
}
```


## Using Pods to Run Tools

---

```bash
kubectl -n jenkins get pods
```


<!-- .slide: data-background="img/jenkins-setup-agent-same-ns.png" data-background-size="contain" -->


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


## Builds In Different Namespaces

---

```bash
open "http://$JENKINS_ADDR/job/my-k8s-job/configure"
```


## Builds In Different Namespaces

---

```groovy
podTemplate(
    label: "kubernetes",
    namespace: "go-demo-3-build",
    serviceAccount: "build",
    yaml: """
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
                sh "helm version --tiller-namespace go-demo-3-build"
            }
        }
    }
}
```


## Builds In Different Namespaces

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/my-k8s-job/activity"

cat ../go-demo-3/k8s/build-ns.yml

kubectl apply -f ../go-demo-3/k8s/build-ns.yml --record

cat ../go-demo-3/k8s/prod-ns.yml

kubectl apply -f ../go-demo-3/k8s/prod-ns.yml --record

cat ../go-demo-3/k8s/jenkins.yml

kubectl apply -f ../go-demo-3/k8s/jenkins.yml --record

open "http://$JENKINS_ADDR/configure"
```


## Builds In Different Namespaces

---

```bash
helm init --service-account build \
    --tiller-namespace go-demo-3-build

kubectl -n go-demo-3-build rollout status deployment tiller-deploy
```


<!-- .slide: data-background="img/jenkins-setup-multi-ns.png" data-background-size="contain" -->


## Builds In Different Namespaces

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/my-k8s-job/activity"

kubectl -n go-demo-3-build get pods
```


## Creating AMI

---

```bash
aws ec2 create-security-group \
    --description "For building Docker images" \
    --group-name docker | tee cluster/sg.json

SG_ID=$(cat cluster/sg.json | jq -r ".GroupId")

echo $SG_ID

echo "export SG_ID=$SG_ID" | tee -a cluster/docker-ec2

aws ec2 authorize-security-group-ingress --group-name docker \
    --protocol tcp --port 22 --cidr 0.0.0.0/0
```


## Creating AMI

---

```bash
cat jenkins/docker-ami.json

packer build -machine-readable jenkins/docker-ami.json \
    | tee cluster/docker-ami.log

AMI_ID=$(grep 'artifact,0,id' cluster/docker-ami.log | cut -d: -f2)

echo $AMI_ID

echo "export AMI_ID=$AMI_ID" | tee -a cluster/docker-ec2

open "http://$JENKINS_ADDR/configure"

echo $AWS_ACCESS_KEY_ID

echo $AWS_SECRET_ACCESS_KEY
```


## Creating AMI

---

```bash
aws ec2 create-key-pair --key-name devops24 \
    | jq -r '.KeyMaterial' >cluster/devops24.pem

chmod 400 cluster/devops24.pem

cat cluster/devops24.pem

echo $AMI_ID
```


## Testing Docker Builds

---

```bash
open "http://$JENKINS_ADDR/job/my-k8s-job/configure"
```


## Testing Docker Builds

---

```groovy
podTemplate(
    label: "kubernetes",
    namespace: "go-demo-3-build",
    serviceAccount: "build",
    yaml: """
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
    node("docker") {
        stage("docker") {
            sh "sudo docker version"
        }
    }
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
                sh "helm version --tiller-namespace go-demo-3-build"
            }
        }
    }
}
```


## Testing Docker Builds

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/my-k8s-job/activity"
```


<!-- .slide: data-background="img/jenkins-setup.png" data-background-size="contain" -->


## Automating Jenkins Setup

---

```bash
mkdir -p cluster/jenkins/secrets

kubectl -n jenkins describe deployment jenkins

kubectl -n jenkins get pods -l component=jenkins-jenkins-master

JENKINS_POD=$(kubectl -n jenkins get pods \
    -l component=jenkins-jenkins-master \
    -o jsonpath='{.items[0].metadata.name}')

echo $JENKINS_POD
```


## Automating Jenkins Setup

---

```bash
kubectl -n jenkins cp \
    $JENKINS_POD:var/jenkins_home/credentials.xml cluster/jenkins

kubectl -n jenkins cp \
    $JENKINS_POD:var/jenkins_home/secrets/hudson.util.Secret \
    cluster/jenkins/secrets

kubectl -n jenkins cp \
    $JENKINS_POD:var/jenkins_home/secrets/master.key \
    cluster/jenkins/secrets

helm delete jenkins --purge
```


## Automating Jenkins Setup

---

```bash
ls -1 helm/jenkins

cat helm/jenkins/requirements.yaml

helm inspect readme stable/jenkins

cat helm/jenkins/values.yaml

cat helm/jenkins/templates/config.tpl

helm dependency update helm/jenkins

ls -1 helm/jenkins/charts
```


## Automating Jenkins Setup

---

```bash
kubectl -n jenkins create secret generic jenkins-credentials \
    --from-file cluster/jenkins/credentials.xml

kubectl -n jenkins create secret generic jenkins-secrets \
    --from-file cluster/jenkins/secrets

helm install helm/jenkins --name jenkins --namespace jenkins \
    --set jenkins.Master.HostName=$JENKINS_ADDR \
    --set jenkins.Master.DockerAMI=$AMI_ID \
    --set jenkins.Master.GProject=$G_PROJECT \
    --set jenkins.Master.GAuthFile=$G_AUTH_FILE

kubectl delete clusterrolebinding jenkins-role-binding
```


## Automating Jenkins Setup

---

```bash
kubectl -n jenkins rollout status deployment jenkins

open "http://$JENKINS_ADDR"

JENKINS_PASS=$(kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo)

echo $JENKINS_PASS

open "http://$JENKINS_ADDR/configure"

cat cluster/devops24.pem
```


## Automating Jenkins Setup

---

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/credential/aws/update"

open "http://$JENKINS_ADDR/computer"

open "http://$JENKINS_ADDR/newJob"
```


## Automating Jenkins Setup

---

```groovy
podTemplate(
    label: "kubernetes",
    namespace: "go-demo-3-build",
    serviceAccount: "build",
    yaml: """
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
    node("docker") {
        stage("docker") {
            sh "sudo docker version"
        }
    }
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
                sh "helm version --tiller-namespace go-demo-3-build"
            }
        }
    }
}
```


## Automating Jenkins Setup

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/my-k8s-job/activity"
```


## What Now?

---

```bash
helm delete $(helm ls -q) --purge

kubectl delete ns go-demo-3 go-demo-3-build jenkins
```

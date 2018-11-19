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

* Click the *New Item* link
* Type *my-k8s-job* as the item name
* Select *Pipeline*
* Click the *OK* button
* Copy&paste the job that follows into the Pipeline Script field


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

* Click the *Save* button
* Click the *Open Blue Ocean* link
* click the *Run* button

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
kubectl -n jenkins get pods
```

* The build hangs (unless Docker For Desktop)
* Stop the build (unless Docker For Desktop)


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
# Stop the build (unless Docker For Desktop)

cat ../go-demo-3/k8s/build-ns.yml

kubectl apply -f ../go-demo-3/k8s/build-ns.yml --record

cat ../go-demo-3/k8s/prod-ns.yml

kubectl apply -f ../go-demo-3/k8s/prod-ns.yml --record

cat ../go-demo-3/k8s/jenkins.yml

kubectl apply -f ../go-demo-3/k8s/jenkins.yml --record
```


## Builds In Different Namespaces

---

```bash
open "http://$JENKINS_ADDR/configure"
```

* Change *Jenkins URL* to *http://jenkins.jenkins:8080*
* Change *Jenkins tunnel* to *jenkins-agent.jenkins:50000*
* Click the *Save* button

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


## Creating Nodes For Building Docker Images

---

```bash
open "http://$JENKINS_ADDR/credentials/store/system/domain/_/newCredentials"
```

* Type your Docker Hub *Username* and *Password*.
* Set both the *ID* and the *Description* to *docker*
* Click the *OK* button


## Vagrant & VirtualBox Agent
##### (only if Docker For Desktop or minikube)

---

* Install [Vagrant](https://www.vagrantup.com/)

```bash
cd cd/docker-build

cat Vagrantfile

vagrant up

open "http://$JENKINS_ADDR/computer/new"
```

* Type *docker-build* as the *Node name*
* Select *Permanent Agent*
* Click the *OK* button


## Vagrant & VirtualBox Agent
##### (only if Docker For Desktop or minikube)

---

* Type *2* as the *# of executors*
* Set the *Remote root directory* to */tmp*
* Set the labels to *docker ubuntu linux*
* Select *Launch slave agents via SSH* as the *Launch Method*
* Set the *Host* to *10.100.198.200*
* Click *Add* drop-down next to *Credentials*, select *Jenkins*
* Select *SSH Username with private key* as the *Kind*
* Type *vagrant* as the *Username*
* Select *Enter directly* as the *Private Key*


## Vagrant & VirtualBox Agent
##### (only if Docker For Desktop or minikube)

---

```bash
cat .vagrant/machines/docker-build/virtualbox/private_key
```

* Copy the output and paste it into the *Key* field
* Type *docker-build* as the *ID* and the *Description*
* Click the *Add* button
* Select *vagrant (docker-build)* in the *Credentials* list
* Select *Not verifying Verification Strategy* as the *Host Key Verification Strategy*
* Click the *Save* button


## Vagrant & VirtualBox Agent
##### (only if Docker For Desktop or minikube)

---

```bash
cd ../../

export DOCKER_VM=true
```


## Creating AMI
##### (only if EKS or kops)

---

```bash
aws ec2 create-security-group \
    --description "For building Docker images" \
    --group-name devops24 | tee cluster/sg.json

SG_ID=$(cat cluster/sg.json | jq -r ".GroupId")

echo $SG_ID

echo "export SG_ID=$SG_ID" | tee -a cluster/docker-ec2

aws ec2 authorize-security-group-ingress --group-name devops24 \
    --protocol tcp --port 22 --cidr 0.0.0.0/0
```


## Creating AMI
##### (only if EKS or kops)

---

```bash
open "https://www.packer.io/intro/getting-started/install.html"

cat jenkins/docker-ami.json

packer build -machine-readable jenkins/docker-ami.json \
    | tee cluster/docker-ami.log

AMI_ID=$(grep 'artifact,0,id' cluster/docker-ami.log | cut -d: -f2)

echo $AMI_ID

echo "export AMI_ID=$AMI_ID" | tee -a cluster/docker-ec2

open "http://$JENKINS_ADDR/configure"
```


## Creating AMI
##### (only if EKS or kops)

---

* Scroll to the *Cloud* section and click the *Add a new cloud* drop-down list
* Choose *Amazon EC2*
* Type *docker-agents* as the *Name*
* Expand the *Add* drop-down list next to *Amazon EC2 Credentials* and choose *Jenkins*
* Choose *AWS Credentials* as the *Kind*
* Type *aws* as both the *ID* and the *Description*


## Creating AMI
##### (only if EKS or kops)

---

```bash
echo $AWS_ACCESS_KEY_ID
```

* Copy&paste the output into the *Access Key ID* field

```bash
echo $AWS_SECRET_ACCESS_KEY
```

* Copy&paste the output into the *Secret Access Key* field
* Press the *Add* button and choose the newly created credentials
* Select *us-east-2* as the *Region*


## Creating AMI
##### (only if EKS or kops)

---

```bash
aws ec2 create-key-pair --key-name devops24 \
    | jq -r '.KeyMaterial' >cluster/devops24.pem

chmod 400 cluster/devops24.pem

cat cluster/devops24.pem
```

* Copy&paste the output into the *EC2 Key Pair's Private Key* field
* Press the *Test Connection* button
* Click the *Add* button next to *AMIs*
* Type *docker* as the *Description*


## Creating AMI
##### (only if EKS or kops)

---

```bash
echo $AMI_ID
```
* Copy&paste the output it into the *AMI ID* field
* Select *T2Small* as the *Instance Type*
* Type *devops24* as the *Security group names*
* Type *ubuntu* as the *Remote user*
* The *Remote ssh port* should be set to *22*
* Write *docker ubuntu linux* as the labels
* Change the *Idle termination time* to *10*
* Click the *Save* button


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
    --set jenkins.Master.DockerVM=$DOCKER_VM \
    --set jenkins.Master.DockerAMI=$AMI_ID \
    --set jenkins.Master.GProject=$G_PROJECT \
    --set jenkins.Master.GAuthFile=$G_AUTH_FILE
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
```


## Automating Jenkins Setup

---

```bash
open "http://$JENKINS_ADDR/configure"

# Confirm that Kubernetes Cloud is configured properly

# Only if EKS or kops
cat cluster/devops24.pem
```

* If EKS, Copy&paste into the *EC2 Key Pair's Private Key* field
* If EKS, Click the *Apply* button

```bash
open "http://$JENKINS_ADDR/computer"

open "http://$JENKINS_ADDR/newJob"
```

* Create a job called *my-k8s-job*


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

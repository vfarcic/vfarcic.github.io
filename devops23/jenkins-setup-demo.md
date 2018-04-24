## Hands-On Time

---

# Jenkins Setup


## Running Jenkins

---

```bash
export LB_ADDR=$(kubectl -n kube-ingress get svc ingress-nginx \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

dig +short $LB_ADDR

# If empty, LB is still not fully set up. Wait and repeat.

LB_IP=$(dig +short $LB_ADDR | tail -n 1)

JENKINS_ADDR="jenkins.$LB_IP.xip.io"

echo $JENKINS_ADDR

helm install stable/jenkins --name jenkins --namespace jenkins \
    --values helm/jenkins-values.yml \
    --set Master.HostName=$JENKINS_ADDR
```


## Running Jenkins

---

```bash
kubectl -n jenkins rollout status deployment jenkins

open "http://$JENKINS_ADDR"

kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo
```

* Login with user *admin*


## Tools in the same Namespace

---

* Click the *New Item* link in the left-hand menu
* Type *my-k8s-job* in the *item name* field
* Select *Pipeline* as the type
* Click the *OK* button
* Click the *Pipeline* tab
* Write the script that follows in the *Pipeline Script* field


## Tools in the same Namespace

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
                sh "sleep 5"
                sh "mvn --version"
            }
            stage("unit-test") {
                sh "sleep 5"
                sh "java -version"
            }
        }
        container("golang") {
            stage("deploy") {
                sh "sleep 5"
                sh "go version"
            }
        }
    }
}
```


## Tools in the same Namespace

---

* Click the *Save* button
* Click the *Open Blue Ocean* link from the left-hand menu
* Click the *Run* button

```bash
kubectl -n jenkins get pods
```

* Observe the results in the UI


## Tools in a Different Namespace

---

```bash
open "http://$JENKINS_ADDR/job/my-k8s-job/configure"
```

* Update the job with the script that follows


## Tools in a Different Namespace

---

```groovy
podTemplate(
    label: "kubernetes",
    containers: [
        containerTemplate(name: "maven", image: "maven:alpine", ttyEnabled: true, command: "cat"),
        containerTemplate(name: "golang", image: "golang:alpine", ttyEnabled: true, command: "cat")
    ],
    namespace: "go-demo-3-build"
) {
    node("kubernetes") {
        container("maven") {
            stage("build") {
                sh "sleep 5"
                sh "mvn --version"
            }
            stage("unit-test") {
                sh "sleep 5"
                sh "java -version"
            }
        }
        container("golang") {
            stage("deploy") {
                sh "sleep 5"
                sh "go version"
            }
        }
    }
}
```


## Tools in a Different Namespace

---

* Click *Save*
* Click the *Open Blue Ocean* link from the left-hand menu
* Click the *Run* button

```bash
kubectl create -f ../go-demo-3/k8s/build-ns.yml \
    --save-config --record

kubectl create -f ../go-demo-3/k8s/prod-ns.yml \
    --save-config --record

kubectl get ns

open "http://$JENKINS_ADDR/configure"
```

* Change *Jenkins URL* to *http://jenkins.jenkins:8080*
* Change *Jenkins tunnel* to *jenkins-agent.jenkins:50000*


## Tools in a Different Namespace

---

```bash
open "http://$JENKINS_ADDR/blue/organizations/jenkins/my-k8s-job/activity"
```

* Click the *Run* button

```bash
kubectl -n go-demo-3-build get pods
```


## Docker Manual

---

```bash
aws ec2 create-security-group --group-name docker \
    --description "For building Docker images" | tee cluster/sg.json

SG_ID=$(cat cluster/sg.json | jq -r ".GroupId")

echo "export SG_ID=$SG_ID" | tee -a cluster/kops

aws ec2 authorize-security-group-ingress --group-name docker \
    --protocol tcp --port 22 --cidr 0.0.0.0/0
```

* Install Packer


## Docker Manual

---

```bash
packer build -machine-readable jenkins/docker.json \
    | tee cluster/docker-packer.log

AMI_ID=$(grep 'artifact,0,id' cluster/docker-packer.log \
    | cut -d: -f2)

echo $AMI_ID

echo "export AMI_ID=$AMI_ID" | tee -a cluster/kops

aws ec2 run-instances --image-id $AMI_ID --count 1 \
    --instance-type t2.micro --key-name devops23 \
    --security-groups docker --tag-specifications \
    'ResourceType=instance,Tags=[{Key=Name,Value=docker}]' \
    | tee cluster/docker-ec2.json
```


## Docker Manual

---

```bash
INSTANCE_ID=$(cat cluster/docker-ec2.json \
    | jq -r ".Instances[0].InstanceId")

aws ec2 describe-instances --instance-ids $INSTANCE_ID \
    | jq -r ".Reservations[0].Instances[0].State.Name"
```

* Wait until it's `running`, and then wait some more

```bash
aws ec2 describe-instances --instance-ids $INSTANCE_ID \
    | jq -r ".Reservations[0].Instances[0].PublicIpAddress"

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
    | jq -r ".Reservations[0].Instances[0].PublicIpAddress")

ssh -i cluster/devops23.pem ubuntu@$PUBLIC_IP

docker version

export GH_USER=[...]
```


## Docker Manual

---

```bash
git clone https://github.com/$GH_USER/go-demo-3.git

cd go-demo-3

export DH_USER=[...]

docker image build -t $DH_USER/go-demo-3:1.0-beta .

docker login -u $DH_USER

docker image push $DH_USER/go-demo-3:1.0-beta

exit

aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```


## Docker Jenkins

---

```bash
open "http://$JENKINS_ADDR/configure"
```

* Click the *Add a new cloud* drop-down list
* Choose *Amazon EC2*
* Type *docker-agents* as the *Name*
* Click *Add* next to *Amazon EC2 Credentials*
* Choose *Jenkins*
* Choose *AWS Credentials* as the *Kind*
* Type *aws* as the *ID*
* Type *aws* as the *Description*


## Docker Jenkins

---

```bash
echo $AWS_ACCESS_KEY_ID
```

* Copy the output and paste it into the *Access Key ID* field

```bash
echo $AWS_SECRET_ACCESS_KEY
```

* Copy the output and paste it into the *Secret Access Key* field
* Click the *Add* button
* Choose the newly created credentials
* Select *us-east-2* as the *Region*


## Docker Jenkins

---

```bash
cat cluster/devops23.pem
```

* Copy the output and paste it into the *EC2 Key Pair's Private Key* field
* Click the *Test Connection* button
* Click the *Add* button next to *AMIs*
* Type *docker* as the *Description*

```bash
echo $AMI_ID
```

* Copy the output and paste it into the *AMI ID* field
* Click the *Check AMI* button


## Docker Jenkins

---

* Select *T2Micro* as the *Instance Type*
* Type *docker* as the *Security group names*
* Type *ubuntu* as the *Remote user*
* Type *22* as the *Remote ssh port*
* Type *docker* as labels
* Type *1* as *Idle termination time*
* Click the *Save* button

```bash
open "http://$JENKINS_ADDR/job/my-k8s-job/configure"
```

* Update the job with the script that follows


## Docker Jenkins

---

```groovy
podTemplate(
    label: "kubernetes",
    containers: [
        containerTemplate(name: "maven", image: "maven:alpine", ttyEnabled: true, command: "cat"),
        containerTemplate(name: "golang", image: "golang:alpine", ttyEnabled: true, command: "cat")
    ],
    namespace: "go-demo-3-build"
) {
    node("docker") {
        stage("build") {
            sh "sleep 5"
            sh "docker version"
        }    
    }
    node("kubernetes") {
        container("maven") {
            stage("unit-test") {
                sh "sleep 5"
                sh "java -version"
            }
        }
        container("golang") {
            stage("deploy") {
                sh "sleep 5"
                sh "go version"
            }
        }
    }
}
```


## kubectl

---

```bash
open "http://$JENKINS_ADDR/job/my-k8s-job/configure"
```

* Update the job with the script that follows


## kubectl

---

```groovy
podTemplate(
    label: "kubernetes",
    containers: [
        containerTemplate(name: "maven", image: "maven:alpine", ttyEnabled: true, command: "cat"),
        containerTemplate(name: "kubectl", image: "vfarcic/kubectl", ttyEnabled: true, command: "cat")
    ],
    namespace: "go-demo-3-build",
    serviceAccount: "build"
) {
    node("docker") {
        stage("build") {
            sh "sleep 5"
            sh "docker version"
        }    
    }
    node("kubernetes") {
        container("maven") {
            stage("unit-test") {
                sh "sleep 5"
                sh "java -version"
            }
        }
        container("kubectl") {
            stage("deploy") {
                sh "sleep 5"
                sh "kubectl -n go-demo-3 get all"
            }
        }
    }
}
```


## kubectl

---

```bash
helm delete jenkins --purge
```


## Automate Setup

---

```bash
helm dependency update helm/jenkins

helm install helm/jenkins --name jenkins --namespace jenkins \
    --set jenkins.Master.HostName=$JENKINS_ADDR \
    --set jenkins.Master.AMI=$AMI_ID

kubectl -n jenkins describe cm jenkins

kubectl -n jenkins rollout status deployment jenkins

open "http://$JENKINS_ADDR"

kubectl -n jenkins get secret jenkins \
    -o jsonpath="{.data.jenkins-admin-password}" \
    | base64 --decode; echo
```


## kubectl

---

* Login with user `admin`

```bash
open "http://$JENKINS_ADDR/configure"
```

* Click *Add* next to *Amazon EC2 Credentials*
* Choose *Jenkins*
* Choose *AWS Credentials* as the *Kind*
* Type *aws* as the *ID*
* Type *aws* as the *Description*


## kubectl

---

```bash
echo $AWS_ACCESS_KEY_ID
```

* Copy the output and paste it into the *Access Key ID* field

```bash
echo $AWS_SECRET_ACCESS_KEY
```

* Copy the and paste into the *Secret Access Key* field
* Click the *Add* button
* Choose the newly created credentials

```bash
cat cluster/devops23.pem
```

* Copy and paste into the *EC2 Key Pair's Private Key* field
* Click the *Test Connection* button
* Update the job with the script that follows


## kubectl

---

```groovy
podTemplate(
    label: "kubernetes",
    containers: [
        containerTemplate(name: "maven", image: "maven:alpine", ttyEnabled: true, command: "cat"),
        containerTemplate(name: "kubectl", image: "vfarcic/kubectl", ttyEnabled: true, command: "cat")
    ],
    namespace: "go-demo-3-build",
    serviceAccount: "build"
) {
    node("docker") {
        stage("build") {
            sh "sleep 5"
            sh "docker version"
        }    
    }
    node("kubernetes") {
        container("maven") {
            stage("unit-test") {
                sh "sleep 5"
                sh "java -version"
            }
        }
        container("kubectl") {
            stage("deploy") {
                sh "sleep 5"
                sh "kubectl -n go-demo-3 get all"
            }
        }
    }
}
```


## What Now?

---

```bash
TODO
```

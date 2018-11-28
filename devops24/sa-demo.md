## Hands-On Time

---

# Service Accounts


## Getting The Code
## (if you don't have it already)

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


## Jenkins With Kubernetes

---

```bash
cat sa/jenkins-no-sa.yml

kubectl create -f sa/jenkins-no-sa.yml --record --save-config

kubectl -n jenkins rollout status sts jenkins

# If Docker For Desktop, kops, or EKS
CLUSTER_DNS=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If GKE
CLUSTER_DNS=$(kubectl -n jenkins get ing jenkins \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If minikube
CLUSTER_DNS=$(minikube ip)
```


## Jenkins With Kubernetes

---

```bash
echo $CLUSTER_DNS

open "http://$CLUSTER_DNS/jenkins"

kubectl -n jenkins exec jenkins-0 -it -- \
    cat /var/jenkins_home/secrets/initialAdminPassword
```

* Copy the output and paste it into Jenkins UI *Administrator password* field
* Click the *Continue* button
* Click the *Install suggested plugins* button
* Fill in the *Create First Admin User* fields
* Click the *Save and Continue* button
* Click the *Save and Finish* button
* Click the *Start using Jenkins* button


## Jenkins With Kubernetes

---

```bash
open "http://$CLUSTER_DNS/jenkins/pluginManager/available"
```

* Type *Kubernetes* in the *Filter* field
* Select *Kubernetes* checkbox
* Type *BlueOcean* in the *Filter* field
* Select *BlueOcean* checkbox
* Click the *Install without restart* button


## Jenkins With Kubernetes

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Click the *Add a new cloud* drop-down list in the *Cloud* section
* Select *Kubernetes*
* Click the *Test Connection* button (works only in Docker For Desktop)

```bash
kubectl delete ns jenkins
```


## Without ServiceAccount

---

```bash
curl https://raw.githubusercontent.com/vfarcic/kubectl/master/Dockerfile

kubectl run kubectl --image=vfarcic/kubectl --restart=Never \
    sleep 10000

# Wait for a few moments

kubectl get pod kubectl -o jsonpath="{.spec.serviceAccount}"

kubectl exec -it kubectl -- sh

cd /var/run/secrets/kubernetes.io/serviceaccount

ls -la
```


## Without ServiceAccount

---

```bash
cat token

cat ca.crt

cat namespace

kubectl get pods # Works only in Docker For Desktop

exit

kubectl describe pod kubectl

kubectl delete pod kubectl
```


## With ServiceAccount

---

```bash
kubectl get sa

cat sa/view.yml

kubectl create -f sa/view.yml --record --save-config

kubectl get sa

kubectl describe sa view

kubectl describe rolebinding view

cat sa/kubectl-view.yml

kubectl create -f sa/kubectl-view.yml --record --save-config
```


## With ServiceAccount

---

```bash
kubectl describe pod kubectl

kubectl exec -it kubectl -- sh

kubectl get pods

# Works only in Docker For Desktop
kubectl run new-test --image=alpine --restart=Never sleep 10000

exit

kubectl delete -f sa/kubectl-view.yml

cat sa/pods.yml

kubectl create -f sa/pods.yml --record --save-config
```


## With ServiceAccount

---

```bash
kubectl create ns test2

cat sa/kubectl-test1.yml

kubectl create -f sa/kubectl-test1.yml --record --save-config

kubectl -n test1 exec -it kubectl -- sh

kubectl run new-test --image=alpine --restart=Never sleep 10000

kubectl get pods

# Works only in Docker For Desktop
kubectl -n test2 run new-test --image=alpine sleep 10000

kubectl -n test2 get pods # Works only in Docker For Desktop
```


## With ServiceAccount

---

```bash
exit

kubectl delete -f sa/kubectl-test1.yml

cat sa/pods-all.yml

kubectl apply -f sa/pods-all.yml --record

cat sa/kubectl-test2.yml

kubectl create -f sa/kubectl-test2.yml --record --save-config

kubectl -n test1 exec -it kubectl -- sh

kubectl get pods
```


## With ServiceAccount

---

```bash
kubectl -n test2 get pods

kubectl -n test2 run new-test --image=alpine --restart=Never \
    sleep 10000

kubectl -n test2 get pods

kubectl -n default get pods # Works only in Docker For Desktop

kubectl -n kube-system get pods # Works only in Docker For Desktop

exit

kubectl delete ns test1 test2
```


## Jenkins w/Kubernetes (again)

---

```bash
cat sa/jenkins.yml

kubectl create -f sa/jenkins.yml --record --save-config

kubectl -n jenkins rollout status sts jenkins

open "http://$CLUSTER_DNS/jenkins"

kubectl -n jenkins exec jenkins-0 -it -- \
    cat /var/jenkins_home/secrets/initialAdminPassword
```

* Copy the output and paste it into Jenkins UI *Administrator password* field
* Click the *Continue* button
* Click the *Install suggested plugins* button


## Jenkins w/Kubernetes (again)

---

* Fill in the *Create First Admin User* fields
* Click the *Save and Continue* button
* Click the *Save and Finish* button
* Click the *Start using Jenkins* button

```bash
open "http://$CLUSTER_DNS/jenkins/pluginManager/available"
```

* Type *Kubernetes* in the *Filter* field
* Select *Kubernetes* checkbox
* Type *BlueOcean* in the *Filter* field
* Select *BlueOcean* checkbox
* Click the *Install without restart* button


## Jenkins w/Kubernetes (again)

---

```bash
open "http://$CLUSTER_DNS/jenkins/configure"
```

* Click the *Add a new cloud* drop-down list in the *Cloud* section
* Select *Kubernetes*
* Type *build* in the *Kubernetes Namespace* field
* Click the *Test Connection* button
* Type *http://jenkins.jenkins/jenkins* in the *Jenkins URL* field
* Click the *Save* button


## Jenkins w/Kubernetes (again)

---

* Click the *New Item* link in the left-hand menu
* Type *my-k8s-job* in the *item name* field
* Select *Pipeline* as the type
* Click the *OK* button
* Click the *Pipeline* tab
* Write the script that follows in the *Pipeline Script* field


## Jenkins w/Kubernetes (again)

---

```groovy
podTemplate(
    label: 'kubernetes',
    containers: [
        containerTemplate(name: 'maven', image: 'maven:alpine', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'golang', image: 'golang:alpine', ttyEnabled: true, command: 'cat')
    ]
) {
    node('kubernetes') {
        container('maven') {
            stage('build') {
                sh 'mvn --version'
            }
            stage('unit-test') {
                sh 'java -version'
            }
        }
        container('golang') {
            stage('deploy') {
                sh 'go version'
            }
        }
    }
}
```


## Jenkins w/Kubernetes (again)

---

* Click the *Save* button
* Click the *Open Blue Ocean* link from the left-hand menu
* Click the *Run* button

```bash
kubectl -n build get pods # Repeat until the new Pod is terminated

kubectl delete ns jenkins build
```


## Mongo

---

```bash
cat sa/go-demo-3.yml

kubectl create -f sa/go-demo-3.yml --record --save-config

kubectl -n go-demo-3 get pods

kubectl -n go-demo-3 logs db-0 -c db-sidecar

kubectl delete ns go-demo-3
```


## What Now?

---

```bash
kubectl delete sa,rolebinding view
```

<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Prerequisites

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/) (MUST BE `helm` 2.+)


<!--
export PROJECT=[...] # e.g. devops-27

gcloud container clusters create jx-rocks --region us-east1 \
    --machine-type n1-standard-8 --enable-autoscaling \
    --num-nodes 1 --max-nodes 10 --min-nodes 1 --project $PROJECT

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin --user $(gcloud config get-value account)

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/mandatory.yaml

kubectl apply \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/1cd17cd12c98563407ad03812aebac46ca4442f2/deploy/provider/cloud-generic.yaml

curl -o get-kubeconfig.sh \
    https://raw.githubusercontent.com/gravitational/teleport/master/examples/gke-auth/get-kubeconfig.sh

chmod +x get-kubeconfig.sh

rm -rf build

./get-kubeconfig.sh

tar -czf kubeconfig.tar.gz build

mv kubeconfig.tar.gz ~/Amazon\ Drive/tmp/.

git clone https://github.com/vfarcic/jenkins-x-boot-config-workshop.git

# TODO: Pull upstream
-->
<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

<!-- TODO: Change me -->
```bash
open "https://www.amazon.es/clouddrive/share/Bjuj4XBDO2XFrHf5NSa4b3aUe9TzgSvHZKRyBEwqXov"

# Download the file

tar -xzvf kubeconfig.tar.gz

export KUBECONFIG=$PWD/build/kubeconfig

export GH_USER=[...] # Replace `[...]` with your GitHub user
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

```bash
git clone \
    https://github.com/vfarcic/jenkins-x-boot-config.git \
    environment-jx-rocks-dev

cd environment-jx-rocks-dev

NAMESPACE=$GH_USER
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

```bash
# Open `jx-requirements.yml`

# Add `cluster.namespace: [GH_USER]`

# Save & exit

jx boot

kubectl get pods

cd ..
```

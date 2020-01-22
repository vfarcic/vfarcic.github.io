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


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A GKE Cluster (Instructor)

```bash
export PROJECT=[...] # Replace `[...]` with the project ID

git clone https://github.com/vfarcic/terraform-gke.git

cd terraform-gke

git checkout jx-workshop

git pull
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A GKE Cluster (Instructor)

```bash
# Create a service account (https://console.cloud.google.com/apis/credentials/serviceaccountkey)

# Download the JSON and store it as account.json in this directory

terraform init

terraform apply

export CLUSTER_NAME=$(terraform output cluster_name)

export KUBECONFIG=$PWD/kubeconfig
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A GKE Cluster (Instructor)

```bash
gcloud container clusters \
    get-credentials $(terraform output cluster_name) \
    --project $(terraform output project_id) \
        --region $(terraform output region)

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

cd ..
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating Kube Config (Instructor)

```bash
curl -o get-kubeconfig.sh \
    https://raw.githubusercontent.com/gravitational/teleport/master/examples/gke-auth/get-kubeconfig.sh

chmod +x get-kubeconfig.sh

rm -rf build

./get-kubeconfig.sh

tar -czf kubeconfig.tar.gz build

mv kubeconfig.tar.gz ~/Amazon\ Drive/tmp/. # Share the config
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Retrieving Kube Config

```bash
# Instructor: Change me!
open "https://www.amazon.es/clouddrive/share/lQxadr8PoTY3p1RqiBjnOVjipgpSGgZJU8oUMSDfETl"

# Download the file

tar -xzvf kubeconfig.tar.gz

export KUBECONFIG=$PWD/build/kubeconfig
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

```bash
export GH_USER=[...] # Replace `[...]` with your GitHub user

git clone https://github.com/vfarcic/jenkins-x-boot-config-workshop.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

export NAMESPACE=$GH_USER
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Jenkins X Boot

```bash
# Open `jx-requirements.yml` in an editor
# Set `cluster.environmentGitOwner` to `[GH_USER]`
# Add `cluster.namespace: [GH_USER]`
# Save & Exit

jx boot

kubectl get pods

cd ..
```

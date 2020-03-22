<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export PROJECT=[...] # Replace `[...]` with the project ID

git clone https://github.com/vfarcic/terraform-gke.git

cd terraform-gke

git checkout jx-deployment

git pull
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
# Create a service account (https://console.cloud.google.com/apis/credentials/serviceaccountkey)

# Download the JSON and store it as account.json in this directory

terraform apply

export CLUSTER_NAME=$(terraform output cluster_name)

export KUBECONFIG=$PWD/kubeconfig
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

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
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git clone \
    https://github.com/jenkins-x/jenkins-x-boot-config.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

# Open `jx-requirements.yml` in an editor
# Set `cluster.clusterName` to the name of the cluster (e.g. `devops-27-demo`)
# Set `cluster.environmentGitOwner`
# Set `cluster.project` to the GCP project (e.g., `devops-27`)
# Set `cluster.zone` to the zone  (e.g., `us-east1`)
# Save & Exit
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx boot

cd ..
```

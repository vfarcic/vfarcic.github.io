<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
export GH_USER=[...] # Replace `[...]` with your GitHub user

export PROJECT_ID=[...] # Replace `[...]` with the project ID

export REGION=us-east1

git clone https://github.com/vfarcic/terraform-gke.git

cd terraform-gke

git checkout testing-production
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
git pull

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
cd ..

git clone \
    https://github.com/jenkins-x/jenkins-x-boot-config.git \
    environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

cat jx-requirements.yml \
    | sed -e "s@clusterName: \"\"@clusterName: \"$CLUSTER_NAME\"@g" \
    | sed -e "s@environmentGitOwner: \"\"@environmentGitOwner: \"$GH_USER\"@g" \
    | sed -e "s@project: \"\"@project: \"$PROJECT_ID\"@g" \
    | sed -e "s@zone: \"\"@zone: \"$REGION\"@g" \
    | tee jx-requirements.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
jx boot

cd ..
```

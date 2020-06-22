<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Repository

```bash
mkdir -p jx-infra

cd jx-infra

export GH_USER=[...] # Replace with your GitHub username
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Defining Infrastructure As Code

```bash
gcloud auth application-default login

export PROJECT_ID=jx-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

open https://console.cloud.google.com/billing/linkedaccount?project=$PROJECT_ID

# Link a billing account
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Defining Infrastructure As Code

```bash
echo "module \"jx\" {
  source                      = \"jenkins-x/jx/google\"
  gcp_project                 = \"$PROJECT_ID\"
  cluster_location            = \"us-east1\"
  cluster_name                = \"jenkins-x\"
  force_destroy               = \"true\"
  git_owner_requirement_repos = \"$GH_USER\"
  min_node_count              = 1
  max_node_count              = 2
  node_machine_type           = \"e2-standard-2\"
}" | tee main.tf
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Enabling APIs

```bash
gcloud services enable container.googleapis.com --project $PROJECT_ID
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## House-Keeping Tasks

```bash
export KUBECONFIG=$PWD/kubeconfig

terraform init

terraform apply

kubectl get nodes

export INFRA_PATH=$PWD
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Booting Jenkins X

```bash
cd ..

jx upgrade cli

jx boot --requirements $INFRA_PATH/jx-requirements.yml
```

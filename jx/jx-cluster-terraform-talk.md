<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>

* Infra
* CI/CD Platform
* Applications


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Picking A Tool For Managing Infrastructure

```bash
open https://console.cloud.google.com/

gcloud --help

gcloud container clusters create --help

open https://www.terraform.io/docs/providers/google/r/container_cluster.html

open https://www.terraform.io/docs/configuration/modules.html

open https://registry.terraform.io/modules/jenkins-x/jx/google
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Creating A Repository

```bash
mkdir -p jx-infra

cd jx-infra

git init

export GH_USER=[...] # Replace with your GitHub username

hub create $GH_USER/jx-infra
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

echo "module \"jx\" {
  source      = \"jenkins-x/jx/google\"
  gcp_project = \"$PROJECT_ID\"
}" | tee main.tf
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Defining Infrastructure As Code

```bash
echo "module \"jx\" {
  source                      = \"jenkins-x/jx/google\"
  version                     = \"1.4.0\"
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
echo "# My Jenkins X Infrastructure

Learn Terraform if you're confused" | tee README.md

git add .

git commit -m "Initial commit"

git push --set-upstream origin master
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## House-Keeping Tasks

```bash
export KUBECONFIG=$PWD/kubeconfig

terraform init

terraform apply

cat $KUBECONFIG

kubectl get nodes

export INFRA_PATH=$PWD
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## State To Remote Storage

```bash
export STATE_BUCKET=$PROJECT_ID-state

gsutil mb -p $PROJECT_ID gs://$STATE_BUCKET/

gsutil versioning set on gs://$STATE_BUCKET/

echo "terraform {
  backend \"gcs\" {
    bucket = \"$STATE_BUCKET\"
    prefix = \"terraform/state\"
  }
}" | tee backend.tf
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## State To Remote Storage

```bash
terraform init
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Booting Jenkins X

```bash
cd ..

cat $INFRA_PATH/jx-requirements.yml

jx upgrade cli

jx boot --requirements $INFRA_PATH/jx-requirements.yml

# Execute `rm -rf jenkins-x-boot-config` if you aborted the process
# to install a newer version of `jx`, and re-run the previous command.

cd jenkins-x-boot-config

ls -1

cat jx-requirements.yml
```


<!-- .slide: class="dark" -->
<div class="eyebrow"> </div>
<div class="label">Hands-on Time</div>

## Booting Jenkins X

```bash
open https://github.com/$GH_USER/environment-jenkins-x-dev

cd ..
```

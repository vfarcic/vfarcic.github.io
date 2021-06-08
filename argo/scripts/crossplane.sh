#########
# Setup #
#########

# The examples are using Google Cloud (GCP)!

# Create an account in https://cloud.upbound.io/register or https://crossplane.io/docs/v1.0/getting-started/install-configure.html#start-with-a-self-hosted-crossplane

curl -sL https://raw.githubusercontent.com/crossplane/crossplane/release-1.0/install.sh | sh

# Read the instructions from the output to finish the installation

minikube start

minikube addons enable ingress

# Open https://github.com/vfarcic/crossplane-demo.git

# Fork it!

# Replace `[...]` with the GitHub organization or the username
export GH_ORG=[...]

git clone https://github.com/$GH_ORG/crossplane-demo.git

cd crossplane-demo

# Replace `[...]` with the base host accessible through NGINX Ingress
export BASE_HOST=[...] # e.g., `$(minikube ip).nip.io`

#########################
# Setup: Deploy Argo CD #
#########################

cat argo-cd/base/ingress.yaml \
    | sed -e "s@acme.com@argo-cd.$BASE_HOST@g" \
    | tee argo-cd/overlays/production/ingress.yaml

cat production/argo-cd.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee production/argo-cd.yaml

cat apps.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee apps.yaml

git add .

git commit -m "Initial commit"

git push

kustomize build \
    argo-cd/overlays/production \
    | kubectl apply --filename -

kubectl --namespace argocd \
    rollout status \
    deployment argocd-server

export PASS=$(kubectl \
    --namespace argocd \
    get secret argocd-initial-admin-secret \
    --output jsonpath="{.data.password}" \
    | base64 --decode)

argocd login \
    --insecure \
    --username admin \
    --password $PASS \
    --grpc-web \
    argo-cd.$BASE_HOST

argocd account update-password \
    --current-password $PASS \
    --new-password admin

kubectl apply --filename project.yaml

kubectl apply --filename apps.yaml

############################
# Setup: Deploy Crossplane #
############################

helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install \
    crossplane crossplane-stable/crossplane \
    --namespace crossplane-system \
    --create-namespace \
    --wait

##############
# Setup: GCP #
##############

export PROJECT_ID=devops-toolkit-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID

# Open the URL and *ENABLE* the API

export SA_NAME=devops-toolkit

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts \
    create $SA_NAME \
    --project $PROJECT_ID

export ROLE=roles/admin

gcloud projects add-iam-policy-binding \
    --role $ROLE $PROJECT_ID \
    --member serviceAccount:$SA

gcloud iam service-accounts keys \
    create creds.json \
    --project $PROJECT_ID \
    --iam-account $SA

kubectl --namespace crossplane-system \
    create secret generic gcp-creds \
    --from-file key=./creds.json

kubectl crossplane install provider \
    crossplane/provider-gcp:v0.15.0

kubectl get providers

# Repeat the previous command until `HEALTHY` column is set to `True`

echo "apiVersion: gcp.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  projectID: $PROJECT_ID
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: gcp-creds
      key: key" \
    | kubectl apply --filename -

#########
# Intro #
#########

kubectl apply --filename gke.yaml

# IaC - Any tool can do it
# We need more
# We need to avoid fragmentation and use a single API that can be used to manage everything (Kube API)
# We need to be able to leverage Kubernetes ecosystem
# We need to be able to create contracts with processes that will ensure that the actual state is almost always the same as the desired state (GitOps)

####################
# Create resources #
####################

cat gke.yaml

echo https://console.cloud.google.com/kubernetes/list?project=$PROJECT_ID

# Open it

watch kubectl get gkeclusters

watch kubectl get nodepools

################################
# Doing what shouldn't be done #
################################

export KUBECONFIG=$PWD/kubeconfig.yaml

gcloud container clusters \
    get-credentials devops-toolkit \
    --region us-east1 \
    --project $PROJECT_ID

watch kubectl get nodes

# Open the Web console and add the missing zones

####################
# Update resources #
####################

cat gke-region.yaml

diff gke-region.yaml gke.yaml

cp gke-region.yaml production/gke.yaml

git add .

git commit -m "GKE"

git push

open http://argo-cd.$BASE_HOST

watch kubectl get nodes

#####################
# Destroy resources #
#####################

rm production/gke.yaml

git add .

git commit -m "GKE"

git push

gcloud projects delete $PROJECT_ID

minikube delete

##################
# Final thoughts #
##################

# Cons:
# - Needs a k8s cluster (local or "real")
# - Growing, but still small number of CRDs

# Pros:
# - Auto drift detection and sync
# - GitOps-friendly
# - Works well inside the k8s ecosystem

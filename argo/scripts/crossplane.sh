TODO: Intro

#################
# Setup Cluster #
#################

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# Please watch https://youtu.be/C0v5gJSWuSo if you are not familiar with kind
# Feel free to use any other Kubernetes platform
kind create cluster --config kind.yaml

# Only if using kind.
# If you are not using kind, please install Ingress any way that fits your Kubernetes distribution
kubectl apply \
    --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

kubectl create namespace crossplane-system

kubectl create namespace a-team

#################
# Setup Argo CD #
#################

# If not using kind, replace `127.0.0.1` with the base host accessible through NGINX Ingress
export INGRESS_HOST=127.0.0.1

helm repo add argo \
    https://argoproj.github.io/argo-helm

helm repo update

helm upgrade --install \
    argocd argo/argo-cd \
    --namespace argocd \
    --create-namespace \
    --set server.ingress.hosts="{argo-cd.$INGRESS_HOST.nip.io}" \
    --set server.ingress.enabled=true \
    --set server.extraArgs="{--insecure}" \
    --set controller.args.appResyncPeriod=30 \
    --wait

kubectl create namespace production

kubectl apply --filename argocd-app.yaml

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
    argo-cd.$INGRESS_HOST.nip.io

argocd account update-password \
    --current-password $PASS \
    --new-password admin123

echo http://argo-cd.$INGRESS_HOST.nip.io

#############
# Setup AWS #
#############

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" >aws-creds.conf

kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf

#############
# Setup GCP #
#############

export PROJECT_ID=devops-toolkit-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo "https://console.cloud.google.com/billing/enable?project=$PROJECT_ID"

# Set the billing account

echo "https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=$PROJECT_ID"

# Open the URL and *ENABLE API*

echo "https://console.cloud.google.com/apis/library/sqladmin.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE API*

export SA_NAME=devops-toolkit

export SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts \
    create $SA_NAME \
    --project $PROJECT_ID

gcloud projects add-iam-policy-binding \
    --role roles/admin $PROJECT_ID \
    --member serviceAccount:$SA

gcloud iam service-accounts keys \
    create gcp-creds.json \
    --project $PROJECT_ID \
    --iam-account $SA

kubectl --namespace crossplane-system \
    create secret generic gcp-creds \
    --from-file creds=./gcp-creds.json

cat crossplane-config/providers.yaml \
    | sed -e "s@projectID: .*@projectID: $PROJECT_ID@g" \
    | tee crossplane-config/providers.yaml

####################
# Setup Crossplane #
####################

helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install \
    crossplane crossplane-stable/crossplane \
    --namespace crossplane-system \
    --create-namespace \
    --wait

kubectl apply \
    --filename crossplane-config

# Please re-run the previous command if the output is `unable to recognize ...`

###########################
# Crossplane Compositions #
###########################

cat crossplane-config/definition-k8s.yaml

cat crossplane-config/composition-eks.yaml

cat examples/aws-eks-no-claim.yaml

cp examples/aws-eks-no-claim.yaml \
    infra/aws-eks.yaml

git add .

git commit -m "EKS"

git push

# TODO: Continue

# GitOps?

kubectl get managed,releases

cat examples/google-gke-no-claim.yaml

cp examples/google-gke-no-claim.yaml \
    infra/google-gke.yaml

git add .

git commit -m "EKS"

git push

kubectl get managed,releases

kubectl get gcp

cat examples/google-mysql-no-claim.yaml

cp examples/google-mysql-no-claim.yaml \
    infra/google-mysql.yaml

git add .

git commit -m "EKS"

git push

kubectl get gcp

###########
# Destroy #
###########

rm -rf infra/*.yaml

git add .

git commit -m "Destroy everything"

git push

kubectl get managed,releases

kind delete cluster

gcloud projects delete $PROJECT_ID











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

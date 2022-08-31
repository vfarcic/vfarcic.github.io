# TODO: EKS cluster
# TODO: NGINX Ingress
# TODO: SQL in GCP

#########
# Setup #
#########

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# TODO: Remove
# cp cluster-orig.yaml cluster.yaml

# Install Crossplane CLI from https://crossplane.io/docs/v1.3/getting-started/install-configure.html#start-with-a-self-hosted-crossplane

kind create cluster --config kind.yaml

kubectl create namespace team-a

up uxp install

up cloud login \
    --profile=devops-toolkit \
    --account=devops-toolkit

up cloud controlplane attach demo \
    --profile=devops-toolkit \
    | up uxp connect -

kubectl apply --filename definition.yaml

#############
# Setup GCP #
#############

export PROJECT_ID=devops-toolkit-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

open "https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?project=$PROJECT_ID"

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
    create gcp-creds.json \
    --project $PROJECT_ID \
    --iam-account $SA

kubectl --namespace upbound-system \
    create secret generic gcp-creds \
    --from-file creds=./gcp-creds.json

kubectl crossplane install provider \
    crossplane/provider-gcp:v0.17.1

# Wait for a few moments for the provider to be up-and-running

echo "apiVersion: gcp.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  projectID: $PROJECT_ID
  credentials:
    source: Secret
    secretRef:
      namespace: upbound-system
      name: gcp-creds
      key: creds" \
    | kubectl apply --filename -

kubectl apply --filename gcp-upbound.yaml

#############
# Setup AWS #
#############

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" | tee aws-creds.conf

kubectl --namespace upbound-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf

kubectl crossplane install provider \
    crossplane/provider-aws:v0.19.0

# Wait for a few moments for the provider to be up-and-running

echo "apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: upbound-system
      name: aws-creds
      key: creds" \
    | kubectl apply --filename -

kubectl apply --filename aws-upbound.yaml

#########
# Setup #
#########

kubectl apply --filename gke.yaml

############################
# Infra Without Composites #
############################

cat gke.yaml

kubectl get managed

open "https://console.cloud.google.com/kubernetes/list?project=$PROJECT_ID"

# Change something

###########################
# Creating infrastructure #
###########################

cat cluster.yaml

# Change `spec.compositionRef.name` to `cluster-aws`

kubectl apply --filename cluster.yaml

watch kubectl get managed

#######################
# Defining composites #
#######################

# It would be even better with Argo CD or Flux

cat definition.yaml

cat azure.yaml

cat gcp.yaml

cat aws.yaml

kubectl explain \
    compositekubernetescluster \
    --recursive

#####################
# Resource statuses #
#####################

kubectl get compositekubernetesclusters

kubectl describe \
    compositekubernetescluster team-a

kubectl get managed

##################
# Updating Infra #
##################

# Modify gke.yaml

kubectl apply --filename gke.yaml

####################################
# Drift Detection & Reconciliation #
####################################

open "https://console.aws.amazon.com/vpc/home?region=us-east-1#igws:"

#############################
# Destroying infrastructure #
#############################

kubectl delete --filename cluster.yaml

kubectl delete --filename gke.yaml

watch kubectl get managed

# Wait until everything is removed

gcloud projects delete $PROJECT_ID

kind delete cluster

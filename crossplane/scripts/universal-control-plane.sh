#################
# Setup Cluster #
#################

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# Using Rancher Desktop for the demo, but it can be any other Kubernetes cluster with Ingress

# If not using Rancher Desktop, replace `127.0.0.1` with the base host accessible through NGINX Ingress
export INGRESS_HOST=127.0.0.1

kubectl create namespace crossplane-system

kubectl create namespace a-team

kubectl create namespace production

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
    --filename crossplane-config/provider-aws.yaml

# Please re-run the previous command if the output is `unable to recognize ...`

kubectl apply \
    --filename crossplane-config/definition-k8s.yaml

kubectl apply \
    --filename crossplane-config/composition-eks.yaml

#########
# TODO: #
#########

# Today, from the users perspective, application management is (almost) always one step ahead of infrastructure and services

# How do we manage applications?
# We use APIs like k8s

# - We can tell k8s API what the desired state is

cat devops-toolkit/base/deployment.yaml

# - There is a scheduler who's trying to figure out what to do, when to do it, and where to do it

kubectl apply \
    --kustomize devops-toolkit/overlays/production

# - There is a scheduler with automatic drift detection and reconciliation

kubectl --namespace production \
    delete pods \
    --selector app=devops-toolkit

kubectl --namespace production \
    get pods

# - We can query the API about the state of any resource

kubectl get pods --all-namespaces

kubectl --namespace production \
    get deployments

# - It's not vendor-specific

# - An API must have a control plane behind it

# No one has all those things

# None of the IaC tools do that
# - CloudFormation is vendor-specific
# - Terraform and Pulumi do not have an API nor they have a scheduler (drift detection and reconciliation)
# - etc.

# We need to change that.
# We need to apply the same principles to infrastructure and services as to applications
# We need a universal API and a universal control plane behind it

# We can certainly use the APIs with infrastructure and services
# Azure has an API
# AWS has an API
# Google Cloud has an API
# Everyone has an API
# Everyone's API is their API

# Most of users choose NOT to use those APIs directly because:
# - They are vendor specific
# - They often do not allow us to define the desired state

# We choose NOT to use vendor-specific APIs in favor of CLI-only type of tools, namely IaC
# We chose a unified CLI-only approach because it allows us to unify all those APIs at the expense of not having an API at all.
# Cloud is fragmented and without a standard and (almost) no one is thinking to create an API to manage them all.

# I want to be able to:
# - Define the desired state
# - Interact with the API directly
# - Have a single API for everything
# - Have a scheduler

# That's where Kubernetes comes in.
# It is considered a universal API but only for applications.
# It has (probably) the most advanced scheduler
# Why not extend it to everything?
# Why not leverage Kubernetes API to build an API that can be used for everything, from applications, through infrastructure, all the way until services?



#################
# Desired State #
#################

TODO:

###############################
# Scheduler For What/When/How #
###############################

TODO:

#################
# Query the API #
#################

TODO:

####################################################
# Scheduler For Drift Detection And Reconciliation #
####################################################

TODO:

#######################
# NOT Vendor Specific #
#######################

TODO:

#####################
# BONUS: Composites #
#####################

TODO:

###########################
# Universal Control Plane #
###########################

TODO:
















#########
# Setup #
#########

git clone https://github.com/vfarcic/crossplane-composite-demo

cd crossplane-composite-demo

cp cluster-orig.yaml cluster.yaml

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

# Change `spec.compositionRef.name` to `cluster-aws`

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

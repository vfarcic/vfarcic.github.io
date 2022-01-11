#################
# Setup Cluster #
#################

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# Using Rancher Desktop for the demo, but it can be any other Kubernetes cluster with Ingress

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

cat crossplane-config/provider-config-gcp.yaml \
    | sed -e "s@projectID: .*@projectID: $PROJECT_ID@g" \
    | tee crossplane-config/provider-config-gcp.yaml

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
    --filename crossplane-config/provider-gcp.yaml

kubectl apply \
    --filename crossplane-config/provider-aws.yaml

kubectl apply \
    --filename crossplane-config/provider-kubernetes.yaml

kubectl apply \
    --filename crossplane-config/provider-config-gcp.yaml

# Please re-run the previous command if the output is `unable to recognize ...`

kubectl apply \
    --filename crossplane-config/provider-config-aws.yaml

# Please re-run the previous command if the output is `unable to recognize ...`

kubectl apply \
    --filename crossplane-config/config-k8s.yaml

kubectl get pkgrev

# Wait until all the packages are healthy

#########
# Intro #
#########

# Today, from the users perspective, application management is (almost) always one step ahead of infrastructure and services

# How do we manage applications?
# We use APIs like k8s

# - We can tell k8s API what the desired state is

cat devops-toolkit/base/deployment.yaml

# - There is a scheduler trying to figure out what to do, when to do it, and where to do it

kubectl apply \
    --kustomize devops-toolkit/overlays/production

# - There is a scheduler with automatic drift detection and reconciliation

kubectl --namespace production \
    get pods

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

# None of the IaC tools do that
# - `aws`, `gcloud`, `az`, etc. are only CLIs that hide the API
# - CloudFormation, ARM, etc. is vendor-specific
# - Terraform, Pulumi, Ansible, etc do not have an API nor they have a scheduler (drift detection and reconciliation)
# - etc.

# No one has all those things

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

# We chose NOT to use vendor-specific APIs in favor of CLI-only type of tools, namely IaC
# We chose a unified CLI-only approach because it allows us to unify all those APIs at the expense of not having an API at all.
# Cloud is fragmented and without a standard and (almost) no one is thinking to create an API to manage them all.

# I want to be able to:
# - Define the desired state
# - Interact with the API directly
# - Have a single API for everything
# - Have a scheduler
# - Extend an API

# That's where Kubernetes comes in.
# It is considered a universal API, but only for applications.
# It has (probably) the most advanced scheduler
# Why not extend it to everything?
# Why not leverage Kubernetes API to build an API that can be used for everything, from applications, through infrastructure, all the way until services?

#######################################
# Desired State / NOT Vendor Specific #
#######################################

cat examples/google-gke-no-xrd.yaml

###############################
# Scheduler For What/When/How #
###############################

kubectl apply \
    --filename examples/google-gke-no-xrd.yaml

#################
# Query the API #
#################

kubectl get clusters.container.gcp.crossplane.io

kubectl get gcp

kubectl get managed

kubectl describe \
    clusters.container.gcp.crossplane.io \
    a-team-gke-no-xrd

kubectl explain \
    clusters.container.gcp.crossplane.io \
    --recursive

####################################################
# Scheduler For Drift Detection And Reconciliation #
####################################################

# Delete the node pool

kubectl get nodepools

kubectl delete \
    --filename examples/google-gke-no-xrd.yaml

#####################
# Extending the API #
#####################

cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml

cat examples/aws-eks.yaml

kubectl --namespace a-team apply \
    --filename examples/aws-eks.yaml

kubectl get managed

kubectl --namespace a-team delete \
    --filename examples/aws-eks.yaml

###########################
# Universal Control Plane #
###########################

# Diagram

###########
# Destroy #
###########

kubectl get managed

# Destroy or reset the management cluster (e.g., Rancher Desktop)

gcloud projects delete $PROJECT_ID

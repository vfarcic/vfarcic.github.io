TODO: Intro

#################
# Setup Cluster #
#################

# Create a management Kubernetes cluster (any should do)

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

kubectl create namespace crossplane-system

kubectl create namespace a-team

kubectl create namespace b-team

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
    --filename crossplane-config/config-k8s.yaml

kubectl apply \
    --filename crossplane-config/config-sql.yaml

kubectl apply \
    --filename crossplane-config/provider-kubernetes.yaml

kubectl apply \
    --filename crossplane-config/provider-config-gcp.yaml

# Please re-run the previous command if the output is `unable to recognize ...`

kubectl apply \
    --filename crossplane-config/provider-config-aws.yaml

# Please re-run the previous command if the output is `unable to recognize ...`

###########################
# Crossplane Compositions #
###########################

cat examples/google-gke.yaml

kubectl --namespace a-team apply \
    --filename examples/google-gke.yaml

cat examples/aws-eks.yaml

kubectl --namespace a-team apply \
    --filename examples/aws-eks.yaml

cat examples/google-mysql.yaml

kubectl --namespace a-team apply \
    --filename examples/google-mysql.yaml

kubectl get managed

kubectl get gcp

# Destroy stuff

cat packages/k8s/definition.yaml

ls -1 packages/k8s/

cat packages/k8s/eks.yaml

cat packages/sql/definition.yaml

cat packages/sql/google.yaml

kubectl get managed

###########
# Destroy #
###########

kubectl --namespace a-team delete \
    --filename examples/aws-eks.yaml

kubectl --namespace a-team delete \
    --filename examples/google-gke.yaml

kubectl --namespace a-team delete \
    --filename examples/google-mysql.yaml

kubectl get managed

# Destroy or reset the management cluster

gcloud projects delete $PROJECT_ID

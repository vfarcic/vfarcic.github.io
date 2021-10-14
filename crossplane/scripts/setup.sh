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

# If not using kind, replace `127.0.0.1` with the base host accessible through NGINX Ingress
export INGRESS_HOST=127.0.0.1

kubectl create namespace crossplane-system

kubectl create namespace a-team

#################
# Setup Argo CD #
#################

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

##############
# Setup Civo #
##############

# Replace `[...]` with your Civo token
export CIVO_TOKEN=[...]

export CIVO_TOKEN_ENCODED=$(\
    echo $CIVO_TOKEN | base64)

echo "apiVersion: v1
kind: Secret
metadata:
  namespace: crossplane-system
  name: civo-creds
type: Opaque
data:
  credentials: $CIVO_TOKEN_ENCODED" \
    | kubectl apply --filename -

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

###########
# Destroy #
###########

kind delete cluster

gcloud projects delete $PROJECT_ID

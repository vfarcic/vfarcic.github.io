# Source: https://gist.github.com/868c50d44618a6fa046405d309a6b104

TODO: Intro

#################
# Setup Cluster #
#################

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# Start Rancher Desktop

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
# Argo CD #
###########

cat orig/devops-toolkit.yaml

# Show the Argo CD UI

cp orig/devops-toolkit.yaml apps/.

git add .

git commit -m "My app"

git push

kubectl --namespace production \
    get all,ingresses

###########################
# Crossplane Compositions #
###########################

cat crossplane-config/definition-k8s.yaml

cat crossplane-config/composition-eks.yaml

cat examples/aws-eks-no-claim.yaml

cp examples/aws-eks-no-claim.yaml \
    infra/.

git add .

git commit -m "EKS"

git push

kubectl get managed,releases

cat examples/civo-no-claim.yaml

cp examples/civo-no-claim.yaml \
    infra/.

git add .

git commit -m "Civo"

git push

kubectl get managed

kubectl get civo

cat infra/civo.yaml \
    | sed -e "s@minNodeCount: .*@minNodeCount: 3@g" \
    | tee infra/civo.yaml

git add .

git commit -m "Civo"

git push

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

rm -rf apps/*.yaml

rm -rf infra/*.yaml

git add .

git commit -m "Destroy everything"

git push

kubectl get managed,releases

# Reset the Rancher Desktop cluster

gcloud projects delete $PROJECT_ID

export CIVO_REGION=[...]

civo firewall remove \
    "Kubernetes cluster: a-team-ck" \
    --region $CIVO_REGION \
    --yes
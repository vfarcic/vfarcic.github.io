#####################################
# Developers do not need Kubernetes #
#####################################

#########
# Setup #
#########

# Using Rancher Desktop for the demo, but it can be any other Kubernetes cluster with Ingress

# If not using Rancher Desktop, replace `127.0.0.1` with the base host accessible through Ingress
export INGRESS_HOST=127.0.0.1

git clone \
    https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

kubectl create namespace a-team

kubectl create namespace production

kubectl create namespace crossplane-system

cat charts/sql/values.yaml \
    | sed -e "s@host: .*@host: devops-toolkit.$INGRESS_HOST.nip.io@g" \
    | tee charts/sql/values.yaml

cat examples/app-backend-sql.yaml \
    | sed -e "s@host: .*@host: devops-toolkit.$INGRESS_HOST.nip.io@g" \
    | tee examples/app-backend-sql.yaml

#############
# Setup GCP #
#############

export PROJECT_ID=devops-toolkit-$(date +%Y%m%d%H%M%S)

gcloud projects create $PROJECT_ID

echo "https://console.cloud.google.com/billing/enable?project=$PROJECT_ID"

# Set the billing account

echo "https://console.cloud.google.com/apis/library/sqladmin.googleapis.com?project=$PROJECT_ID"

# Open the URL and *ENABLE API*

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
    --filename crossplane-config/provider-sql.yaml

kubectl apply \
    --filename crossplane-config/config-sql.yaml

kubectl apply \
    --filename crossplane-config/config-app.yaml

kubectl apply \
    --filename crossplane-config/provider-kubernetes-incluster.yaml

kubectl apply \
    --filename crossplane-config/provider-config-gcp.yaml

# Please re-run the previous command if the output is `unable to recognize ...`

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
    --values argocd/helm-values.yaml \
    --wait

kubectl apply --filename argocd/project.yaml

kubectl apply --filename argocd/apps.yaml

echo http://argo-cd.$INGRESS_HOST.nip.io

# Open it in a browser
# User `admin`, password `admin123`

####################
# Setup SchemaHero #
####################

kubectl krew install schemahero

kubectl schemahero install

#######
# k8s #
#######

# Since the emergence of Kubernetes, we hoped that developers will adopt it.
# That did not happen, and it will likely never happen.

# It's too complicated.

# Is it stateless or stateful?
# Does it scale automatically or not?
# Is it publicly explosed or not?
# etc.

# What if someone else created everything for you?

# Dev's are not in control any more. They cannot define what an app is.

# Developers do not need Kubernetes.
# They need to write code, and they need an easy way to build, test, and deploy their applications.
# It is unrealistic to expect developers to spend years learning Kubernetes.
# Devs need a way to define applications, and not Kubernetes resources
# Devs need a way to just say "here's my code, run it!"

# On the other hand, operators and sysadmins do need Kubernetes.
# It gives them all they need to run systems at scale.
# Nevertheless, operators also need to empower developers to deploy their own applications.
# They need to enable developers by providing services rather than doing actual deployments or defining app manifests.

# So, we have conflicting needs.
# Kubernetes is necessary to some and a burden to others.
# Can we satisfy all?
# Can we have a system that is based on Kubernetes yet easy to operate?
# Can we make Kubernetes disappear and become an implementation detail running in the background?

########
# Demo #
########

helm upgrade --install \
    sql-demo charts/sql/. \
    --namespace a-team \
    --create-namespace

kubectl --namespace a-team \
    get pods

kubectl --namespace a-team \
    describe pod --selector app=sql-demo

cat charts/sql/templates/app.yaml

cat packages/sql/google.yaml

cat charts/sql/templates/db.yaml

kubectl get managed

kubectl --namespace a-team \
    get pods

curl "http://devops-toolkit.$INGRESS_HOST.nip.io/addVideo?id=RaoKcJGchKM&name=Terraform+vs+Pulumi+vs+Crossplane&url=https://youtu.be/RaoKcJGchKM"

kubectl --namespace a-team logs \
    --selector app=sql-demo

kubectl --namespace a-team \
    get secrets

export DB_ENDPOINT=$(kubectl \
    --namespace a-team \
    get secret sql-demo \
    --output jsonpath="{.data.endpoint}" \
    | base64 -d)

export DB_PASS=$(kubectl \
    --namespace a-team \
    get secret sql-demo \
    --output jsonpath="{.data.password}" \
    | base64 -d)

helm upgrade --install \
    sql-demo charts/sql/. \
    --namespace a-team \
    --set schema.endpoint=$DB_ENDPOINT \
    --set schema.password=$DB_PASS \
    --wait

cat charts/sql/templates/schema.yaml

curl "http://devops-toolkit.$INGRESS_HOST.nip.io/addVideo?id=RaoKcJGchKM&name=Terraform+vs+Pulumi+vs+Crossplane&url=https://youtu.be/RaoKcJGchKM"

curl "http://devops-toolkit.$INGRESS_HOST.nip.io/addVideo?id=yrj4lmScKHQ&name=Crossplane+with+Terraform&url=https://youtu.be/yrj4lmScKHQ"

curl "http://devops-toolkit.$INGRESS_HOST.nip.io/getVideos"

cat charts/sql/templates/app.yaml

cat charts/sql/templates/crossplane-app.yaml

helm upgrade --install \
    sql-demo charts/sql/. \
    --namespace a-team \
    --set crossplaneApp=true \
    --reuse-values \
    --wait

kubectl --namespace a-team get appclaims

kubectl --namespace a-team get all,ingresses

curl "http://devops-toolkit.$INGRESS_HOST.nip.io/getVideos"

helm delete sql-demo --namespace a-team

cat examples/app-backend-sql-no-claim.yaml

# Show Argo CD

cp examples/app-backend-sql-no-claim.yaml \
    apps/.

git add .

git commit -m "My app"

git push

# Show Argo CD

kubectl --namespace a-team \
    get all,ingresses,appclaims,cloudsqlinstances

cat packages/sql/definition.yaml

cat packages/sql/google.yaml

###########
# Destroy #
###########

rm apps/*.yaml

git add .

git commit -m "Destroy everything"

git push

kubectl get cloudsqlinstances

# Repeat the previous command until all the managed resources are removed

gcloud projects delete $PROJECT_ID

# Destroy or reset the management cluster

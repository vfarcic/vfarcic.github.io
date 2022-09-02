#####################################
# Developers do not need Kubernetes #
#####################################

#########
# Setup #
#########

# Create a Kubernetes cluster with Ingress (e.g., https://gist.github.com/925653c9fbf8cce23c35eedcd57de86e)

# Replace `[...]` with the Ingress Service external IP
export INGRESS_HOST=[...]

cd crossplane-kubevela-argocd-demo

kubectl apply --filename sealed-secrets

# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
" | tee aws-creds.conf

kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee crossplane-configs/aws-creds.yaml

git add .

git commit -m "Personalization"

git push

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

kubectl apply --filename project.yaml

kubectl apply --filename apps.yaml

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

open http://argo-cd.$INGRESS_HOST.nip.io

cp orig/cluster.yaml team-a-infra/.

git add .

git commit -m "Team A infra"

git push

watch kubectl get managed,releases

# Wait until the `cluster` resource is ready.

./config-cluster-aws.sh team-a

# Open a second terminal
# Enter the same directory as the one used in the first terminal

# In the second terminal
# Replace `[...]` with your access key ID`
export AWS_ACCESS_KEY_ID=[...]

# In the second terminal
# Replace `[...]` with your secret access key
export AWS_SECRET_ACCESS_KEY=[...]

# In the second terminal
export KUBECONFIG=$PWD/kubeconfig.yaml

##################
# Infrastructure #
##################

# In the second terminal
cat team-a-infra/cluster.yaml

# In the second terminal
gh repo view --web

# Show Argo CD

# In the first terminal
kubectl get managed,releases

# Wait until all the resources are ready and synced

################
# Applications #
################

# In the second terminal
cat orig/my-app.yaml

# In the second terminal
cp orig/my-app.yaml team-a-apps/.

# In the second terminal
git add .

# In the second terminal
git commit -m "Team A apps"

# In the second terminal
git push

# In the second terminal
watch kubectl --namespace production \
    get all,hpa,ingress

##########################
# How did it all happen? #
##########################

# In the first terminal
cat apps.yaml

# In the first terminal
ls -1 production

# In the first terminal
cat production/team-a-infra.yaml 

# In the first terminal
cat crossplane-compositions/definition.yaml

# In the first terminal
cat crossplane-compositions/cluster-aws.yaml

# In the second terminal
cat team-a-infra/cluster.yaml

# In the first terminal
cat production/team-a-apps.yaml

# In the first terminal
cat team-a-app-reqs/kubevela.yaml

# In the second terminal
cat team-a-apps/my-app.yaml

# Show Argo CD

###########################
# Deleting infrastructure #
###########################

# In the second terminal
rm team-a-infra/cluster.yaml

# In the second terminal
git add .

# In the second terminal
git commit -m "Remove the cluster"

# In the second terminal
git push

# In the first terminal
watch kubectl get managed

###########
# Destroy #
###########

# Wait until all the resources are removed

# In the second terminal
rm -rf team-a-apps

# In the second terminal
rm -rf team-a-app-reqs

# In the second terminal
rm production/team-a-apps.yaml

# In the second terminal
rm production/team-a-app-reqs.yaml

# In the second terminal
git add .

# In the second terminal
git commit -m "Revert"

# In the second terminal
git push

# Delete the initial cluster

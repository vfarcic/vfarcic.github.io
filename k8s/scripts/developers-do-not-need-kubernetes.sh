#####################################
# Developers do not need Kubernetes #
#####################################

#########
# Setup #
#########

# Feel free to use any other Kubernetes distribution
minikube start

# If not using Minikube, install Ingress in whichever way is suitable for your Kubernetes distribution
minikube addons enable ingress

# If not using Minikube, replace the value with the IP through which the Ingress Service can be accessed.
export INGRESS_HOST=$(minikube ip)

cd crossplane-kubevela-argocd-demo

cat argo-cd/overlays/production/ingress.yaml \
    | sed -e "s@host: .*@host: argo-cd.$INGRESS_HOST.nip.io@g" \
    | tee argo-cd/overlays/production/ingress.yaml

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

kustomize build \
    argo-cd/overlays/production \
    | kubectl apply --filename -

kubectl --namespace argocd \
    rollout status \
    deployment argocd-server

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
    --new-password admin

echo http://argo-cd.$INGRESS_HOST.nip.io

cp orig/cluster.yaml team-a-infra/.

git add .

git commit -m "Team A infra"

git push

watch kubectl get clusters,nodegroup,iamroles,iamrolepolicyattachments,vpcs,securitygroups,subnets,internetgateways,routetables,providerconfigs,releases

./config-cluster-aws.sh team-a

# In the second terminal
export KUBECONFIG=$PWD/kubeconfig.yaml

##################
# Infrastructure #
##################

cat team-a-infra/cluster.yaml

# Show Argo CD

# In a second terminal
kubectl get clusters,nodegroup,iamroles,iamrolepolicyattachments,vpcs,securitygroups,subnets,internetgateways,routetables,providerconfigs,releases

# Wait until all the resources are ready and synced

################
# Applications #
################

cat orig/my-app.yaml

cp orig/my-app.yaml team-a-apps/.

git add .

git commit -m "Team A apps"

git push

# In the second terminal
watch kubectl --namespace production \
    get all,hpa,ingress

##########################
# How did it all happen? #
##########################

# In the second terminal
cat apps.yaml

# In the second terminal
ls -1 production

# In the second terminal
cat production/team-a-infra.yaml 

# In the second terminal
cat crossplane-compositions/definition.yaml

# In the second terminal
cat crossplane-compositions/cluster-aws.yaml

cat team-a-infra/cluster.yaml

# In the second terminal
cat production/team-a-apps.yaml

# In the second terminal
cat team-a-app-reqs/kubevela.yaml

cat team-a-apps/my-app.yaml

# Show Argo CD

###########################
# Deleting infrastructure #
###########################

rm team-a-infra/cluster.yaml

git add .

git commit -m "Remove the cluster"

git push

# In the second terminal
unset KUBECONFIG

# In the second terminal
watch kubectl get clusters,nodegroup,iamroles,iamrolepolicyattachments,vpcs,securitygroups,subnets,internetgateways,routetables,providerconfigs

###########
# Destroy #
###########

# Wait until all the resources are removed

rm -rf team-a-apps

rm -rf team-a-app-reqs

rm production/team-a-apps.yaml

rm production/team-a-app-reqs.yaml

git add .

git commit -m "Revert"

git push

minikube delete

# TODO: Link to the video
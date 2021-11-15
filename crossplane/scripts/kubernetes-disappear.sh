# What is GitOps
# Process is not an issue
# Manifests are the problem
# Infra and apps

# TODO: Setup the management cluster with Argo CD
# TODO: https://morningspace.medium.com/using-crossplane-in-gitops-common-considerations-4b78c71d50eb?s=03
# TODO: Add Argo CD Application to the management cluster

#################
# Setup Cluster #
#################

# Watch https://youtu.be/BII6ZY2Rnlc if you are not familiar with GitHub CLI
gh repo fork vfarcic/devops-toolkit-crossplane \
    --clone

cd devops-toolkit-crossplane

# Using Rancher Desktop for the demo, but it can be any other Kubernetes cluster with Ingress

# If not using Rancher Desktop, replace `127.0.0.1` with the base host accessible through NGINX Ingress
export INGRESS_HOST=127.0.0.1

kubectl create namespace crossplane-system

kubectl create namespace a-team

kubectl create namespace production

export GIT_URL=$(git remote get-url origin)

cat examples/aws-eks-gitops.yaml \
    | sed -e "s@gitOpsRepo: .*@gitOpsRepo: $GIT_URL@g" \
    | tee examples/aws-eks-gitops.yaml

cat argocd/apps.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/apps.yaml

cat argocd/infra.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/infra.yaml

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
    --filename crossplane-config/provider-helm.yaml

kubectl apply \
    --filename crossplane-config/provider-kubernetes.yaml

kubectl apply \
    --filename crossplane-config/definition-k8s.yaml

kubectl apply \
    --filename crossplane-config/composition-eks.yaml

# TODO: Remove
# kubectl apply \
#     --filename crossplane-config/definition-app.yaml

# TODO: Remove
# kubectl apply \
#     --filename crossplane-config/composition-app-frontend.yaml

# TODO: Remove
# export SA=$(kubectl \
#     --namespace crossplane-system \
#     get serviceaccount \
#     --output name \
#     | grep provider-kubernetes \
#     | sed -e 's|serviceaccount\/|crossplane-system:|g')

# TODO: Remove
# kubectl create clusterrolebinding \
#     provider-kubernetes-admin-binding \
#     --clusterrole cluster-admin \
#     --serviceaccount="${SA}"

# TODO: Remove
# kubectl apply \
#     --filename examples/app-frontend-no-claim.yaml

# TODO: Remove
# kubectl --namespace a-team \
#     get all,ingresses

# TODO: Remove
# TODO: Add Ingress

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
    --set configs.secret.argocdServerAdminPassword='$2a$10$m3eTlEdRen0nS86c5Zph5u/bDFQMcWZYdG3NVdiyaACCqoxLJaz16' \
    --set configs.secret.argocdServerAdminPasswordMtime="2021-11-08T15:04:05Z" \
    --wait

kubectl apply --filename argocd/project.yaml

kubectl apply --filename argocd/infra.yaml

echo http://argo-cd.$INGRESS_HOST.nip.io

# Open it in a browser
# User `admin`, password `admin123`

#########################
# GitOps-Ready Clusters #
#########################

cat examples/aws-eks-gitops-no-claim.yaml

cp examples/aws-eks-gitops-no-claim.yaml \
    infra/aws-eks.yaml

# Modify `spec.parameters.gitOpsRepo` in `infra/aws-eks.yaml`

git add .

git commit -m "My cluster"

git push

kubectl get managed,releases,objects.kubernetes.crossplane.io

cat crossplane-config/definition-k8s.yaml

cat crossplane-config/composition-eks.yaml

cat infra/aws-eks.yaml

kubectl get managed,releases,objects.kubernetes.crossplane.io

kubectl --namespace crossplane-system \
    get secret a-team-eks-no-claim-ekscluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl get namespaces

kubectl --namespace argocd get applications

kubectl --namespace argocd port-forward \
    svc/a-team-eks-no-claim-argocd-server \
    8080:443 &

# Open http://localhost:8080 in a browser
# User `admin`, password `admin123`

unset KUBECONFIG

# Go to the GitOps repo

mkdir -p apps

cat orig/devops-toolkit-kubevela.yaml

cp orig/devops-toolkit-kubevela.yaml apps/

git add .

git commit -m "Adding dot"

git push

kubectl --namespace crossplane-system \
    get secret a-team-eks-no-claim-ekscluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl --namespace production \
    get all,hpa,ingresses

###########
# Destroy #
###########

unset KUBECONFIG

cd ../devops-toolkit-crossplane

pkill kubectl

rm infra/*.yaml

git add .

git commit -m "Removing dot"

git push

kubectl get managed

# Repeat the previous command until all the managed resources are removed

# Destroy or reset the management cluster

# Destroy the GitOps repo

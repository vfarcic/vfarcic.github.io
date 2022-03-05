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

cp examples/namespaces.yaml infra/.

export GIT_URL=$(git remote get-url origin)

cat examples/k8s/aws-eks-gitops.yaml \
    | sed -e "s@gitOpsRepo: .*@gitOpsRepo: $GIT_URL@g" \
    | tee examples/k8s/aws-eks-gitops.yaml

cat argocd/apps.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/apps.yaml

cat argocd/infra.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee argocd/infra.yaml

cat examples/crossplane-definitions.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee examples/crossplane-definitions.yaml

cat examples/crossplane-provider-configs.yaml \
    | sed -e "s@repoURL: .*@repoURL: $GIT_URL@g" \
    | tee examples/crossplane-provider-configs.yaml

##################
# Sealed Secrets #
##################

kubectl apply \
    --filename https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.17.2/controller.yaml

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
" >aws-creds.conf

# Please watch https://youtu.be/xd2QoV6GJlc if you are not familiar with SealedSecrets
kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee crossplane-provider-configs/aws-creds.yaml

####################
# Setup Crossplane #
####################

cp crossplane-config/provider-kubernetes.yaml \
    crossplane-config/config-k8s.yaml \
    crossplane-config/config-gitops.yaml \
    crossplane-definitions/.

cp crossplane-config/provider-config-aws.yaml \
    crossplane-provider-configs/.

cp examples/crossplane.yaml \
    examples/crossplane-definitions.yaml \
    examples/crossplane-provider-configs.yaml \
    infra/.

git add .

git commit -m "Infra"

git push

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

kubectl apply --filename argocd/infra.yaml

echo http://argo-cd.$INGRESS_HOST.nip.io

# Open it in a browser
# User `admin`, password `admin123`

cp examples/aws-eks-gitops-no-claim.yaml \
    infra/aws-eks.yaml

# Modify `spec.parameters.gitOpsRepo` in `infra/aws-eks.yaml`

git add .

git commit -m "My cluster"

git push

###################
# What Is GitOps? #
###################

# Declarative
# Versioned and immutable
# Pulled automatically
# Continuously reconciled

############
# Why Now? #
############

# Chef and Puppet were fulfilling all GitOps principles
# Flux, Argo CD, Rancher Fleet, and others...
# Kubernetes API makes the difference

############
# Problems #
############

# Tools might not be GitOps-friendly (e.g., canary deployments)
# Approval flow (e.g., PR)

##################
# Why Only Apps? #
##################

# GitOps tools treat k8s as the actual state
# K8s is all about applications (containers)?
# K8s main strength is its API, not containers
# We need to convert Kube API into the universal API

###########################
# Universal Control Plane #
###########################

# Universal API combined with universal scheduler = universal control plane
# One place to manage everything everywhere; apps, services, infra
# Needs to be vendor-neutral (everyone is multi-cloud)

##################################
# Extending GitOps To Everything #
##################################

# If there is a universal control plane and it is based on k8s, GitOps becomes universal
# Git becomes the source of truth for everything
# Git becomes the only interaction point
# Git becomes a universal RBAC

####################
# What Is Missing? #
####################

# Scope (limited to containers)
# Adoption (limited to ops)

##############
# Crossplane #
##############

# - Based on Kube API
# - Vendor neutral (CNCF)
# - More mature than others
# - Shift-left (Compositions)
# - Enables Argo CD, Flux, and Rancher Fleet to be e2e and adopted by everyone

########
# Demo #
########

# Show Argo CD

cat infra/aws-eks.yaml

kubectl get managed

cat packages/k8s/definition.yaml

cat packages/k8s/eks.yaml

cat crossplane-config/config-k8s.yaml

cat packages/gitops/definition.yaml

cat packages/gitops/argo-cd.yaml

cat crossplane-config/config-gitops.yaml

cat infra/aws-eks.yaml

kubectl get managed

cat infra/aws-eks.yaml \
    | sed -e "s@minNodeCount: .*@minNodeCount: 5@g" \
    | tee infra/aws-eks.yaml

git add .

git commit -m "My cluster"

git push

kubectl get managed

# You might need to execute this command later if you see `You must be logged in to the server (Unauthorized)` messages when interacting with the new cluster.
kubectl --namespace crossplane-system \
    get secret a-team-eks-no-claim-cluster \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig.yaml

kubectl \
    --kubeconfig kubeconfig.yaml \
    --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf

kubectl \
    --kubeconfig kubeconfig.yaml \
    get namespaces

kubectl \
    --kubeconfig kubeconfig.yaml \
    --namespace argocd \
    get applications

kubectl \
    --kubeconfig kubeconfig.yaml \
    --namespace argocd port-forward \
    svc/a-team-gitops-no-claim-argocd-server \
    8080:443 &

# If one of the commands that use `kubeconfig.yaml` return an
#   error message `You must be logged in to the server`,
#   the credentials expired and you'll need to retrieve it again
#   with the previous command.

# Open http://localhost:8080 in a browser
# User `admin`, password `admin123`

cat examples/app/backend-local-k8s-postgresql-no-claim.yaml

cp examples/app/backend-local-k8s-postgresql-no-claim.yaml \
    apps-dev/.

git add .

git commit -m "Adding apps to dev"

git push

kubectl \
    --kubeconfig kubeconfig.yaml \
    get apps,sqls

kubectl \
    --kubeconfig kubeconfig.yaml \
    --namespace dev \
    get all,ingresses

cat examples/app/backend-aws-postgresql-no-claim.yaml

cp examples/app/backend-aws-postgresql-no-claim.yaml \
    apps/.

git add .

git commit -m "Adding dot"

git push

kubectl \
    --kubeconfig kubeconfig.yaml \
    get apps,sqls

kubectl \
    --kubeconfig kubeconfig.yaml \
    --namespace production \
    get all,ingresses

kubectl \
    --kubeconfig kubeconfig.yaml \
    get managed

cat packages/sql/definition.yaml

cat packages/sql/local-k8s.yaml

cat packages/sql/aws.yaml

###########
# Destroy #
###########

pkill kubectl

rm apps/*.yaml

rm apps-dev/*.yaml

git add .

git commit -m "Destroy apps"

git push

kubectl --kubeconfig kubeconfig.yaml \
    get managed

# Repeat the previous command until all the managed resources are removed (except `object` and `release` resources)

rm infra/aws-eks.yaml

git add .

git commit -m "Destroy everything"

git push

kubectl get managed

# Repeat the previous command until all the managed resources are removed (except `object` and `release` resources)

rm crossplane-definitions/*.yaml

rm crossplane-provider-configs/*.yaml

rm infra/*.yaml

git add .

git commit -m "Destroy everything"

git push

# Destroy or reset the management cluster

# Destroy the GitOps repo

# Source: https://gist.github.com/34bb5268261285f10fecefb990cfee3a

#########
# Setup #
#########

# Requirements:
# - k8s v1.19+ cluster with nginx Ingress (e.g., https://gist.github.com/18734cea86bb31c8146fbbe55adfb874)

# Replace `[...]` with the GitHub organization or the username
export GH_ORG=[...]

# Replace `[...]` with the base host accessible through NGINX Ingress
export BASE_HOST=[...] # e.g., $INGRESS_HOST.nip.io

export REGISTRY_SERVER=https://index.docker.io/v1/

# Replace `[...]` with the registry username
export REGISTRY_USER=[...]

# Replace `[...]` with the registry password
export REGISTRY_PASS=[...]

# Replace `[...]` with the registry email
export REGISTRY_EMAIL=[...]

# Replace `[...]` with the GitHub token
export GH_TOKEN=[...]

# Replace `[...]` with the GitHub email
export GH_EMAIL=[...]

open https://github.com/vfarcic/argo-combined-app

# Fork it!

git clone \
    https://github.com/$GH_ORG/argo-combined-app.git

cd argo-combined-app

cat kustomize/base/ingress.yaml \
    | sed -e "s@acme.com@staging.argo-combined-app.$BASE_HOST@g" \
    | tee kustomize/overlays/staging/ingress.yaml

cat kustomize/overlays/production/rollout.yaml \
    | sed -e "s@vfarcic@$REGISTRY_USER@g" \
    | tee kustomize/overlays/production/rollout.yaml

cat kustomize/overlays/staging/deployment.yaml \
    | sed -e "s@vfarcic@$REGISTRY_USER@g" \
    | tee kustomize/overlays/staging/deployment.yaml

cd ..

open https://github.com/vfarcic/argo-combined-demo

# Fork it!

git clone \
    https://github.com/$GH_ORG/argo-combined-demo.git

cd argo-combined-demo

cat orig/sealed-secrets.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee production/sealed-secrets.yaml

cat argo-cd/base/ingress.yaml \
    | sed -e "s@acme.com@argo-cd.$BASE_HOST@g" \
    | tee argo-cd/overlays/production/ingress.yaml

cat argo-workflows/base/ingress.yaml \
    | sed -e "s@acme.com@argo-workflows.$BASE_HOST@g" \
    | tee argo-workflows/overlays/production/ingress.yaml

cat argo-events/base/event-sources.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | sed -e "s@acme.com@webhook.$BASE_HOST@g" \
    | tee argo-events/overlays/production/event-sources.yaml

cat argo-events/base/sensors.yaml \
    | sed -e "s@value: vfarcic@value: $GH_ORG@g" \
    | sed -e "s@value: CHANGE_ME_IMAGE_OWNER@value: $REGISTRY_USER@g" \
    | tee argo-events/overlays/production/sensors.yaml

cat production/argo-cd.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee production/argo-cd.yaml

cat production/argo-workflows.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee production/argo-workflows.yaml

cat production/argo-events.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee production/argo-events.yaml

cat production/argo-rollouts.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee production/argo-rollouts.yaml

cat production/argo-combined-app.yaml \
    | sed -e "s@github.com/vfarcic@github.com/$GH_ORG@g" \
    | sed -e "s@- vfarcic@- $REGISTRY_USER@g" \
    | tee production/argo-combined-app.yaml

cat staging/argo-combined-app.yaml \
    | sed -e "s@github.com/vfarcic@github.com/$GH_ORG@g" \
    | sed -e "s@- vfarcic@- $REGISTRY_USER@g" \
    | tee staging/argo-combined-app.yaml

cat apps.yaml \
    | sed -e "s@vfarcic@$GH_ORG@g" \
    | tee apps.yaml

kubectl apply --filename sealed-secrets

kubectl --namespace workflows \
    create secret \
    docker-registry regcred \
    --docker-server=$REGISTRY_SERVER \
    --docker-username=$REGISTRY_USER \
    --docker-password=$REGISTRY_PASS \
    --docker-email=$REGISTRY_EMAIL \
    --output json \
    --dry-run=client \
    | kubeseal --format yaml \
    | tee argo-workflows/overlays/production/regcred.yaml

# Wait for a while and repeat the previous command if the output contains `cannot fetch certificate` error message

echo "apiVersion: v1
kind: Secret
metadata:
  name: github-access
  namespace: workflows
type: Opaque
data:
  token: $(echo -n $GH_TOKEN | base64)
  user: $(echo -n $GH_ORG | base64)
  email: $(echo -n $GH_EMAIL | base64)" \
    | kubeseal --format yaml \
    | tee argo-workflows/overlays/workflows/githubcred.yaml

echo "apiVersion: v1
kind: Secret
metadata:
  name: github-access
  namespace: argo-events
type: Opaque
data:
  token: $(echo -n $GH_TOKEN | base64)" \
    | kubeseal --format yaml \
    | tee argo-events/overlays/production/githubcred.yaml

git add .

git commit -m "Manifests"

git push

kustomize build \
    argo-cd/overlays/production \
    | kubectl apply --filename -

kubectl --namespace argocd \
    rollout status \
    deployment argocd-server

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
    argo-cd.$BASE_HOST

argocd account update-password \
    --current-password $PASS \
    --new-password admin

argocd login \
    --insecure \
    --username admin \
    --password admin \
    --grpc-web \
    argo-cd.$BASE_HOST

cat projects.yaml

kubectl apply --filename projects.yaml

cat apps.yaml

kubectl apply --filename apps.yaml

open http://argo-cd.$BASE_HOST

# Wait until Isto is deployed

cd ../argo-combined-app

# If NOT EKS
export ISTIO_HOST=$(kubectl \
    --namespace istio-system \
    get svc istio-ingressgateway \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If EKS
export ISTIO_HOSTNAME=$(kubectl \
    --namespace istio-system \
    get svc istio-ingressgateway \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If EKS
export ISTIO_HOST=$(\
    dig +short $ISTIO_HOSTNAME)

echo $ISTIO_HOST

# Repeat the `export` commands if the output of the `echo` command is empty
# If the output contains more than one IP, wait for a while longer, and repeat the `export` commands.
# If the output continues having more than one IP, choose one of them and execute `export INGRESS_HOST=[...]` with `[...]` being the selected IP.

# Repeat if the output is empty

cat kustomize/base/istio.yaml \
    | sed -e "s@acme.com@argo-combined-app.$ISTIO_HOST.nip.io@g" \
    | tee kustomize/overlays/production/istio.yaml

git add .

git commit -m "Ingress"

git push

cd ../argo-combined-demo

#########
# Intro #
#########

# Deploy apps easy, fast, repeatable, reliable, traceable, and secure
# - No humans involved in the process (pipelines and workflows)
# - Fully traceable (GitOps)
# - No access to the cluster (neither humans nor machines, GitOps)
# - Reduced blast radius (progressive)
# - Automated rollbacks (progressive)
# - Security

# - pipelines and workflows: Argo Workflows and Events
# - GitOps: Argo CD
# - Progressive delivery: Argo Rollouts
# - Security: SealedSecrets, Argo CD

######################
# GitOps deployments #
######################

ls -1 production/

cat production/argo-cd.yaml

open http://argo-cd.$BASE_HOST

# Both user and password are `admin`

########################
# Events and workflows #
########################

cat argo-events/overlays/production/event-sources.yaml

cat argo-events/overlays/production/sensors.yaml

open https://github.com/$GH_ORG/argo-combined-app/settings/hooks

cd ../argo-combined-app

cat config.toml \
    | sed -e "s@Where DevOps becomes practice@Subscribe now\!\!\!@g" \
    | tee config.toml

git add .

git commit -m "A silly change"

git push

###################
# GitOps upgrades #
###################

argo list --namespace workflows

argo --namespace workflows \
    get @latest

argo --namespace workflows \
    logs @latest \
    --follow

open https://github.com/$GH_ORG/argo-combined-demo

open http://staging.argo-combined-app.$BASE_HOST

######################
# Canary deployments #
######################

cat kustomize/overlays/production/rollout.yaml

kubectl argo rollouts \
    --namespace production \
    get rollout argo-combined-app \
    --watch

open http://argo-combined-app.$ISTIO_HOST.nip.io

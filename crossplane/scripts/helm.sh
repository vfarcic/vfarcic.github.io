# TODO: Intro

#########
# Setup #
#########

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

kind create cluster --config kind.yaml

kubectl create namespace infra

helm repo add crossplane-stable \
    https://charts.crossplane.io/stable

helm repo update

helm upgrade --install \
    crossplane crossplane-stable/crossplane \
    --namespace crossplane-system \
    --create-namespace \
    --wait

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

kubectl apply \
    --filename crossplane-config

# Please re-run the previous command if the output is `unable to recognize ...`

###########################
# Helm / Crossplane / AWS #
###########################

# Most of the time, it should be composites

cd charts/aws

cat values.yaml

helm upgrade --install eks . \
    --namespace infra \
    --create-namespace

helm --namespace infra ls

kubectl get aws

kubectl get managed

helm status eks --namespace infra

# Execute the commands from the output

kubectl get nodes

cat templates/cluster.yaml

unset KUBECONFIG

helm delete eks --namespace infra

kubectl get managed

############################
# Helm / Crossplane / Civo #
############################

cd ../civo-scale

cat values.yaml

cat templates/cluster.yaml

helm upgrade --install civo . \
    --namespace infra --create-namespace

kubectl get civo

export CLUSTER_NAME=b-team

kubectl --namespace infra \
    get secret cluster-$CLUSTER_NAME \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig-$CLUSTER_NAME.yaml

export KUBECONFIG=$PWD/kubeconfig-$CLUSTER_NAME.yaml

kubectl get nodes

unset KUBECONFIG

# Delete one of the clusters from the Civo console

helm delete civo --namespace infra

cd ../civo-bulk

cat values.yaml

cat templates/cluster.yaml

helm upgrade --install civo . \
    --namespace infra --create-namespace

kubectl get civo

helm delete civo --namespace infra

kubectl get managed

###########
# Destroy #
###########

# Replace `[...]` with the 
export CIVO_REGION=[...]

for NAME in a-team b-team c-team the-team-0 the-team-1 the-team-2 the-team-3 the-team-4
do
civo firewall remove \
    "Kubernetes cluster: $NAME" \
    --region $CIVO_REGION \
    --yes
done

kind delete cluster

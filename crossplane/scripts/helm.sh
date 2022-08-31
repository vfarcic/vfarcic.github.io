# TODO: Intro

#################
# Setup Cluster #
#################

git clone https://github.com/vfarcic/devops-toolkit-crossplane

cd devops-toolkit-crossplane

# Please watch https://youtu.be/C0v5gJSWuSo if you are not familiar with kind
# Feel free to use any other Kubernetes platform
kind create cluster --config kind.yaml

kubectl create namespace crossplane-system

kubectl create namespace a-team

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

kubectl --namespace crossplane-system \
    create secret generic aws-creds \
    --from-file creds=./aws-creds.conf

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

###########################
# Helm / Crossplane / AWS #
###########################

# Most of the time, it should be composites

cat crossplane-config/composition-eks.yaml

cat examples/aws-eks.yaml

cd charts/aws

cat values.yaml

helm upgrade --install eks . \
    --namespace a-team

helm --namespace a-team ls

kubectl get aws

kubectl get managed

cat templates/cluster.yaml

helm status eks --namespace a-team

# Execute the commands from the output

kubectl get nodes

unset KUBECONFIG

helm delete eks --namespace a-team

kubectl get managed

############################
# Helm / Crossplane / Civo #
############################

cd ../civo-scale

cat values.yaml

cat templates/cluster.yaml

helm upgrade --install civo . \
    --namespace a-team

kubectl get civo

kubectl --namespace a-team \
    get secret cluster-b-team \
    --output jsonpath="{.data.kubeconfig}" \
    | base64 -d >kubeconfig-b-team.yaml

export KUBECONFIG=$PWD/kubeconfig-b-team.yaml

kubectl get nodes

kubectl --namespace kube-system get pods

unset KUBECONFIG

# Delete one of the clusters from the Civo console

helm delete civo --namespace a-team

cd ../civo-bulk

cat values.yaml

cat templates/cluster.yaml

helm upgrade --install civo . \
    --namespace a-team

kubectl get civo

helm delete civo --namespace a-team

kubectl get managed

###########
# Destroy #
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

#####################################
# Developers do not need Kubernetes #
#####################################

#########
# Setup #
#########

# Create a Kubernetes cluster with Ingress

curl -s https://storage.googleapis.com/shipa-client/install.sh \
    | bash

git clone https://github.com/vfarcic/kubevela-demo.git

cd kubevela-demo

# Follow the instructions in https://learn.shipa.io/docs/setup-shipa-cloud

# If NOT EKS
export INGRESS_HOST=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If EKS
export INGRESS_HOSTNAME=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If EKS
export INGRESS_HOST=$(\
    dig +short $INGRESS_HOSTNAME)

echo $INGRESS_HOST

# Repeat the `export` commands if the output is empty

# If the output contains more than one IP, wait for a while longer, and repeat the `export` commands.

# If the output continues having more than one IP, choose one of them and execute `export INGRESS_HOST=[...]` with `[...]` being the selected IP.

cat dt-simple.yaml \
    | sed -e "s@localhost@demo.$INGRESS_HOST.nip.io@g" \
    | tee dt-simple.yaml

helm repo add kubevela \
    https://kubevelacharts.oss-cn-hangzhou.aliyuncs.com/core

helm repo update

helm upgrade --install \
    kubevela kubevela/vela-core \
    --namespace vela-system \
    --create-namespace \
    --wait

#######
# k8s #
#######

# Since the emergence of Kubernetes, we hoped that developers will adopt it.
# That did not happen, and it will likely never happen.

# It's too complicated.
# What if someone else created that for you

# Dev's are not in control any more. They cannot define what your app is.
# Is it stateless or stateful.
# Does it scale automatically or not?
# Is it publicly explosed or not?
# etc.

# Developers do not need Kubernetes.
# They need to write code, and they need an easy way to build, test, and deploy their applications.
# It is unrealistic to expect developers to spend years learning Kubernetes.
# Devs need a way to define applications, and not Kubernetes resources
# Devs need a way to just say "here's my code, run it!"

# On the other hand, operators and sysadmins do need Kubernetes.
# It gives them all they need to run systems at scale.
# Nevertheless, operators also need to empower developers to deploy their own applications.
# They need to enable developers by providing services rather than doing actual deployments or defining app manifests.

# So, we have conflicting needs.
# Kubernetes is necessary to some and a burden to others.
# Can we satisfy all?
# Can we have a system that is based on Kubernetes yet easy to operate?
# Can we make Kubernetes disappear and become an implementation detail running in the background?

cat helm/templates/*

cat helm/values.yaml

#########
# Shipa #
#########

# Create a framework

# Add a cluster

shipa app create devops-toolkit

shipa app deploy \
    --app devops-toolkit \
    --image vfarcic/devops-toolkit-series

shipa app info --app devops-toolkit

# Open the link

kubectl --namespace shipa-my-framework \
    get all,ingresses

##################
# OAM / KubeVela #
##################

cat dt-simple.yaml

kubectl apply \
    --filename dt-simple.yaml

kubectl get all,ingresses

echo http://demo.$INGRESS_HOST.nip.io

# Open it

kubectl get crds | grep oam

kubectl delete \
    --filename dt-simple.yaml

vela components

kubectl get componentdefinitions -A

cat components.yaml

# https://cuelang.org/

kubectl apply --filename components.yaml

cat traits.yaml

kubectl apply --filename traits.yaml

cat dt-full.yaml

kubectl apply --filename dt-full.yaml

kubectl get all,ingresses
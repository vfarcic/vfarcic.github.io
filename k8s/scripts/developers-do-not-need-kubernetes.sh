#####################################
# Developers do not need Kubernetes #
#####################################

#########
# Setup #
#########

# Create a Kubernetes cluster

curl -s https://storage.googleapis.com/shipa-client/install.sh \
    | bash

git clone https://github.com/vfarcic/shipa-demo.git

cd shipa-demo

# Follow the instructions in https://learn.shipa.io/docs/setup-shipa-cloud

#######
# k8s #
#######

# Since the emergence of Kubernetes, we hoped that developers will adopt it.
# That did not happen, and it will likely never happen.

cat helm/templates/*

# It's too complicated.
# What if someone else created that for you

cat helm/values.yaml

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

#######################
# Creating frameworks #
#######################

# Create a framework

# Add a cluster

########################################
# Deploying apps from container images #
########################################

shipa app create devops-toolkit

shipa app deploy \
    --app devops-toolkit \
    --image vfarcic/devops-toolkit-series

shipa app info --app devops-toolkit

# Open the link

kubectl --namespace shipa-my-framework \
    get all,ingresses

####################
# Adding platforms #
####################

# Open https://learn.shipa.io/docs/platforms-1

ls -1

shipa platform list

shipa platform add go

shipa platform list

###################################
# Deploying apps from source code #
###################################

shipa app create shipa-demo go

shipa app deploy \
    --app shipa-demo \
    --files-only .

shipa app info --app shipa-demo

# Open the link

##########################
# Deploying new releases #
##########################

# Modify main.go

shipa app deploy \
    --app shipa-demo \
    --files-only .

shipa app list

shipa app deploy list --app shipa-demo

########################
# Scaling applications #
########################

shipa unit add 2 --app shipa-demo



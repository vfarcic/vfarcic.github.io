# Requirements

## General

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/)
* [Docker For Desktop](https://www.docker.com/products/docker-desktop) or [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* [skaffold](https://github.com/GoogleContainerTools/skaffold/releases)

## GKE

Please make sure that you have the tools that follow installed.

* [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts)

You'll need **Google Cloud Platform (GCP) admin permissions**. If you don't have the account or the one you're using does not have admin permissions, please create a personal account by visiting [cloud.google.com](https://cloud.google.com/). You'll get $300 of free credit.

Please make sure you have the name of a GCP project ready. If you don't have one, you can follow the instructions from the [Creating and Managing Projects](https://cloud.google.com/resource-manager/docs/creating-managing-projects) documentation.

To be on the safe side and confirm that you can create a GKE cluster, please execute the commands that follow.

```bash
gcloud auth login

gcloud container clusters \
    create devops25 \
    --region us-east1 \
    --machine-type n1-standard-1 \
    --enable-autoscaling \
    --num-nodes 1 \
    --max-nodes 3 \
    --min-nodes 1

kubectl create clusterrolebinding \
    cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

gcloud container clusters \
    delete devops25 \
    --region us-east1 \
    --quiet
```

Those commands craeted a GKE cluster and destroyed it right away. Their purpose was only to validate whether you are able to create a GKE cluster. We'll create a new cluster during the training.

Please contact me on [DevOps20](http://slack.devops20toolkit.com/) Slack channel (my user is *vfarcic*) if you encountered any problems.
## Hands-On Time

---

# Creating A GKE Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts)
* GCP admin permissions


## Getting The Code

---

```bash
git clone https://github.com/vfarcic/k8s-specs.git

cd k8s-specs
```


## Getting The Code

---

* We cloned the repository that contains (almost) all the examples we'll use in this course


## Creating A Cluster

---

```bash
gcloud auth login

REGION=us-east1

MACHINE_TYPE=n1-standard-1

gcloud container clusters create devops25 --region $REGION \
    --machine-type $MACHINE_TYPE --enable-autoscaling \
    --num-nodes 1 --max-nodes 3 --min-nodes 1

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole cluster-admin \
    --user $(gcloud config get-value account)

kubectl get nodes
```


## Creating A Cluster

---

* We logged into our Google account
* We defined the region and the type of VMs
* We created a cluster with a minimum of three nodes (one for each zone) and a maximum of nine (3 in each zone)
* We created admin permissions for the current user
* We retrieved the list of the nodes of the cluster

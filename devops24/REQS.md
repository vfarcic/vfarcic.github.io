# Workshop Prerequisites

A fully operational Kubernetes cluster with NGINX Ingress controller and a default StorageClass. The following Kubernetes platforms were tested for this course. Please note that Gists are provided in case you need to create a cluster specific for this course.

[devops24-docker.sh](https://gist.github.com/vfarcic/3fbf532b1716d40ae60552baf83b8ed1): Docker for Mac with 4 CPUs, 4GB RAM, and with nginx Ingress controller.
[devops24-minikube.sh](https://gist.github.com/vfarcic/f5863c66867bbe87722998683ea20c41): minikube with 4 CPUs, 4GB RAM, and with ingress, storage-provisioner, and default-storageclass addons enabled.
[devops24-kops.sh](https://gist.github.com/vfarcic/0552be5ccbd5c8d7f87a9dfadb5e66dc): kops in AWS with 3 t2.medium masters and 3 t2.medium nodes spread in three availability zones, and with nginx Ingress controller.
[devops24-eks.sh](https://gist.github.com/vfarcic/b6ed77d257964fa2e19c2722739ddad6): Elastic Kubernetes Service (EKS) with 3 t2.medium nodes, and with nginx Ingress controller.
[gke.sh](https://gist.github.com/5c52c165bf9c5002fedb61f8a5d6a6d1): Google Kubernetes Engine (GKE) with 3 n1-standard-1 (1 CPU, 3.75GB RAM) nodes (one in each zone), and with nginx Ingress controller running on top of the "standard" one that comes with GKE. We'll use nginx Ingress for compatibility with other platforms. Feel free to modify the YAML files if you prefer NOT to install nginx Ingress.
[minishift.sh](https://gist.github.com/c9968f23ecb1f7b2ec40c6bcc0e03e4f): minishift with 2 CPUs, 2GB RAM, and version 1.16+.

If you are a Windows user, please use GitBash as a terminal for running the commands.

If you are running a local Kubernetes cluster with Docker For Mac/Windows or minishift, please install Vagrant (if you do not have it already).

Besides the cluster, you’ll need [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) or [oc](https://docs.openshift.com/enterprise/3.1/cli_reference/get_started_cli.html) if you’re using [minishift](https://docs.okd.io/latest/minishift/getting-started/installing.html).

If you have problems fulfilling the requirements, please contact me through [DevOps20](http://slack.devops20toolkit.com/) Slack (my user is vfarcic) or send me an email to viktor@farcic.com.
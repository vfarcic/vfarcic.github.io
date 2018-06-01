## Requirements

You will need:

* [Git](https://git-scm.com/)
* GitBash (only if using Windows; it's installed with Git)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Minikube](https://github.com/kubernetes/minikube/releases)
* [AWS account](https://aws.amazon.com/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [jq](https://stedolan.github.io/jq/)
* [Docker For Windows](https://www.docker.com/docker-windows), [Docker For Mac](https://www.docker.com/docker-mac), or [Docker Server](https://docs.docker.com/install/#server) if using Linux
* [Docker Hub Account](https://hub.docker.com/)
* [Helm](TODO)

If you are a Windows user, please make sure that your Git client is configured to check out the code *AS-IS*. Otherwise, Windows might change carriage returns to the Windows format. You will also need an [AWS account](https://aws.amazon.com/) and [AWS CLI](https://aws.amazon.com/cli/). Please note that it should be free from any customizations and limitations your company might have introduced. If in doubt, please use your personal account.

Please double check that VirtualBox, `minikube`, and `kubectl` work by executing:

```bash
minikube start --vm-driver=virtualbox

kubectl get nodes

minikube delete
```


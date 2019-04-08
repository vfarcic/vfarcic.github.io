## Hands-On Time

---

### Creating A
# Jenkins-X
## Cluster


## Prerequisites

---

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/)
* [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)


## Creating A Cluster With jx

---

```bash
GH_USER=[...]

PASS=admin && MEM=8192 && CPU=8 && DISK=150GB

jx create cluster minikube --default-admin-password=$PASS -m $MEM -c $CPU -s $DISK -d virtualbox --git-username $GH_USER --environment-git-owner $GH_USER --default-environment-prefix jx-rocks --no-tiller

jx console
```

* Use `admin` as the username and password

```bash
kubectl -n jx get pods
```

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
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and Azure admin permissions


## Creating A Cluster With jx

---

```bash
GH_USER=[...]

NAME=jxrocks && MACHINE=Standard_D2s_v3 && LOCATION=eastus && MIN_NODES=3 && PASS=admin

# NOTE: Azure ACR allows only `^[a-zA-Z0-9]*$`

jx create cluster aks -c $NAME -n $NAME-group -l $LOCATION -s $MACHINE -o $MIN_NODES --default-admin-password=$PASS --git-username $GH_USER --environment-git-owner $GH_USER --default-environment-prefix jx-rocks

jx console
```

* Use `admin` as the username and password

```bash
kubectl -n jx get pods
```

Note:
```
NAME                                 READY STATUS  RESTARTS AGE
jenkins-...                          1/1   Running 0        7m
jenkins-x-chartmuseum-...            1/1   Running 0        7m
jenkins-x-controllercommitstatus-... 1/1   Running 0        7m
jenkins-x-controllerrole-...         1/1   Running 0        7m
jenkins-x-controllerteam-...         1/1   Running 0        7m
jenkins-x-controllerworkflow-...     1/1   Running 0        7m
jenkins-x-docker-registry-...        1/1   Running 0        7m
jenkins-x-heapster-...               2/2   Running 0        7m
jenkins-x-mongodb-...                1/1   Running 1        7m
jenkins-x-monocular-api-...          1/1   Running 3        7m
jenkins-x-monocular-prerender-...    1/1   Running 0        7m
jenkins-x-monocular-ui-...           1/1   Running 0        7m
jenkins-x-nexus-...                  1/1   Running 0        7m
maven-...                            2/2   Running 0        1m
```
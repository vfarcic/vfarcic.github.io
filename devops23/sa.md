<!-- .slide: data-background="../img/background/why.jpg" -->
# Enabling Process Communication With Kube API Through Service Accounts

---

> Humans are not the only ones who rely on a cluster. Processes in containers often need to invoke Kube API as well. When using RBAC for authentication, we need to decide which users will have permissions to perform specific actions. The same holds true for the processes running inside containers.
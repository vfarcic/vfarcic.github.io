<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


## Setup

```sh
git clone https://github.com/vfarcic/crossplane-sql

cd crossplane-sql

git pull

git fetch

git checkout status-transformer
```


## Setup

* Make sure that Docker is up-and-running. We'll use it to create a KinD cluster.

* Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.


## Setup

```sh
devbox shell

chmod +x examples/setup.nu 

./examples/setup.nu

source .env

kubectl delete \
    --filename examples/provider-config-$HYPERSCALER.yaml

kubectl --namespace infra apply \
    --filename examples/$HYPERSCALER-secret.yaml
```


## Setup

* Execute the command that follows only if you are using **AWS**

```sh
export MANAGED_RESOURCE=vpc.ec2.aws.upbound.io
```

* Execute the command that follows only if you are using **Google Cloud**

```sh
export MANAGED_RESOURCE=databaseinstance.sql.gcp.upbound.io
```

* Execute the command that follows only if you are using **Azure**

```sh
export MANAGED_RESOURCE=resourcegroup.azure.upbound.io
```

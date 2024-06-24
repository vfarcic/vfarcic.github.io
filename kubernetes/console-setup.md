<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

* Install [GitHub CLI](https://cli.github.com/) if you don't have it already.

```sh
gh repo fork vfarcic/port-crds-demo --clone --remote

cd port-crds-demo

gh repo set-default
```

* Select the fork as the default repository

```sh
gh repo view --web
```


## Setup

* Open `Actions` and click the `I understand my workflows, go ahead and enable them` button.
* Open `Settings` > `Secrets and variables` > `Actions` and add `Repository secrets` named `PORT_CLIENT_ID` and `PORT_CLIENT_SECRET`. You can get those values from the Port UI.
* Make sure that Docker is up-and-running. We'll use it to create a KinD cluster.


## Setup

* Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.


## Setup

```sh
kubectl --namespace argocd port-forward svc/argocd-server \
    8080:80 &

devbox shell

chmod +x setup.sh

./setup.sh

source .env
```
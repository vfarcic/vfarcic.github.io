<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

```sh
git clone https://github.com/vfarcic/crossplane-db-schemas-demo

cd crossplane-db-schemas-demo

export HYPERSCALER=aws

nix-shell --run $SHELL shell-$HYPERSCALER.nix

chmod +x setup.sh

./setup.sh

source .env
```

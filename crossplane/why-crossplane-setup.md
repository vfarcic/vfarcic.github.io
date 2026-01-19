<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Setup

<div class="label">Hands-on Time</div>


<!-- .slide: data-background="../img/background/hands-on.jpg" -->
```sh
git clone https://github.com/vfarcic/dot-ai

cd dot-ai

git pull

git fetch

git switch demo/crossplane
```


<!-- .slide: data-background="../img/background/hands-on.jpg" -->
> Make sure that Docker is up-and-running. We'll use it to run create a KinD cluster.

> Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.


<!-- .slide: data-background="../img/background/hands-on.jpg" -->
```sh
devbox shell

./dot.nu setup --stack-version 0.22.0 --kyverno-enabled false \
    --atlas-enabled false --crossplane-db-config true \
    --cnpg-enabled true

source .env

kubectl apply --filename examples/databases.yaml
```
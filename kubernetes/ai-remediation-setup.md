<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


> This demo is using Claude Code as the coding agent. With a few modification, it should work with any other coding agent like Cursor, GitHub Copilot, etc.

```sh
git clone https://github.com/vfarcic/dot-ai-demo

cd dot-ai-demo

git pull

git fetch

git switch remediation
```


> Make sure that Docker is up-and-running. We'll use it to create a KinD cluster.

> Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.


```sh
devbox shell

./dot.nu setup --dot-ai-tag 1.16.2 --qdrant-run false \
    --dot-ai-kubernetes-enabled true \
    --kyverno-enabled false --atlas-enabled false \
    --toolhive-enabled false --crossplane-enabled false

source .env

# kubectl --namespace a-team apply \
#     --filename examples/deployment-no-pvc.yaml
```
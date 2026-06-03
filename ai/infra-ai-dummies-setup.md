<!-- .slide: data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup


## Setup

```sh
git clone https://github.com/vfarcic/infra-with-ai

cd infra-with-ai
```


> Make sure that Docker is up-and-running. We'll use it to create a KinD cluster.

> Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.


```sh
devbox shell

chmod +x dot.nu

./dot.nu setup

source .env

git switch agents
```


> This demo is using [OpenCode agent](https://opencode.ai). Howerever, if you're following along, all the instructions should work with any coding agent with a few minor changes. If you do choose OpenCode, [install it](https://opencode.ai/download), type `/connect` to connect it to your favorite AI provider, and `/model` to select which model to use. Otherwise, replace the command that follows with whichever command starts your agent.


```sh
opencode
```
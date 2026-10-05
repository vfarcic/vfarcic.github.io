<!-- .slide: id="setup" data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup

Note:
Execute this section before the talk when the environment needs to be ready in advance. Return to the cover for the audience.


<!-- .slide: id="setup-repository" -->
## Setup

```sh
git clone {{DEMO_REPO_URL}}

cd {{DEMO_DIR}}

git pull
```

Note:
Use the demo repository associated with the source material. If already cloned, skip cloning, enter its directory, and run git pull. During review of unpublished changes, use the updated local checkout instead of expecting the older remote version to contain them.


<!-- .slide: id="setup-prerequisites" -->
## Setup

> Make sure Docker is running. We'll use it to create a KinD cluster.

> Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) for a Devbox introduction, or install the tools in `devbox.json` yourself.

Note:
Adapt these prerequisites to the actual environment. Remove Docker or Devbox instructions if they do not apply, and add only the required cloud access or other essential prerequisites. Keep credential details, rehearsal, reset, and troubleshooting in the demo README or preparation guide.


<!-- .slide: id="setup-commands" -->
## Setup

```sh
devbox shell

chmod +x dot.nu

./dot.nu setup

source .env
```

Note:
Verify the entry point against the demo repository. Prefer one user-facing setup command; keep its internal stages in scripts/. Reuse helpers from the nu-scripts master repo and keep project-specific orchestration in the demo repo. Replace dot.nu if this project uses another verified entry point, and remove source .env if setup does not create it. Identify the state from which the live demo will start.

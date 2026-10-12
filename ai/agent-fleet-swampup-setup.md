<!-- .slide: id="setup" data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup

Note:
Execute setup on the laptop before the talk, then return to #/cover for the audience. It only affects the JFrog Curation beat; the mini PC and InMotion hosts are not touched. agent-fleet-swampup-demo.md contains the JFrog Platform preparation, rehearsal, and reset steps.


<!-- .slide: id="setup-repository" -->
## Setup

```sh
git clone https://github.com/vfarcic/dot-agent-deck

cd dot-agent-deck

git pull

git worktree add ../dot-agent-deck-jfrog demo/jfrog-curation
```

Note:
This is the demo repository used throughout the talk. If it is already cloned, skip git clone, enter the existing directory, and run git pull. The Curation beat runs in a separate worktree on the demo/jfrog-curation branch. Only that branch routes npm and pnpm through JFrog, so main and every other checkout keep working exactly as before. If the worktree already exists from a rehearsal, remove it with the cleanup command first so it starts from the branch's current state.


<!-- .slide: id="setup-prerequisites" -->
## Setup

> JFrog Platform with Curation enabled on an npm remote repository and a blocking policy.

> `gcloud` authenticated, so vals can read the `jfrog-token` secret.

Note:
The dot repository on devreleplus.jfrog.io proxies npmjs.org with Curation enabled. The organization-wide block_vulnerable_packages policy refuses the branch's axios 0.21.1. The preparation guide lists what to check if any of that changes.


<!-- .slide: id="setup-commands" -->
## Setup

```sh
export USE_VALS=true

devbox shell

npm config set //devreleplus.jfrog.io/artifactory/api/npm/dot/:_authToken $JFROG_TOKEN

exit
```

Note:
Run from the dot-agent-deck checkout. With USE_VALS set, devbox shell loads .env.vals.yaml, which resolves JFROG_TOKEN from Google Secret Manager. pnpm refuses to expand tokens from a committed project .npmrc, so the token goes into the user-level ~/.npmrc. It only authenticates requests to devreleplus.jfrog.io; which registry a checkout uses still comes from the branch's desktop/.npmrc, so main keeps using the public registry. Exit the devbox shell afterward.

<!-- .slide: id="setup" data-background="../img/background/hands-on.jpg" -->
## Hands-on Time

# Setup

Note:
Execute setup before the talk. The opening talk begins at the cover. The demo README contains the detailed preparation, rehearsal, reset, and troubleshooting instructions.


<!-- .slide: id="setup-repository" -->
## Setup

```sh
git clone https://github.com/vfarcic/modelplane-demo

cd modelplane-demo

git pull
```

Note:
The public repository is the same one used by the manuscript. If it is already cloned, skip git clone, enter the existing directory, and run git pull. Until the updated files are published, use the updated local checkout rather than expecting the remote to contain them. From the presentations checkout root, that local checkout is ../modelplane-demo. Start the remaining commands from the demo repository root.


<!-- .slide: id="setup-prerequisites" -->
## Setup

> Make sure Docker is running. We'll use it to create a KinD cluster.

> Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) for a Devbox introduction, or install the tools in `devbox.json` yourself.

Note:
Give Docker Desktop at least 8 GB of memory and keep Docker running throughout reconciliation and teardown. The demo README lists the tools, versions, rehearsal, and reset steps.


<!-- .slide: id="setup-provider" -->
## Setup

```sh
export PROVIDER=google
```

> Choose `aws` for AWS or `google` for Google Cloud.

Note:
Select one provider before setup. The selected provider's manifests live in aws/ or google/. The model deployment and request remain the same. AWS uses your access-key environment; Google Cloud uses gcloud authentication and creates a uniquely named, billing-linked project for this run. The run's provider and project ownership are saved for subsequent commands and teardown.


<!-- .slide: id="setup-cloud-access" -->
## Setup

* AWS: EKS permissions and regional GPU capacity
* Google Cloud: project creation, billing, and GKE GPU quotas

Note:
For AWS, supply AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY through your credential tooling; temporary credentials also need AWS_SESSION_TOKEN. For Google, authenticate with gcloud auth login and have access to an open billing account. A fresh Google setup creates a new project, with a timestamp and random suffix in its ID, and does not repurpose your default project. If there is more than one billing account, pass --billing-account. The README lists required permissions and zones. Prepare the fleet before the talk; GPU quota and physical capacity remain provider constraints.


<!-- .slide: id="setup-commands" -->
## Setup

```sh
devbox shell

chmod +x dot.nu

./dot.nu setup "$PROVIDER"

source .env
```

Note:
Run the single NuShell setup command from the demo repository. Shared helpers come from nu-scripts; project-specific orchestration stays in scripts/modelplane.nu. Setup prepares local KinD, Crossplane v2.4.2, Modelplane v0.5.0, provider credentials, the selected cloud's GPU fleet, and its gateway. Source .env afterward to load the provider, project ID where applicable, and isolated kubeconfig. Use setup --resume to continue a recorded partial run rather than creating another project. Verification checks the platform, not model generation. Rehearse and reset before the talk, then return to #/cover.

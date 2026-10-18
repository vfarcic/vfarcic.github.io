## Setup

> Run everything in this section before the talk. Setup takes 20 to 30 minutes, most of it Modelplane creating the inference cluster.


```sh
git clone https://github.com/vfarcic/inference-vote

cd inference-vote
```


> Make sure that Docker is up-and-running, with at least 8 GB of memory. We'll use it to create a KinD cluster that becomes the Modelplane control plane.

> Watch [Nix for Everyone: Unleash Devbox for Simplified Development](https://youtu.be/WiFLtcBvGMU) if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.


> Get a Datadog API key from Organization Settings > API Keys. Accounts outside the US1 site also need `DD_SITE`, such as `datadoghq.eu`. Add `--no-datadog` to the setup command to skip Datadog altogether.


```sh
devbox shell

export DD_API_KEY=[...]

./dot.nu setup google

source .env
```

> Replace `google` with `aws` to run on AWS. Setup asks for the AWS keys unless `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are set.


> The voting app is served at `https://<load balancer IP>.nip.io`, with a Let's Encrypt certificate, so there is no DNS to set.


> If the GPU nodes stay stuck provisioning, the zone is out of GPUs. Destroy and set up again with `--zone us-central1-b` or `--zone us-central1-c`.


## Rehearsal Only

```sh
./dot.nu measure
```

> It deploys each of the eight configurations in turn and writes how long each took to `timings.md`. The slowest one is how long the audience may wait. The default `--optimized`, B, A, A, came out best in rehearsal.


## Right Before the Talk

```sh
./dot.nu reset
```

> It removes the audience's deployment and clears every vote.


## On Stage

```sh
echo "https://$DOMAIN/presenter"

echo $PRESENTER_TOKEN
```

> Open the presenter page in the browser and paste the token. The lobby shows the QR code.


> **Next** (or the right arrow, or a clicker) opens a question, closes it and opens the next, and after the third applies the result. Once it is deploying, **Next** starts the race, whether or not the audience's deployment serves yet. **Reset** needs two clicks.

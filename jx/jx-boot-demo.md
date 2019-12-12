<!-- .slide: class="center dark" -->
<!-- .slide: data-background="../img/background/hands-on.jpg" -->
# Creating A Jenkins X Cluster

<div class="label">Hands-on Time</div>


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Prerequisites

* [Git](https://git-scm.com/)
* GitBash (if using Windows)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Helm](https://helm.sh/) (MUST BE `helm` 2.+)
* If Google: [gcloud CLI](https://cloud.google.com/sdk/docs/quickstarts) and GCP admin permissions
* If Azure: [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and Azure admin permissions
* If AWS: [AWS CLI](https://aws.amazon.com/cli/) and AWS admin permissions


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Cluster With jx

```bash
NAMESPACE=jx
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Creating A Kubernetes Cluster

```bash
PROJECT=[...] # Replace `[...]` with the name of the GCP project (e.g. jx).

CLUSTER_NAME=[...] # Replace `[...]` with the name of the cluster (e.g., jx-boot)

gcloud auth login

gcloud container clusters create $CLUSTER_NAME --project $PROJECT --region us-east1 --machine-type n1-standard-2 --enable-autoscaling --num-nodes 1 --max-nodes 2 --min-nodes 1

kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
```


<!-- .slide: class="dark" -->
<div class="eyebrow">Section 2</div>
<div class="label">Hands-on Time</div>

## Installing Jenkins X Using GitOps Principles

```bash
open "https://github.com/jenkins-x/jenkins-x-boot-config.git"

CLUSTER_NAME=[...]

GH_USER=[...]

git clone https://github.com/$GH_USER/jenkins-x-boot-config.git environment-$CLUSTER_NAME-dev

cd environment-$CLUSTER_NAME-dev

cat jx-requirements.yml

# open `jx-requirements.yml`
# Set `cluster.clusterName` to the name of your cluster (`$CLUSTER_NAME`)
# Set `cluster.environmentGitOwner` to your GitHub user.
# Set `cluster.project` to the name of your GKE project
# Set `cluster.provider` to `gke` or to `eks` or to any other provider (if supported)
# Set `cluster.zone` to whichever zone your cluster is running in.
```

We're finished with the `cluster` section, and the next in line is the `gitops` value. It instructs the system how to treat the Boot process. I don't believe it makes sense to change it to `false`, so we'll leave it as-is (`true`).

The next section contains the list of the `environments` that we're already familiar with. The keys are the suffixes, and the final names will be a combination of `environment-` with the name of the cluster followed by the `key`. We'll leave them intact.

The `ingress` section defines the parameters related to external access to the cluster (`domain`, TLS, etc.). We won't dive into it just yet. That will be left for later (probably the next chapter).

The `kaniko` value should be self-explanatory. When set to `true`, the system will build container images using Kaniko instead of, let's say, Docker. That is a much better choice since Docker cannot run in a container and, as such, poses a significant security risk (mounted sockets are evil), and it messes with Kubernetes scheduler given that it bypasses its API. In any case, Kaniko is the only supported way to build container images when using Tekton, so we'll leave it as-is (`true`).

Next, we have `secretStorage` currently set to `vault`. The whole platform will be defined in this repository, except for secrets (e.g., passwords). Pushing them to Git would be childish, so Jenkins X can store the secrets in different locations. If we'd change it to `local`, that location is your laptop. While that is better than a Git repository, you can probably imagine why that is not the right solution. Keeping them locally complicates cooperation (they exist only on your laptop), is volatile, and is only slightly more secure than Git. A much better place for secrets is [HashiCorp Vault](https://www.vaultproject.io). It is the most commonly used solution for secrets management in Kubernetes (and beyond), and Jenkins X supports it out of the box.

All in all, secrets storage is an easy choice.

* Set the value of `secretStorage` to `vault`.

Below the `secretStorage` value is the whole section that defines `storage` for `logs`, `reports`, and `repository`. If enabled, those artifacts will be stored on a network drive. As you already know, containers and nodes are short-lived, and if we want to preserve any of those, we need to store them elsewhere. That does not necessarily mean that network drives are the best place, but rather that's what comes out of the box. Later on, you might choose to change that and, let's say, ship logs to a central database like ElasticSearch, PaperTrail, CloudWatch, StackDriver, etc.

For now, we'll keep it simple and enable network storage for all three types of artifacts.

* Set the value of `storage.logs.enabled` to `true`
* Set the value of `storage.reports.enabled` to `true`
* Set the value of `storage.repository.enabled` to `true`

For now, we'll keep it simple and keep the default values (`true`) that enable network storage for all three types of artifacts.

The `versionsStream` section defines the repository that contains versions of all the packages (charts) used by Jenkins X. You might choose to fork that repository and control versions yourself. Before you jump into doing just that, please note that Jenkins X versioning is quite complex, given that many packages are involved. Leave it be unless you have a very good reason to take over the control, and that you're ready to maintain it.

Finally, at the time of this writing (October 2019), `webhook` is set to `prow`. It defines the end-point that receives webhooks and forwards them to the rest of the system, or back to Git.

As you already know, Prow supports only GitHub. If that's not your Git provider, Prow is a no-go. As an alternative, we could set it to `jenkins`, but that's not the right solution either. Jenkins (without X) is not going to be supported for long, given that the future is in Tekton. It was used in the first generation of Jenkins X only because it was a good starting point and because it supports almost anything we can imagine. But, the community embraced Tekton as the only pipeline engine, and that means that static Jenkins X is fading away and that it is used mostly as a transition solution for those accustomed to the "traditional" Jenkins.

So, what can we do if `prow` is not a choice if you do not use GitHub, and `jenkins` days are numbered? To make things more complicated, even Prow will be deprecated sometime in the future (or past depending when you read this). It will be replaced with *Lighthouse*, which, at least at the beginning, will provide similar functionality as Prow. Its primary advantage when compared with Prow is that Lighthouse will (or already does) support all major Git providers (e.g., GitHub, GitHub Enterprise, Bitbucket Server, Bitbucket Cloud, GitLab, etc.). At some moment, the default value of `webhook` will be `lighthouse`. But, at the time of this writing (October 2019), that's not the case since `Lighthouse` is not yet stable and production-ready. It will be soon. Or, maybe it already is, and I did not yet rewrite this chapter to reflect that.

In any case, we'll keep `prow` as our `webhook` (for now).

Let's take a peek at how `jx-requirements.yml` looks like now.

```bash
cat jx-requirements.yml
```

In my case, the output is as follows (yours is likely going to be different).

```yaml
cluster:
  clusterName: "jx-boot"
  environmentGitOwner: "vfarcic"
  project: "devops-26"
  provider: gke
  zone: "us-east1"
gitops: true
environments:
- key: dev
- key: staging
- key: production
ingress:
  domain: ""
  externalDNS: false
  tls:
    email: ""
    enabled: false
    production: false
kaniko: true
secretStorage: vault
storage:
  logs:
    enabled: true
    url: ""
  reports:
    enabled: true
    url: ""
  repository:
    enabled: true
    url: ""
versionStream:
  ref: "master"
  url: https://github.com/jenkins-x/jenkins-x-versions.git
webhook: prow
```

I> Feel free to modify some values further or to add those that we skipped. If you used my Gist to create a cluster, the current setup will work. On the other hand, if you created a cluster on your own, you will likely need to change some values.

Now, you might be worried that we missed some of the values. For example, we did not specify a domain. Does that mean that our cluster will not be accessible from outside? We also did not specify `url` for storage. Will Jenkins X ignore it in that case?

The truth is that we specified only the things we know. For example, if you created a cluster using my Gist, there is no Ingress, so there is no external load balancer that it was supposed to create. As a result, we do not yet know the IP through which we can access the cluster, and we cannot generate a `.nip.io` domain. Similarly, we did not create storage. If we did, we could have entered addresses into `url` fields.

Those are only a few examples of the unknowns. We specified what we know, and we'll let Jenkins X Boot figure out the unknowns. Or, to be more precise, we'll let the Boot create the resources that are missing and thus convert the unknowns into knowns.

W> In some cases, Jenkins X Boot might get confused with the cache from the previous Jenkins X installations. To be on the safe side, delete the `.jx` directory by executing `rm -rf ~/.jx`.

Off we go. Let's install Jenkins X.

```bash
jx boot
```

Now we need to answer quite a few questions. In the past, we tried to avoid answering questions by specifying all answers as arguments to commands we were executing. That way, we had a documented method for doing things that do not end up in a Git repository. Someone else could reproduce what we did by running the same commands. This time, however, there is no need to avoid questions since everything we'll do will be stored in a Git repository. Later on, we'll see where exactly will Jenkins X Boot store the answers. For now, we'll do our best to provide the information is needs.

I> The Boot process might change by the time you read this. If that happens, do your best to answer by yourself the additional questions that are not covered here.

We can see that, after a while, we were presented with two warnings stating that TLS is not enabled for `Vault` and `webhooks`. If we specified a "real" domain, Boot would install Let's Encrypt and generate certificates. But, since I couldn't be sure that you have a domain at hand, we did not specify it, and, as a result, we will not get certificates. While that would be unacceptable in production, it is quite OK as an exercise.

As a result of those warnings, the Boot is asking us whether we `wish to continue`. Type `y` and press the enter key to continue.

Given that Jenkins X creates multiple releases a day, the chances are that you do not have the latest version of `jx`. If that's the case, the Boot will ask, `would you like to upgrade to the jx version?`. Press the enter key to use the default answer `Y`. As a result, the Boot will upgrade the CLI, but that will abort the pipeline. That's OK. No harm's done. All we have to do is repeat the process but, this time, with the latest version of `jx`.

```bash
jx boot
```

The process started again. We'll skip commenting on the first few questions to `jx boot the cluster` and to `continue` without TLS. Answers are the same as before (`y` in both cases).

The next set of questions is related to `long term storage` for logs, reports, and repository. Press the enter key to all three questions, and the Boot will create buckets with auto-generated unique names.

From now on, the process will create the secrets and install CRDs (Custom Resource Definitions) that provide custom resources specific to Jenkins X. Then, it'll install nginx Ingress (unless your cluster already has one) and set the domain to `.nip.io` since we did not specify one. Further on, it will install CertManager, which will provide Let's Encrypt certificates. Or, to be more precise, it would provide the certificates if we specified a domain. Nevertheless, it's installed just in case we change our minds and choose to update the platform by changing the domain and enabling TLS later on.

The next in line is Vault. The Boot will install it and attempt to populate it with the secrets. But, since it does not know them just yet, the process will ask us another round of questions. The first one in this group is the `Admin Username`. Feel free to press the enter key to accept the default value `admin`. After that comes `Admin Password`. Type whatever you'd like to use (we won't need it today).

The process will need to know how to access our GitHub repositories, so it asks us for the Git `username`, `email address`, and `token`. I'm sure that you know the answers to the first two questions. As for the token, if you did not save the one we created before, you'll need to create a new one. Do that, if you must, and feed it to the Boot. Finally, the last question related to secrets is `HMAC token`. Feel free to press the enter key, and the process will create it for you.

Finally comes the last question. `Do you want to configure an external Docker Registry?` Press the enter key to use the default answer (`N`) and the Boot will create it inside the cluster or, as in case of most cloud providers, use the registry provided as a service. In case of GKE, that would be GCR, for EKS that's ECR, and if you're using AKS, that would be ACR. In any case, by not configuring an external Docker Registry, the Boot will use whatever makes the most sense for a given provider.

The rest of the process will install and configure all the components of the platform. We won't go into all of them since they are the same as those we used before. What matters is that the system will be fully operational a while later.

The last step will verify the installation. You might see a few warnings during this last step of the process. Don't be alarmed. The Boot is most likely impatient. Over time, you'll see the number of `running` Pods increasing and those that are `pending` decreasing, until all the Pods are `running`.

That's it. Jenkins X is now up-and-running. On the surface, the end result is the same as if we used the `jx install` command but, this time, we have the whole definition of the platform with complete configuration (except for secrets) stored in a Git repository. That's a massive improvement by itself. Later on, we'll see additional benefits like upgrades performed by changing any of the configuration files and pushing those changes to the repository. But, for now, what matters is that Jenkins X is up-and-running. Or, at least, that's what we're hoping for.

## Exploring The Changes Done By The Boot

Now, let's take a look at the changes Jenkins X Boot did to the local copy of the repository.

```bash
git --no-pager diff origin/master..HEAD
```

That's a long output, isn't it? Jenkins X Boot changed a few files. Some of those changes are based on our answers, while others are specific to the Kubernetes cluster and the vendor we're using.

We won't comment on all the changes that were done, but rather on the important ones, especially those that we might choose to modify in the future.

If you take a closer look at the output, you'll see that it created the `env/parameters.yaml` file. Let's take a closer look at it.

```bash
cat env/parameters.yaml
```

The output is as follows.

```yaml
adminUser:
  password: vault:jx-boot/adminUser:password
  username: admin
enableDocker: false
pipelineUser:
  email: viktor@farcic.com
  token: vault:jx-boot/pipelineUser:token
  username: vfarcic
prow:
  hmacToken: vault:jx-boot/prow:hmacToken
```

The `parameters.yaml` file contains the data required for Jenkins X to operate correctly. There are the administrative `username` and `username` and the information that Docker is not enabled (`enableDocker`). The latter is not really Docker but rather that the system is not using an internal Docker Registry but rather an external service. Further on, we can see the `email`, the `token`, and the `username` pipeline needs for accessing our GitHub account. Finally, we can see the `hmacToken` required for the handshake between GitHub webhooks and `prow`.

As you can see, the confidential information is not available in the plan-text format. Since we are using Vault to store secrets, some values are references to the Vault storage. That way, it is safe for us to keep that file in a Git repository without fear that sensitive information will be revealed to prying eyes.

We can also see from the `git diff` output that the `parameters.yaml` did not exist before. Unlike `requirements.yml` that existed from the start (and we modified it), that one was created by `jx boot`.

Which other file did the Boot process create or modify?

We can see that it made some modifications to the `jenkins-x.yml` file. We did not explore it just yet, so let's take a look at what we have right now.

```bash
cat jenkins-x.yml
```

The output is too long to be presented in a book, and you can see it on your screen anyway.

That is a `jenkins-x.yml` file like any other Jenkins X pipeline. The format is the same, but the content is tailor-made for the Boot process. It contains everything it needs to install or, later on, upgrade the platform.

What makes this pipeline unique, when compared with those we explored earlier, is that the `buildPack` is set to `none`. Instead of relying on a buildpack, the whole pipeline is defined in that `jenkins-x.yml` file. Whether that's a good thing or bad depends on the context. On the one hand, we will not benefit from future changes the community might make to the Boot process. On the other hand, those changes are likely going to require quite a few other supporting files. So, the community decided not to use the buildpack. Instead, if you'd like to update the Boot process, you'll have to merge the repository you forked with the upstream.

Now, let's get to business and take a closer look at what's inside `jenkins-x.yml`.

We can see that it is split into two pipelines; `pullRequest` and  `release`.

The `pullRequest` is simple, and it consists of a single `stage` with only one `step`. It executes `make build`. If you take a look at `env/Makefile` you'll see that it builds the charts in the `kubeProviders` directory, and afterward, it lints it. The real purpose of the `pullRequest` pipeline is only to validate that the formatting of the charts involved in the Boot process is correct. It is very similar to what's being done with pull requests to the repositories associated with permanent environments like staging and production.

The "real" action is happening in the `release` pipeline, which, as you already know, is triggered when we make changes to the master branch.

The `release` pipeline contains a single stage with the same name. What makes it special is that there are quite a few steps inside it, and we might already be familiar with them from the output of the `jx boot` command.

We'll go through the steps very briefly. All but one of those are based on `jx` commands, which you can explore in more depth on your own.

The list of the steps, sorted by order of execution, is as follows.

|Step                       |Command                         |Description|
|---------------------------|--------------------------------|-----------|
|`validate-git`             |`jx step git validate`          |Makes sure that the `.gitconfig` file is configured correctly so that Jenkins X can interact with our repositories|
|`verify-preinstall`        |`jx step verify preinstall`     |Validates that our infrastructure is set up correctly before the process installs or upgrades Jenkins X|
|`install-jx-crds`          |`jx upgrade crd`                |Installs or upgrades Custom Resource Definitions required by Jenkins X|
|`install-velero`           |`jx step helm apply`            |Installs or upgrades [Velero](https://velero.io) used for creating backups of the system|
|`install-velero-backups`   |`jx step helm apply`            |Installs or upgrades Jenkins X nginx Ingress implementation|
|`install-nginx-controller` |`jx step helm apply`            |Installs nginx Ingress|
|`create-install-values`    |`jx step create install values` |Adds missing values (if there are any) to the `cluster/values.yaml` file used to install cluster-specific charts|
|`install-external-dns`     |`jx step helm apply`            |Installs or upgrades the support for external DNSes|
|`install-cert-manager-crds`|`kubectl apply`                 |Installs or upgrades CertManager CRDs|
|`install-cert-manager`     |`jx step helm apply`            |Installs or upgrades CertManager in charge of creating Let's Encrypt certificates|
|`install-acme-issuer...`   |`jx step helm apply`            |Installs or upgrades CertManager issuer|
|`install-vault`            |`jx step boot vault`            |Installs or upgrades HashiCorp Vault|
|`create-helm-values`       |`jx step create values`         |Creates or updates the `values.yaml` file used by Charts specific to the selected Kubernetes provider|
|`install-jenkins-x`        |`jx step helm apply`            |Installs Jenkins X|
|`verify-jenkins-x-env...`  |`jx step verify`                |Verifies the Jenkins X environment|
|`install-repositories`     |`jx step helm apply`            |Makes changes to the repositories associated with environments (e.g., webhooks)|
|`install-pipelines`        |`jx step scheduler`             |Creates Jenkins X pipelines in charge of environments|
|`update-webhooks`          |`jx update webhooks`            |Updates webhooks for all repositories associated with applications managed by Jenkins X|
|`verify-installation`      |`jx step verify install`        |Validates Jenkins X setup|

Please note that some of the components (e.g., Vault) are installed, upgraded, or deleted depending on whether they are enabled or disabled in `jx-requirements.yml`.

As you can see, the process consists of the following major groups of steps.

* Validate requirements
* Define values used to apply Helm charts
* Apply Helm charts
* Validate the setup

The Helm charts used to set up the system are stored in `systems` and `env` directories. They do not contain templates, but rather only `values.yaml` and `requirements.yaml` files. If you open any of those, you'll see that the `requirements.yaml` file is referencing one or more Charts stored in remote Helm registries.

That's all we should know about the `jenkins-x.yml` file, at least for now. The only thing left to say is that you might choose to extend it by adding steps specific to your setup, or you might even choose to add those unrelated with Jenkins X. For now, I will caution against such actions. If you do decide to modify the pipeline, you might have a hard time merging it with upstream. That, by itself, shouldn't be a big deal, but there is a more important reason to exercise caution. I did not yet explain everything there is to know about Jenkins X Boot. Specifically, we are yet to explore Jenkins X Apps (not to be confused with Applications). They allow us to add additional capabilities (components, applications) to our cluster and manage them through Jenkins X Boot. We'll get there in due time. For now, we'll move to yet another file that was modified by the process.

Another file that changed is `jx-requirements.yml`. Part of the changes are those we entered, like `clusterName`, `environmentGitOwner`, and quite a few others. But, some of the moodifications were done by `jx boot` as well. Let's take a closer look at what we got.

```bash
cat jx-requirements.yml
```

The output is as follows.

```yaml
autoUpdate:
  enabled: false
  schedule: ""
bootConfigURL: https://github.com/vfarcic/jenkins-x-boot-config
cluster:
  clusterName: jx-boot
  environmentGitOwner: vfarcic
  gitKind: github
  gitName: github
  gitServer: https://github.com
  namespace: jx
  project: devops-26
  provider: gke
  registry: gcr.io
  zone: us-east1
environments:
- ingress:
    domain: 34.74.196.229.nip.io
    externalDNS: false
    namespaceSubDomain: -jx.
    tls:
      email: ""
      enabled: false
      production: false
  key: dev
- ingress:
    domain: ""
    externalDNS: false
    namespaceSubDomain: ""
    tls:
      email: ""
      enabled: false
      production: false
  key: staging
- ingress:
    domain: ""
    externalDNS: false
    namespaceSubDomain: ""
    tls:
      email: ""
      enabled: false
      production: false
  key: production
gitops: true
ingress:
  domain: 34.74.196.229.nip.io
  externalDNS: false
  namespaceSubDomain: -jx.
  tls:
    email: ""
    enabled: false
    production: false
kaniko: true
repository: nexus
secretStorage: vault
storage:
  backup:
    enabled: false
    url: ""
  logs:
    enabled: true
    url: gs://jx-boot-logs-0976f0fd-80d0-4c02-b694-3896337e6c15
  reports:
    enabled: true
    url: gs://jx-boot-reports-8c2a58cc-6bcd-47aa-95c6-8868af848c9e
  repository:
    enabled: true
    url: gs://jx-boot-repository-2b84c8d7-b13e-444e-aa40-cce739e77028
vault: {}
velero: {}
versionStream:
  ref: v1.0.214
  url: https://github.com/jenkins-x/jenkins-x-versions.git
webhook: prow
```

As you can see both from `git diff` and directly from `jx-requirements.yml`, the file does not contain only the changes we made initially. The `jx boot` command modified it as well by adding some additional information. I'll assume that you do remember which changes you made, so we'll comment only on those done by Jenkins X Boot.

I> My output might not be the same as the one you're seeing on the screen. Jenkins X Boot might have features that did not exist at the time I wrote this chapter (October 2019). If you notice changes that I am not commenting on, you'll have to consult the documentation to get more information.

At the very top, we can see that `jx boot` added the `autoUpdate` section, which did not even exist in the repository we forked. That's normal since that repo does not necessarily contain all the entries of the currently available Boot schema. So, some might be added even if they are empty.

We won't go into `autoUpdate` just yet. For now, we're interested only in installation. Updates and upgrades are coming later.

Inside the `cluster` section, we can see that it set `gitKind` and `gitName` to `github` and `gitServer` to `https://github.com`. Jenkins X's default assumption is that you're using GitHub. If that's not the case, you can change it to some other Git provider. As I already mentioned, we'll explore that together with Lighthouse later. It also set the `namespace` to `jx`, which, if you remember, is the default Namespace for Jenkins X.

The `environments` section is new, as well. We can use one of its sub-entries to change Ingress used for a specific environment (e.g., `production`). Otherwise, the `ingress` entries (at the root) are applied to the whole cluster (to all the environments).

Speaking of `ingress`, you'll notice that the `domain` entry inside it was auto-generated. Since we did not specify a domain ourselves, it used `.nip.io` in the same way we were using it so far. Ingress, both on the cluster and on the environment level, is a separate topic that we'll explore later.

Finally, we can see that it added values to `url` entries in `storage`. We could have created storage and set those values ourselves. But we didn't. We let Jenkins X Boot create it for us and update those entries with the URLs. We'll explore in more detail what we can do (if anything) with those storages. For now, just note that the Boot created them for us.

That's it. Those are all the files that were changed.

As you already saw, Jenkins X Boot run a pipeline that installed the whole platform. Given that we did not have Jenkins X running inside the cluster, that pipeline was executed locally. But, we are not expected to keep maintaining our setup by running pipelines ourselves. If, for example, we'd like to upgrade some aspect of the platform, we should be able to push changes to the repository and let the system run the pipeline for us, even if that pipeline will affect Jenkins X itself. The first step towards confirming that is to check which pipelines we currently have in the cluster.

## Verifying Jenkins X Boot Installation

Let's take a quick look at the pipelines currently active in our cluster.

```bash
jx get pipelines --output yaml
```

The output is as follows.

```
- vfarcic/environment-jx-boot-dev/master
- vfarcic/environment-jx-boot-production/master
- vfarcic/environment-jx-boot-staging/master
```

We are already used to working with `production` and `staging` pipelines. What is new is the `dev` pipeline. That is the one we just executed locally. It is now available in the cluster as well, and we should be able to trigger it by pushing a change to the associated repository. Let's test that.

We'll explore the Jenkins X upgrade process later. For now, we just want to see whether the `dev` repository is indeed triggering pipeline activities. We'll do that by making a trivial change to the README.md file.

```bash
echo "A trivial change" \
    | tee -a README.md

git add .

git commit -m "A trivial change"

git push

jx get activities \
    --filter environment-$CLUSTER_NAME-dev \
    --watch
```

We pushed the changes to GitHub and started watching the activities of the `dev` pipeline. The output, when the activity is finished, should be as follows.

```
STEP                                      STARTED AGO DURATION STATUS
vfarcic/environment-jx-boot-dev/master #1       4m10s    3m52s Succeeded 
  release                                       4m10s    3m52s Succeeded 
    Credential Initializer 7jh9t                4m10s       0s Succeeded 
    Working Dir Initializer Tr2wz               4m10s       2s Succeeded 
    Place Tools                                  4m8s       2s Succeeded 
    Git Source Vfarcic Environment Jx...         4m6s      36s Succeeded https://github.com/vfarcic/environment-jx-boot-dev.git
    Git Merge                                   3m30s       1s Succeeded 
    Validate Git                                3m29s       1s Succeeded 
    Verify Preinstall                           3m28s      26s Succeeded 
    Install Jx Crds                              3m2s      10s Succeeded 
    Install Velero                              2m52s      12s Succeeded 
    Install Velero Backups                      2m40s       2s Succeeded 
    Install Nginx Controller                    2m38s      16s Succeeded 
    Create Install Values                       2m22s       0s Succeeded 
    Install External Dns                        2m22s      16s Succeeded 
    Install Cert Manager Crds                    2m6s       0s Succeeded 
    Install Cert Manager                         2m6s      16s Succeeded 
    Install Acme Issuer And Certificate         1m50s       2s Succeeded 
    Install Vault                               1m48s       8s Succeeded 
    Create Helm Values                          1m40s       3s Succeeded 
    Install Jenkins X                           1m37s     1m3s Succeeded 
    Verify Jenkins X Environment                  34s       5s Succeeded 
    Install Repositories                          29s       5s Succeeded 
    Install Pipelines                             24s       1s Succeeded 
    Update Webhooks                               23s       4s Succeeded 
    Verify Installation                           19s       1s Succeeded 
```

That's the first activity (`#1`) of the `dev` pipeline. To be more precise, it is the second one (the first was executed locally) but, from the perspective of Jenkins X inside the cluster, which did not exist at the time, that is the first activity. Those are the steps of Jenkins X Boot running inside our cluster.

We won't go through the changes that were created by that activity since there are none. We did not modify any of the files that matter. We already used those same files when we executed Jenkins X Boot locally. All we did was push the change of the README file from the local repository to GitHub. That triggered a webhook that notified the cluster that there are some changes to the remote repo. As a result, the first in-cluster activity was executed.

The reason I showed you that activity was not due to an expectation of seeing some change applied to the cluster (there were none), but to demonstrate that, from now on, we should let Jenkins X running inside our Kubernetes cluster handle changes to the `dev` repository, instead of running `jx boot` locally. That will come in handy later on when we explore how to upgrade or change our Jenkins X setup.

Please press *ctrl+c* to stop watching the activity.

Let's take a look at the Namespaces we have in our cluster.

```bash
kubectl get namespaces
```

The output is as follows.

```
NAME         STATUS AGE
cert-manager Active 28m
default      Active 74m
jx           Active 34m
kube-public  Active 74m
kube-system  Active 74m
velero       Active 33m
```

As you can see, there are no Namespaces for staging and production environments. Does that mean that we do not get them with Jenkins X Boot?

Unlike other types of setup, the Boot creates environments lazily. That means that they are not created in advance, but rather when used for the first time. In other words, the `jx-staging` Namespace will be created the first time we deploy something to the staging environment. The same logic is applied to any other environment, the production included.

To put your mind at ease, we can output the environments and confirm that staging and production were indeed created.

```bash
jx get env
```

The output is as follows.

```
NAME       LABEL       KIND        PROMOTE NAMESPACE     ORDER CLUSTER SOURCE                                                        REF    PR
dev        Development Development Never   jx            0             https://github.com/vfarcic/environment-jx-boot-dev.git        master 
staging    Staging     Permanent   Auto    jx-staging    100           https://github.com/vfarcic/environment-jx-boot-staging.git    master 
production Production  Permanent   Manual  jx-production 200           https://github.com/vfarcic/environment-jx-boot-production.git master 
```

`Staging` and `production` environments do indeed exist, and they are associated with corresponding Git repositories, even though Kubernetes Namespaces were not yet created. 

While we're on the subject of environments, we can see something that did not exist in the previous setups. What's new, in this output, is that the `dev` environment also has a repo set as the source. That was not the case when we were creating clusters with `jx create cluster` or installing Jenkins X with `jx install`. In the past, the `dev` environment was not managed by GitOps principles. Now it is.

The associated `source` is the repository we forked, and it contains the specification of the whole `dev` environment and a few other things. From now on, if we need to modify Jenkins X or any other component of the platform, all we have to do is push a change to the associated repository. A pipeline will take care of converging the actual with the desired state. From this moment onward, everything except infrastructure is managed through GitOps. I intentionally said "except infrastructure" because I did not show you explicitly how to create a pipeline that will execute Terraform or whichever tool you're using to manage your infra. However, that is not an excuse for you not to do it. By now, you should have enough knowledge to automate that last piece of the puzzle by creating a Git Repository with `jenkins-x.yml` and importing it into Jenkins X. If you do that, everything will be using GitOps, and everything will be automated, except writing code and pushing it to Git. Do not take my unwillingness to force a specific tool (e.g., Terraform) as a sign that you shouldn't walk that last mile.

To be on the safe side, we'll create a new quickstart project and confirm that the system is behaving correctly. We still need to verify that lazy creation of environments works as expected.

```bash
cd ..

jx create quickstart \
    --filter golang-http
```

We went back from the local copy of the `dev` repository and started the process of creating a new `quickstart`.

You might be wondering why we didn't use the `--batch-mode` as we did countless times before. This time, we installed Jenkins X using a different method, and the local cache does not have the information it needs to create a `quickstart` automatically. So, we'll need to answer a series of questions, just as we did at the beginning of the book. That is only a temporary issue. The moment we create the first quickstart manually, the information will be stored locally, and every consecutive attempt to create new quickstarts can be done with the `--batch-mode`, as long as we're using the same laptop.

Please answer the questions any way you like. Just bear in mind that I expect you to name the repository `jx-boot`. If you call it differently, you'll have to modify the commands that follow.

All that's left now is to wait until the activity of the pipeline created by the quickstart process is finished.

```bash
jx get activity \
    --filter jx-boot/master \
    --watch
```

Please press *ctrl+c* to stop watching the activity once it's finished.

We'll also confirm that the activity of the staging environment is finished as well.

```bash
jx get activity \
    --filter environment-$CLUSTER_NAME-staging/master \
    --watch
```

You know what to do. Wait until the new activity is finished and press *ctrl+c* to stop watching.

Let's retrieve the Namespaces again.

```bash
kubectl get namespaces
```

The output is as follows.

```
NAME         STATUS AGE
cert-manager Active 34m
default      Active 80m
jx           Active 40m
jx-staging   Active 55s
kube-public  Active 80m
kube-system  Active 80m
velero       Active 39m
```

As you can see, the `jx-staging` Namespace was created the first time an application was deployed to the associated environment, not when we installed the platform. The `jx-production` Namespace is still missing since we did not yet promote anything to production. Once we do, that Namespace will be created as well.

I won't bother you with the commands that would confirm that the application is accessible from outside the cluster, that we can create preview (pull request) environments, and that we can promote releases to production. I'm sure that, by now, you know how to do all that by yourself.

## What Now?

We did not dive into everything Jenkins X Boot offers. We still need to discuss how to use it to update or upgrade Jenkins X and the related components. There are also a few other features that we skipped. For now, I wanted you to get a taste of what can be done with it. We'll discuss it in more detail in the next chapter. Right now, you should have at least a basic understanding of how to install the platform using Jenkins X Boot. More will come soon.

Just like in the previous chapters, now you need to choose whether you want to move to the next chapter right away or you'd like to have a break. If you choose the latter, the Gists we used to create the cluster contain the instructions on how to destroy it as well. Once the cluster is no more, use the commands that follow to delete (most of) the repositories. The next chapter will contain an explanation of how to create everything we need from scratch.

```bash
hub delete -y \
    $GH_USER/environment-$CLUSTER_NAME-staging

hub delete -y \
    $GH_USER/environment-$CLUSTER_NAME-production

hub delete -y \
    $GH_USER/jx-boot

rm -rf jx-boot
```

You'll notice that we did NOT delete the `dev` repository used with Jenkins X Boot. We'll keep it because that'll simplify the installation in the next chapter. That's the beauty of GitOps. The Jenkins X definition is in Git, and it can be used or reused whenever we need it.

# Using Terraform To Define Infrastructure as Code For Managed Kubernetes Clusters

## Abstract

You might have already used one of the tools to manage your infrastructure as code. That might have been Terraform, or something else. Or, maybe you didn't. If that's the case, you might be wondering if there is anything wrong with creating your cluster through a browser-based console provided by your hosting vendor. The short answer is "yes". It's very wrong.

Clicking buttons and filling in some forms in a browser is a terrible idea. Such actions result in undocumented and unreproducible processes. You surely want to document what you did so that you can refer to that later. You probably want your colleagues to know what you did so that they can collaborate. Finally, you probably want to be fast. Ad hoc actions in Web-based consoles do not provide any of those things. You'd need to write Wiki pages to document the steps. If you do that, you'll quickly find out that it is easier to write something like "execute `aws ...`" than to write pages filled with "go to this page", "fill in this field with that value", "click that button", and similar tedious entries that are often accompanied with screenshots. We want to define the instructions on how to create and manage infrastructure as code. We want them to be executable, stored in Git, and, potentially, executed whenever we push a change.

If a Web UI is not the right place to manage infrastructure, how about commands? We can surely do everything we need to do with a CLI. We can handle everything related to GCP with `gcloud`. We could use `aws` for the tasks in AWS, and Azure is fully covered with `az` CLI. While those options are better than the click-click-click type of operations, those are also not good options.

Using a CLI might seem like a good idea at first. We can, for example, create a fully operational GKE cluster by executing `gcloud container clusters create`. However, that is not idempotent. The next time we want to upgrade it, the command will be different. On top of that, CLIs do not tend to provide dependency management, so we need to make sure that we execute them in the right order. They also do not have state management, so we cannot easily know what is done and what is not. They cannot show us which changes will be applied before we execute a command. The list of things that CLI commands often do not do is vast. Now, if your only choices are only click-click-click through a UI and CLI commands, choose the latter. But those are not the only options.

We'll explore how to define and manage Infrastructure as Code (IaC) using Terraform. We will create a fully operational production-ready managed Kubernetes cluster. You will be able to choose between AWS (EKS), Azure (AKS), and Google Cloud (GKE).

## Agenda

* Introduction to creating And Managing managed Kubernetes With Terraform
* Exploring Terraform Variables
* Creating The Credentials
* Defining The Provider
* Storing The State In A Remote Backend
* Creating The Control Plane
* Exploring Terraform Outputs
* Creating Worker Nodes
* Upgrading The Cluster
* Reorganizing The Definitions
* Destroying The Resources

## Pre-Requirements

Before coming to the workshop, you will need to fullfil a few requirements.

* [Download Terraform](https://www.terraform.io/downloads.html) CLI and install it
* [Install and set up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* AWS, Azure, or Google account with admin privileges
* Bash terminal (if using Windows, [install Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or any Bash emulator like GitBash installable through [Git](https://gitforwindows.org/))

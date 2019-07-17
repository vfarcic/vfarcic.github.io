## Context

---

* Legacy + 3 years of Technical debt
* Migration to microservices
* Standard PHP -> Java
* Agile
* On-premise -> Cloud


## New team (9 months ago)

---

* 1 Frontend developer
* 2 CI oriented devs
* 2 legacy oriented devs
* 4 CD oriented devs 
* 1 External consultant (POC)
* Small team, planned increase 3 new members
* Devs requirements to Devops teams


## Pipeline CIs

---

* Done in Jenkins
* External repo Groovy (shared_library) + Jenkinsfiles
* Properties in pipeline.yml (file in app’s repo)
* Docker containers (Nothing is installed on jenkins runners)
* 2 Harbor + 2 registries on-premise
* Repository of Dockerfile utils (docker_base_creator)
* Usage of public images for testing
* Auto-versioning: Release + Snapshot + Hotfix
* Different languages: Node, Java, PHP + (Python + Go).
* 3 types of artifact: Docker / RPM / Libraries
* Artifactory
* Sonar
* Log output (stdout)
* Trigger per job (listener Spinnaker)


## Pipeline CD

---

* Pipeline in ROER -> In code (template)
* Spinnaker as UI
* AD not filtered
* Triggered from Jenkins jobs or Harbor upload
* Docker AWS flow
* Different environments: K8s on-premise, AWS EC2, Kubernetes on cloud (kubespray), EKS?
* Infrastructure with Terraform
* infra.yml (defines the infrastructure) & Tf.vars (values) inside each repo
* Not rollback strategy implemented


## Microservices

---

Docker + docker compose in EC2 ???
RPM in CentOS EC2
Bootstrap script on EC2 startup, different in Docker and RPM
Logs with tdagent “fluentd” in Elasticsearch + Kibana
EC2 monitoring with Telegraf and Influx
Alerting with Kapacitor & Cloudwatch ???


## Master Data

---

* Developed in Python
* Used for Smart Monitoring (Pagerduty)
* Main application for Application Catalog


## Popeye

---

* Created in Angular + PHP API
* User interface to create and configure new apps ???
* Creates infrastructure and CI/CD pipelines
* Jenkins jobs do the work


# Doubts

---


## Pipeline CI

---

* Maintenance: Jenkins, Pipelines Hierarchy -> Move logic from shared library to jenkinsfile.
* Easily escalation? -> Use helm Jenkins with defined plugins.
* Testing best practices -> Sonar stops execution. Do not wait for service. Applications shut down and restart until the dependencies are OK.
* Security tests during CI pipeline / docker images. -> If it’s useful, yes. Claire sin la “e”
* Versionate -> 


## Pipeline CD

---

K8s -> Spinnaker. Only to show the last step (deploy) in AWS. Not useful in K8s. All the logic centralized in Jenkins. Return important information to the developer. Helm hierarchy for atomic changes, pointing to the version of the base helm in the artifactory.
Terraform -> Test only if it’s gonna survive
Rollback strategies
AMI templates (Bootstrapping)
Deploying strategies (Canary AWS & K8s) -> Istio, Service Mesh?
Lifecycle AMI -> repo restructured
Attach code to Infrastructure -> 


## Microservices

---

* Logs -> 
* Monitoring: 
* DB Migrations: 
* Config manager: No acoplar las aplicaciones a nivel de librerías con Consul/Vault
* Secrets
* K8s on premise : Mala idea master y workers a la vez cluster onpremise
* Desaprovisionar 1 master físico sustituir por un master virtual.
* Other cloud services (Alibaba cloud, etc.) 
* Kubernetes : GKE, AKS, EKS


## Troubleshooting

---

* Jenkins Stability improvement -> Jenkins en k8s
* Development team + Support team


## Master data

---

* Service Catalog
* Health Checks


## Popeye

---

Tools to the developers


## Docker

---

* Lifecycle images -> 1 aplicación, 1 repositorio. Versionádo.
* Security external images
* Docker + Java


## Methodologies

---

* Grant permissions to developers? (limits)
* Share information with teams.
* Shared responsibilities
* Standardisation

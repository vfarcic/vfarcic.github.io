## Software engineering should be...


<iframe width="840" height="630" src="https://www.youtube.com/embed/jv2WJMVPQi8" data-autoplay></iframe>


# That!


## When I started my career I learned...

* ...Pascal
* ...to write code
* ...how to test it myself
* ...how to package it and deploy it myself
* ...how to install it and manage DBs
* ...fix my own mistakes


<!-- .slide: data-background-image="img/db-schema-git/one-man-band.png" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/commodore.jpeg" data-background-size="cover" -->


# Today?

* Backend developers
* Frontend developers
* Networking experts
* Virtualization experts
* Database admins
* Security experts
* ...


# (Almost) useless in isolation...


# ... but wonderful when played together


<!-- .slide: data-background-image="img/db-schema-git/concert.jpg" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/wall.png" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/anatomy.png" data-background-size="cover" -->


## Example:
# Database Administrators


<!-- .slide: data-background-image="img/db-schema-git/violinist.jpg" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/concert.jpg" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/a-team.webp" data-background-size="cover" -->


# The team MUST own..

* ... app
* ... DB
* ... servers
* ... pipelines
* ... repo
* ...


# What is this?

```bash
cat silly-demo/app.yaml
```


<!-- .slide: data-background-image="img/db-schema-git/material.jpg" data-background-size="cover" -->


# What was that?

* NOT a definition of an application
* Low-level resources (building blocks)


# What is this?

```bash
gh repo view vfarcic/crossplane-sql --web
```


# What was that?

* Low-level resources (building blocks)


<!-- .slide: data-background-image="img/db-schema-git/material-2.jpg" data-background-size="cover" -->


# What is this?

```bash
kubectl get compositions
```


# What was that?

* A service usable by (almost) anyone
* Codified expert knowledge


<!-- .slide: data-background-image="img/db-schema-git/instruments.jpg" data-background-size="cover" -->


# What is this?

```bash
cat crossplane/sql-claim.yaml
```


# What was that?

* Service fine-tuned for a specific purpose


<!-- .slide: data-background-image="img/db-schema-git/instrument-tuning.jpg" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/kraftwerk.webp" data-background-size="cover" -->


# What is this?

```bash
cat main.go
```


# What is this?

```bash
cat atlas/schema.yaml
```


# What was that?

* Code
* Instructions that can be interpreted by machines


<!-- .slide: data-background-image="img/db-schema-git/notes.jpg" data-background-size="cover" -->


<!-- .slide: data-background-image="img/db-schema-git/lock.jpg" data-background-size="cover" -->


# What is this?

```bash
cp silly-demo/app.yaml crossplane/sql-claim.yaml \
    atlas/schema.yaml apps/.

git add .

git commit -m "Not touching the system"

git push
```


<!-- .slide: data-background-image="img/db-schema-git/open-gitops.png" data-background-size="cover" -->


# The concert can start?


<!-- .slide: data-background-image="img/db-schema-git/conductor.jpg" data-background-size="cover" -->


<!-- .slide: data-background-image="../img/products/kubernetes.png" data-background-size="contain" -->


<!-- .slide: data-background-image="img/db-schema-git/robots.png" data-background-size="cover" -->


# Who Does What?

* Craftsmen (e.g., DBAs) create instruments (services)
* Musicians (e.g., developers) tune the instruments (service instances)
* Notes (e.g., code) is the symphony (system)
* Conductors (e.g., Kubernetes) orchestrate the music (processes)
* Music (e.g., functionalities of processes) is performed by orchestra musicians (machines)


<!-- .slide: data-background-image="img/db-schema-git/instruments.jpg" data-background-size="cover" -->
```bash
kubectl --namespace production \
    get deployments,sqlclaims,atlasschemas
```


<!-- .slide: data-background-image="img/db-schema-git/material.jpg" data-background-size="cover" -->
```bash
kubectl --namespace production \
    get replicasets,pods,services,managed
```


<!-- .slide: data-background-image="img/db-schema-git/conductor.jpg" data-background-size="cover" -->
```bash
kubectl version --output yaml
```


<!-- .slide: data-background-image="img/db-schema-git/concert-hall.jpg" data-background-size="cover" -->
```bash
kubectl get nodes
```

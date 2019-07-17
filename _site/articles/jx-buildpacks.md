# Creating Custom Build Packs

I stand by my claim that "you do not need to understand Kubernetes to **use Jenkins X**." To be more precise, those who do not want to know Kubernetes and its ecosystem in detail can benefit from Jenkins X ability to simplify the processes around software development lifecycle. That's the promise or, at least, one of the driving ideas behind the project. Nevertheless, for that goal to reach as wide of an audience as possible, we need a variety of build packs. The more we have, the more use cases can be covered with a single `jx import` or `jx quickstart` command. The problem is that there is an infinite number of types of applications and combinations we might have. Not all can be covered with community-based packs. No matter how much effort the community puts into creating build packs, they will always be a fraction of what we might need. That's where you come in.

The fact that Jenkins X build packs cannot fully cover all our use cases does not mean that we shouldn't work on reducing the gap. Some of our applications will have a perfect match with one of the build packs. Others will require only slight modifications. Still, no matter how many packs we create, there will always be a case when the gap between what we need and what build packs offer is more significant.

Given the diversity in languages and frameworks we use to develop our applications, it is hard to avoid the need for understanding how to create new build packs. Those who want to expand the available build packs need to know at least basics behind Helm and a few other tools. Still, that does not mean that everyone needs to possess that knowledge. What we do not want is for different teams to reinvent the wheel and we do not wish for every developer to spend endless hours trying to figure out all the details behind the ever-growing Kubernetes ecosystem. It would be a waste of time for everyone to go through steps of importing their applications into Jenkins X, only to discover that they need to perform a set of changes to adapt the result to their own needs.

We'll explore how to create a custom build pack that could be highly beneficial for a (fictional) company. We'll imagine that there are multiple applications written in Go that depend on MongoDB and that there is a high probability that new ones based on the same stack will be created in the future. We'll explore how to create such a build pack with the least possible effort. 

> I will assume that you already have a cluster with Jenkins X up-and-running. If that's not the case, please consult the [jenkins-x.io](https://jenkins-x.io/).

## Creating A Build Pack For Go Applications With MongoDB Datastore

We are going to create a build pack that will facilitate the development and delivery of applications written in Go and with MongoDB as datastore. Given that there is already a pack for applications written in Go (without the DB), the easiest way to create what we need is by extending it. We'll make a copy of the `go` build pack and add the things we're missing.

The community-based packs are located in `~/.jx/draft/packs/github.com/jenkins-x-buildpacks/jenkins-x-kubernetes`. Or, to be more precise, that's where those used with *Kubernetes Workloads* types are stored. Should we make a copy of the local `packs/go` directory? If we did that, our new pack would be available only on our laptop, and we would need to zip it and send it to others if they are to benefit from it. Since we are engineers, we should know better. All code goes to Git and build packs are not an exception.

If right now you are muttering to yourself something like "I don't use Go, I don't care", just remember that the same principles apply if you use a different build pack as the base that will be extended to suit your needs. Think of this as a learning experience that can be applied to any build pack.

We'll fork the repository with community build packs. That way, we'll store our new pack safely to our repo. If we choose to, we'll be able to make a pull request back to where we forked it from, and we'll be able to tell Jenkins X to add that repository as the source of build packs. For now, we'll concentrate on forking the repository.

```bash
open "https://github.com/jenkins-x-buildpacks/jenkins-x-kubernetes"
```

Please fork the repository by clicking the *Fork* button located in the top-right corner of the screen and follow the on-screen instructions.

Next, we'll clone the newly forked repo.

W> If you moved into this chapter straight after you finished reading the previous, you might still be in the local clone of the *go-demo-6* repository. If that's the case, please go one directory back before cloning `jenkins-x-kubernetes`. Please execute `cd ..` first.

W> Please replace `[...]` with your GitHub user before executing the commands that follow.

```bash
GH_USER=[...]

git clone https://github.com/$GH_USER/jenkins-x-kubernetes

cd jenkins-x-kubernetes
```

We cloned the newly forked repository and entered inside it.

Let's see what we got inside the `packs` directory.

```bash
ls -1 packs
```

The output is as follows.

```
D
appserver
csharp
dropwizard
environment
go
gradle
imports.yaml
javascript
liberty
maven
maven-java11
php
python
ruby
rust
scala
swift
typescript
```

As you can see, those directories reflect the same choices as those presented to us when creating a Jenkins X quickstart or when importing existing projects.

I> If you see `go-mongodb` in the list of directories, the [pull request](https://github.com/jenkins-x-buildpacks/jenkins-x-kubernetes/pull/22) I made a while ago was accepted and merged to the main repository. Since we are practicing, using it would be cheating. Therefore, ignore its existence. I made sure that the name of the directory we'll use (`go-mongo`) is different from the one I submitted in the PR (`go-mongodb`). That way, there will be no conflicts.

Let's take a quick look at the `go` directory.

```bash
ls -1 packs/go
```

The output is as follows.

```
Dockerfile
Makefile
charts
pipeline.yaml
preview
skaffold.yaml
watch.sh
```

Those are the files Jenkins X uses to configure all the tools involved in the process that ultimately results in the deployment of a new release. We won't dive into them just now. Instead, we'll concentrate on the `charts` directory that contains the Helm chart that defines everything related to installation and updates of an application. I'll let you explore it on your own. If you're familiar with Helm, it should take you only a few minutes to understand the files it contains.

Since we'll use `go` build pack as our baseline, our next step is to copy it.

```bash
cp -R packs/go packs/go-mongo
```

The first thing we'll do is to add environment variable `DB` to the `charts/templates/deployment.yaml` file. Its purpose is to provide our application with the address of the database. That might not be your preferred way of retrieving the address so you might come up with a different solution for your applications. Nevertheless, it's my application we're using for this exercise, and that's what it needs.

I won't tell you to open your favorite editor and insert the changes. Instead, we'll accomplish the same result with a bit of `sed` magic.

```bash
cat packs/go-mongo/charts/templates/deployment.yaml \
    | sed -e \
    's@ports:@env:\
        - name: DB\
          value: {{ template "fullname" . }}-db\
        ports:@g' \
    | tee packs/go-mongo/charts/templates/deployment.yaml
```

The command we just executed added the `env` section right above `ports`. The modified output was used to replace the existing content of `deployment.yaml`.

The next in line of the files we have to change is the `requirements.yaml` file. That's where we'll add `mongodb` as a dependency of the Helm chart.

```bash
echo "dependencies:
- name: mongodb
  alias: code-db
  version: 5.3.0
  repository:  https://kubernetes-charts.storage.googleapis.com
" | tee packs/go-mongo/charts/requirements.yaml
```

Please note the usage of the `code` string. Today (February 2019), that is still one of the features that are not documented. When the build pack is applied, it'll replace that string with the actual name of the application. After all, it would be silly to hard-code the name of the application since this pack should be reusable across many.

Now that we created the `mongodb` dependency, we should add the values that will customize MongoDB chart so that the database is deployed as a MongoDB replica set (a Kubernetes StatefulSet with two or more replicas). The place where we change variables used with a chart is `values.yaml`. But, since we want to redefine values of dependency, we need to add it inside the name or, in our case, the alias of that dependency.

```bash
echo "code-db:
  replicaSet:
    enabled: true
" | tee -a packs/go-mongo/charts/values.yaml
```

Just as with `requirements.yaml`, we used the "magic" string `code` that will be replaced with the name of the application during the import or the quickstart process. The `replicaSet.enabled` entry will make sure that the database is deployed as a multi-replica StatefulSet.

I> If you're interested in all the values available in the `mongodb` chart, please visit the [project README](https://github.com/helm/charts/tree/master/stable/mongodb).

You might think that we are finished with the changes, but that is not true. I wouldn't blame you for that if you did not yet use Jenkins X with a pull request (PR). I'll leave the explanation of how PRs work in Jenkins X for later. For now, it should be enough to know that the `preview` directory contains the template of the Helm chart that will be installed whenever we make a pull request and that we need to add `mongodb` there as well. The rest is on the need-to-know basis and reserved for the discussion of the flow of a Jenkins X PRs.

Let's take a quick look at what we have in the `preview` directory.

```bash
ls -1 packs/go-mongo/preview
```

The output is as follows.

```
Chart.yaml
Makefile
requirements.yaml
values.yaml
```

As you can see, that is not a full-fledged Helm chart like the one we have in the `charts` directory. Instead, it relies on dependencies in `requirements.yaml`.

```bash
cat packs/go-mongo/preview/requirements.yaml
```

The output is as follows.

```yaml
# !! File must end with empty line !!
dependencies:
- alias: expose
  name: exposecontroller
  repository: http://chartmuseum.jenkins-x.io
  version: 2.3.56
- alias: cleanup
  name: exposecontroller
  repository: http://chartmuseum.jenkins-x.io
  version: 2.3.56

  # !! "alias: preview" must be last entry in dependencies array !!
  # !! Place custom dependencies above !!
- alias: preview
  name: code
  repository: file://../code
```

If we exclude the `exposecontroller` which we will ignore for now (it creates Ingress for our applications), the only dependency is the one aliased `preview`. It points to the directory where the application chart is located. As a result, whenever we create a preview (through a pull request), it'll deploy the associated application. However, it will not install dependencies of that dependency, so we'll need to add MongoDB there as well.

Just as before, the `preview` uses `code` tag instead of a hard-coded name of the application.

If you take a look at the comments, you'll see that the file must end with an empty line. More importantly, the `preview` must be the last entry. That means that we need to add `mongodb` somewhere above it.

```bash
cat packs/go-mongo/preview/requirements.yaml \
    | sed -e \
    's@  # !! "alias@- name: mongodb\
  alias: preview-db\
  version: 5.3.0\
  repository:  https://kubernetes-charts.storage.googleapis.com\
\
  # !! "alias@g' \
    | tee packs/go-mongo/preview/requirements.yaml

echo '
' | tee -a packs/go-mongo/preview/requirements.yaml 
```

We performed a bit more `sed` of magic to add the `mongodb` dependency above the comment that starts with `# !! "alias`. Also, to be on the safe side, we added an empty line at the bottom as well.

Now we can push our changes to the forked repository.

```bash
git add .

git commit -m "Added go-mongo build pack"

git push
```

With the new build pack safely stored, we should let Jenkins X know that we want to use the forked repository.

We can use `jx edit buildpack` to change the location of our `kubernetes-workloads` packs. However, at the time of this writing (February 2019), there is a bug that prevents us from doing that ([issue 2955](https://github.com/jenkins-x/jx/issues/2955)). The good news is that there is a workaround. If we omit the name (`-n` or `--name`), Jenkins X will add the new packs location, instead of editing the one dedicated to `kubernetes-workloads` packs.

```bash
jx edit buildpack \
    -u https://github.com/$GH_USER/jenkins-x-kubernetes \
    -r master \
    -b
```

From now on, whenever we decide to create a new quickstart or to import a project, Jenkins X will use the packs from the forked repository `jenkins-x-kubernetes`. 

Go ahead and try it out if you have a Go application with MongoDB at hand.

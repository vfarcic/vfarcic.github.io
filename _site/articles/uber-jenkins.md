# Automating Jenkins Docker Setup

Jenkins is, by far, the most used CI/CD tool in the market. That comes as no surprise since it's been around for a while, it has one of the biggest open source communities, it has enterprise version for those who need it, and it is straightforward to extend it to suit (almost) anyone's needs.

Products that dominate the market for years tend to be stable and very feature rich. Jenkins is no exception. However, with age come some downsides as well. In the case of Jenkins, automation setup is one of the things that has a lot to be desired. If you need Jenkins to serve as an orchestrator of your automation and tasks, you'll find it to be effortless to use. But, if you need to automate Jenkins itself, you'll realize that it is not as smooth as you'd expect from modern tools. Never the less, Jenkins setup can be automated, and we'll go through one possible solution.

I will not go through everything we can do as part of Jenkins setup. A whole book could be written on that subject. Instead, I'll try to show you how to do two of the most common configuration steps. We'll automate the installation of Jenkins plugins and setup of an administrator user. If you have a need to add more to the mix, please drop me an email (you'll find my info on the [About](https://technologyconversations.com/about/) page).

Let us quickly go through the objectives we'll set in front of us.

## The Objectives

Automation is the key to success of any software company. Since I believe that every company is a software company (even though some are still not aware of that), we can say that automation is the key for everyone.

I expect that you are using Docker to run your services. If you're not, please reconsider your strategy. It provides so many benefits that ignoring it will mean that competition will overrun you. I won't go into details why Docker is great. You probably already know all that.

The short version of the objectives behind automated Jenkins setup is that we do not want to do anything but run a single command. The result should be a fully configured Jenkins master that we can multiply to as many instances as we need. Docker, through Swarm, will provide fault tolerance, (kind of) high availability, and what so not.

A bit longer version is that we want to set up all the plugins we'll need and create at least one administrative user. That does not mean that you will not add more plugins later. You probably will. However, that should not prevent us from pre-installing those that are most commonly used within your organization. Without at least one user, anyone could access your Jenkins master and, potentially, get access to your whole system. There is probably no need to discuss why we should avoid that.

Before we start working on automation, we'll run a Jenkins master manually and fetch some information that will be useful later on.

## Setting Up Jenkins Manually

We'll start by creating a Jenkins service inside a Swarm cluster. If you do not have one, you can easily convert your Docker for Windows/Mac/Linux to a single node cluster by executing `docker swarm init`.

W> If you are a Windows user, please run all the commands from *Git Bash* (installed through *Git*) or any other Bash you might have.

```bash
docker service create --name jenkins \
    -p 8080:8080 jenkins
```

After a while, `jenkins` image will be pulled, and the service will be running. Feel free to check the status by executing `docker service ps jenkins`.

Once Jenkins is up and running, we can open its UI in a browser.

> If you're a Windows user, Git Bash might not be able to use the `open` command. If that's the case, replace `open` with `echo`. As a result, you'll get the full address that should be opened directly in your browser of choice.

> If you're not using your local Docker for Windows/Mac/Linux engine as the only node in the cluster, please replace `localhost` with the IP of one of your Swarm nodes.

```bash
open "http://localhost:8080"
```

You should see the first screen of the setup where you should enter the *Administrator password*. It is available inside the `/var/jenkins_home/secrets/initialAdminPassword` file inside the container that hosts the service.

> If you're not using your local Docker for Windows/Mac/Linux engine as the only node in the cluster, please find the node where the service is running and SSH into it before executing the commands that follow.

```bash
ID=$(docker container ls -q \
    -f "label=com.docker.swarm.service.name=jenkins")

docker container exec -it $ID \
    cat /var/jenkins_home/secrets/initialAdminPassword
```

We used `docker container ls` command with a filter to find the ID of the container that hosts the service. Next, we executed a command that displayed content of the `/var/jenkins_home/secrets/initialAdminPassword` file. The output will vary from one execution to another. In my case, it is as follows.

```
ecd46df9ec1b420dadacdb56de9492c8
```

Please copy the password and paste it into the *Administrator password* field in Jenkins UI and follow the instructions to setup your Jenkins master. Choose the plugins that you'll need. When you reach the last setup screen called *Create First Admin User*, please use `admin` as both the username and the password.

Once the setup is finished, we can send a request that will retrieve the list of all the plugins we installed.

> Before we proceed, please check whether you have *jq* installed. If you don't, you can find on in its [official site](https://stedolan.github.io/jq/).

```
curl -s -k "http://admin:admin@localhost:8080/pluginManager/api/json?depth=1" \
  | jq -r '.plugins[].shortName' | tee plugins.txt
```

We sent a request to the Jenkins plugin manager API and retrieved all the plugins we installed during the manual setup. We piped the result to *jq* and filtered it in a way that only short names are output. The result is stored in the *plugins.txt* file.

We don't need Jenkins service anymore. It has only a temporary function that allowed us to retrieve the list of plugins we'll need. Let's destroy it.

```bash
docker service rm jenkins
```

## Creating Jenkins Image With Automated Setup

Before we define Dockerfile that we'll use to create Jenkins image with automatic setup, we need to figure out how to create at least one administrative user. Unfortunately, there is no (decent) API we can invoke. Our best bet is to execute a Groovy script that will do the job. The script is as follows.

```groovy
#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()

Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
```

The key is in the `hudsonRealm.createAccount("admin", "admin")` line. It creates an account with both username and password set to `admin`.

The major problem with that script is that it has the credentials hard-coded. We could convert them to environment variables, but that would be very insecure. Instead, we'll leverage Docker secrets. When attached to a container, secrets are stored in `/run/secrets` in-memory directory.

More secure (and flexible) version of the script is as follows.

```groovy
#!groovy

import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

def user = new File("/run/secrets/jenkins-user").text.trim()
def pass = new File("/run/secrets/jenkins-pass").text.trim()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount(user, pass)
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()

Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)
```

This time, we placed contents of `jenkins-user` and `jenkins-pass` files into variables and used them to create an account.

Please save the script as `security.groovy` file.

Equipped with the list of plugins stored in `plugins.txt` and the script that will create a user from Docker secrets, we can proceed and create a Dockerfile.

Please create `Dockerfile` with the content that follows.

```
FROM jenkins:alpine

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
```

The image will be based on `alpine` version of Jenkins which is much smaller and more secure than others.

We used `JAVA_OPTS` to disable the setup wizard. We won't need it since our setup will be fully automated.

Next, we're copying the `security.groovy` file into `/usr/share/jenkins/ref/init.groovy.d/` directory. Jenkins, when initialized, will execute all the Groovy scripts located in that directory. If you create additional setup scripts, that is the place you should place them.

Finally, we are copying the `plugins.txt` file that contains the list of all the plugins we need and passing that list to the `install-plugins.sh` script which is part of the standard distribution.

With the `Dockerfile` defined, we can build our image and push it to Docker registry.

> Please replace `vfarcic` with your Docker Hub user.

```bash
docker image build -t vfarcic/jenkins .

docker image push vfarcic/jenkins
```

With the image built and pushed to the Registry, we can, finally, create a Jenkins service.

## Creating Jenkins Service With Automated Setup

We should create a Compose file that will hold the definition of the service. It is as follows.

> Please replace `vfarcic` with your Docker Hub user.

```
version: '3.1'

services:

  main:
    image: vfarcic/jenkins
    ports:
      - 8080:8080
      - 50000:50000
    secrets:
      - jenkins-user
      - jenkins-pass

secrets:
  jenkins-user:
    external: true
  jenkins-pass:
    external: true
```

Save the definition as `jenkins.yml` file.

The Compose file is very straightforward. If defines only one service (`main`) and uses the newly built image. It is exposing ports `8080` for the UI and `50000` for the agents. Finally, it defines `jenkins-user` and `jenkins-pass` secrets.

We should create the secrets before deploying the stack. The commands that follow will use `admin` as both the username and the password. Feel free to change it to something less obvious.

```bash
echo "admin" | docker secret create jenkins-user -

echo "admin" | docker secret create jenkins-pass -
```

Now we are ready to deploy the stack.

```bash
docker stack deploy -c jenkins.yml jenkins
```

A few moments later, the service will be up and running. Please confirm the status by executing `docker stack ps jenkins`.

Let's confirm that everything works as expected.

```bash
open "http://localhost:8080"
```

You'll notice that this time, we did not have to go through the Setup Wizard steps. Everything is automated and the service is ready for use. Feel free to log in and confirm that the user you specified is indeed created.

If you create this service in a demo environment (e.g. your laptop) now is the time to remove it and free your resources for something else. The image you just built should be ready for production.

```bash
docker stack rm jenkins

docker secret rm jenkins-user

docker secret rm jenkins-pass
```

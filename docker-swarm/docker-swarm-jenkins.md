# Running Fault Tolerant Jenkins Inside A Docker Swarm Cluster

The text that follows contains excerpts from the *Automating Continuous Deployment Flow With Jenkins* chapter of the [The DevOps 2.1 Toolkit: Docker Swarm](https://leanpub.com/the-devops-2-1-toolkit) book. In this article, we'll discuss a way to create a Jenkins service inside a Docker Swarm cluster and some of the benefits such a service provides.

## Environment Setup

We'll start by creating a Docker Swarm cluster. I will assume you already have at least a basic knowledge how Docker Swarm Mode works. If you don't, I suggest you read the [Docker Swarm Introduction (Tour Around Docker 1.12 Series)](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) article or fetch [The DevOps 2.1 Toolkit: Docker Swarm](https://leanpub.com/the-devops-2-1-toolkit) book.

T> Some of the files will be shared between the host file system and Docker Machines we'll create soon. Docker Machine makes the whole directory that belongs to the current user available inside the VM. Therefore, please make sure that the code is cloned inside one of the user's sub-folders.

```bash
git clone https://github.com/vfarcic/cloud-provisioning.git

cd cloud-provisioning

scripts/dm-swarm-2.sh
```

We cloned the `cloud-provisioning` repository and executed the [scripts/dm-swarm.sh](https://github.com/vfarcic/cloud-provisioning/blob/master/scripts/dm-swarm-2.sh) script that created the production cluster.

Let's confirm that the cluster was indeed created correctly.

```bash
eval $(docker-machine env swarm-1)

docker node ls
```

The output of the `node ls` command is as follows (IDs are removed for brevity).

```
HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
swarm-2   Ready   Active        Reachable
swarm-1   Ready   Active        Leader
swarm-3   Ready   Active        Reachable
```

Now that the production cluster is up and running, we can create Jenkins service.

## Jenkins Service

Traditionally, we would run Jenkins in its own server. Even if we'd choose to share server's resources with other applications, the deployment would still be static. We'd run a Jenkins instance (without or without Docker) and hope that it never fails. The problem with this approach is in the fact that every application fails sooner or later. Either the process will stop, or the whole node will die. Either way, Jenkins, like any other application, will stop working at some moment.

The problem is that Jenkins become a critical application in many organizations. If we move the execution or, to be more precise, triggering of all automation into Jenkins, we create a strong dependency. If Jenkins is not running, our code is not built, it is not tested, and it is not deployed. Sure, when it fails, you can bring it up again. If the server it is running on stops working, you can deploy it somewhere else. The downtime, assuming that happens during working hours, will not be long. An hour, maybe two, or even more time will pass since the moment it stops working, someone finds out, notifies someone else, that someone restarts the application or provisions a new server. Is that a long time? It depends on the size of your organization. The more people depend on something, the bigger the cost when that something doesn't work. Even if such a downtime and the cost it produces is not critical, we already have all the knowledge and the tools to avoid it. All we have to do is create another service and let Swarm take care of the rest.

Let's create a Jenkins service.

```bash
mkdir -p docker/jenkins

docker service create --name jenkins \
    -p 8082:8080 \
    -p 50000:50000 \
    -e JENKINS_OPTS="--prefix=/jenkins" \
    --mount "type=bind,source=$PWD/docker/jenkins,target=/var/jenkins_home" \
    --reserve-memory 300m \
    jenkins:2.7.4-alpine

docker service ps jenkins
```

Jenkins stores its state in the file system. Therefore, we started by creating a directory (`mkdir`) on the host. It will be used as Jenkins home. Since we are inside one of the subdirectories of our host's user, the `docker/jenkins` directory is mounted on all the machines we created.

Next, we created the service. It exposes the internal port `8080` as `8082` as well as the port `50000`. The first one is used to access Jenkins' UI and the second for master/agent communication. We also defined the URL prefix as `/jenkins` and mounted the Jenkins home directory. Finally, we reserved `300m` of memory.

Once the image is downloaded, the output of the `service ps` command is as follows (IDs are removed for brevity).

```
NAME      IMAGE                NODE    DESIRED STATE CURRENT STATE          ERROR
jenkins.1 jenkins:2.7.4-alpine swarm-1 Running       Running 52 seconds ago
```

![Figure 6-1: Production cluster with the Jenkins service](images/ch06/cd-environment-jenkins-only.png)

Jenkins 2 changed the setup process. While the previous versions allowed us to run it without any mandatory configuration, the new Jenkins forces us to go through some steps manually. Unfortunately, at the time of this writing, there is no good API to help us automate the process. While there are some "tricks" we could use, the benefits are not high enough when compared with the additional complexity they introduce. After all, we'll setup Jenkins only once, so there is no big incentive to automate the process (at least until configuration API is created).

Let's open the UI.

```bash
open http://$(docker-machine ip swarm-1):8082/jenkins
```

The first thing you will notice is that you are required to introduce the *Administrator password*. Quite a few enterprise users requested security hardening. As a result, Jenkins cannot be accessed, anymore, without initializing a session. If you are new to Jenkins, or, at least, version 2, you might wonder what the password is. It is output to logs (in our case `stdout`) as well as to the `secrets/initialAdminPassword` file which will be removed at the end of the setup process.

Let's see the content of the `secrets/initialAdminPassword` file.

```bash
cat docker/jenkins/secrets/initialAdminPassword
```

The output will be a long string that represents the temporary password. Please copy it, go back to the UI, paste it to the *Administrator password* field, and click the *Continue button*.

![Figure 6-2: Unlock Jenkins screen](images/ch06/jenkins-setup-password.png)

Once you unlock Jenkins, you will be presented with a choice to *Install suggested plugins* or select those that fit your needs. The recommended plugins fit most commonly used scenarios so we'll go with that option.

Please click the *Install suggested plugins* button.

Once the plugins are downloaded and installed, we are presented with a screen that allows us to create the first admin user. Please use *admin* as both the *username* and the *password*. Fill free to fill the rest of the fields with any value. Once you're done, click the *Save and Finish* button.

![Figure 6-3: Create First Admin User screen](images/ch06/jenkins-setup-admin-user.png)

Jenkins is ready. All that's left, for now, is to click the *Start using Jenkins* button.

Now we can test whether Jenkins failover works.

## Jenkins Failover

Let's stop the service and observe Swarm in action. To do that, we need to find out the node it is running in, point our Docker client to it, and remove the container.

```bash
NODE=$(docker service ps -f desired-state=running jenkins | tail +2 | awk '{print $4}')

eval $(docker-machine env $NODE)

docker rm -f $(docker ps -qa -f "ancestor=jenkins:2.7.4-alpine")
```

We listed Jenkins processes and applied the filter that will return only the one with the desired state `running` (`docker service ps -f desired-state=running jenkins`). The output was piped to the tail command that removed the header (`tail +2`) and, later on, piped again to the `awk` command that limited the output to the fourth column (`awk '{print $4}'`) that contains the node the process is running in. The final result was stored in the `NODE` variable.

Later on, we used the `eval` command to create environment variables that will be used by our Docker client to operate the remote engine. Finally, we removed the container with the combination of the `ps` and `rm` commands.

As we already learned in the previous chapters, if a container fails, Swarm will run it again somewhere inside the cluster. When we created the service, we told swarm that the desired state is to have one instance running and Swarm is doing its best to make sure our expectations are fulfilled.

Let us confirm that the service is, indeed, running.

```bash
docker service ps jenkins
```

If Swarm decided to re-run Jenkins on a different node, it might take a few moments until the image is pulled. After a while, the output of the `service ps` command should be as follows.

```
NAME           IMAGE           NODE     DESIRED STATE  CURRENT STATE                   ERROR
jenkins.1      jenkins:alpine  swarm-3  Running        Running less than a second ago
 \_ jenkins.1  jenkins:alpine  swarm-1  Shutdown       Failed 5 seconds ago            "task: non-zero exit (137)"
```

We can do a final confirmation by reopening the the UI.

```bash
open http://$(docker-machine ip swarm-1):8082/jenkins
```

Since Jenkins does not allow unauthenticated users, you'll have to login. Please use *admin* as both the *User* and the *Password*.

You'll notice that, this time, we did not have to repeat the setup process. Even though a fresh new Jenkins image is run on a different node, the state is still preserved thanks to the host directory we mounted.

We managed to make Jenkins fault tolerant, but we did not manage to make it run without any downtime. Due to its architecture, Jenkins master cannot be scaled. As a result, when we simulated a failure by removing the container, there was no second instance to absorb the traffic. Even though Swarm re-scheduled it on a different node, there was some downtime. During a short period, the service was not accessible. While that is not a perfect situation, we managed to reduce downtime to a minimum. We made it fault tolerant, but could not make it run without downtime. Considering its architecture, we did the best we could.

## The DevOps 2.1 Toolkit: Docker Swarm

<a href="https://leanpub.com/the-devops-2-1-toolkit"><img src="https://technologyconversations.files.wordpress.com/2016/09/cover-ebook-small.png?w=287" alt="The DevOps 2.1 Toolkit: Docker Swarm" width="287" height="300" class="alignright size-medium wp-image-3383" /></a>If you liked this article, you might be interested in **[The DevOps 2.1 Toolkit: Docker Swarm](https://leanpub.com/the-devops-2-1-toolkit)** book. Unlike the previous title in the series (**[The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](http://www.amazon.com/dp/B01BJ4V66M)**) that provided a general overlook of some of the latest DevOps practices and tools, this book is **dedicated entirely to Docker Swarm* and the processes and tools we might need to **build, test, deploy, and monitor services** running inside a cluster.

The book is still under "development". You can get a copy from [LeanPub](https://leanpub.com/the-devops-2-1-toolkit).  It is also available as [The DevOps Toolkit Series](https://leanpub.com/b/thedevopstoolkitseries) bundle. If you download it now, before it is fully finished, you will get frequent updates with new chapters and corrections. More importantly, you will be able to influence the direction of the book by sending me your feedback.

I choose the lean approach to book publishing because I believe that early feedback is the best way to produce a great product. Please help me make this book a reference to anyone wanting to adopt Docker Swarm for cluster orchestration and scheduling.
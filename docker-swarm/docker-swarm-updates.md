Zero-Downtime Deployments To a Docker Swarm Cluster (Tour Around Docker 1.12 Series)
====================================================================================

![Docker Swarm](../img/swarm/swarm.png)

If this is your first contact with the new Docker Swarm (version 1.12+), please read [Docker Swarm Introduction](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) and [Integrating Proxy With Docker Swarm](https://technologyconversations.com/2016/08/01/integrating-proxy-with-docker-swarm-tour-around-docker-1-12-series/) articles. I will assume that you have (at least) a basic understanding of how to deploy Docker services to a Swarm cluster.

Today we'll explore how to accomplish zero-downtime deployments.

The shorter the iterations we are practicing, the greater the frequency of our deployments. Not so long ago, we were used to work in months long iterations that resulted in only a couple of deployments a year. I've been involved in projects that had a single deployment a year. The fear of uncertainty, inability to abandon the "factory model" (waterfall) for producing software, a minuscule (if any) automated test coverage, and a few other factors made the industry think that the better you plan and the longer you develop something, the better the end product. As a result, we were rarely deploying. The only exception were hot-fixes that, to be honest, were very frequent after the big *go-live*. That alone should have told us that there's something wrong with the model.

Never the less, almost no one works like that any more. Iterations are getting shorter and shorter, and the frequency of deployments greater and greater. Some of us do a couple of weeks long sprints and deploy at the end. Others adopted continuous deployment resulting in a new release to production every time a commit is made. No matter the frequency of your deployments, I bet it is higher then it was a couple of years ago. The chances are that you are continually challenged with requests to deploy more often than before.

The problem with increased deployment frequency is downtime. If we use the "traditional" approach and replace the old release with the new one, downtime is inevitable. The old release has to be stopped, and the new one needs to be deployed and initialized. That period might be anything from milliseconds to minutes and, sometimes, even hours. While such a downtime might have been acceptable when we were deploying only a couple of times a year, today it might be a reason to get out of business. The higher the deployment frequency, the bigger total downtime. Even if the whole process takes only a couple of seconds, when we multiply it with all the deployments we perform throughout a day, a week, or a month, the total time our services are unavailable might be considerable.

How do we fight deployment downtime?
------------------------------------

The most commonly used method that avoids excessive deployment downtime is to not deploy often. One could write a whole book on the subject of the importance of short iterations, and I'm sure you are already familiar with all the benefits of short sprints. Therefore, we'll skip this option.

For those living closer to the current age, the two most commonly used methods to deploy without downtime are [blue-green deployment](https://technologyconversations.com/2016/02/08/blue-green-deployment/) and *rolling updates*.

Let's set up a Swarm cluster before we discuss those processes and their pros and cons.

Environment Setup
-----------------

The examples that follow assume that you have [Docker Machine](https://www.docker.com/products/docker-machine) version v0.8+ that includes [Docker Engine](https://www.docker.com/products/docker-engine) v1.12+. The easiest way to get them is through [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

> If you are a Windows user, please run all the examples from *Git Bash* (installed through *Docker Toolbox*).

We'll set up three nodes that will form a Swarm cluster.

Please note that I won't go into details of the setup. It is the same as explained in the [Docker Swarm Introduction](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) article.

```
docker-machine create -d virtualbox node-1

docker-machine create -d virtualbox node-2

docker-machine create -d virtualbox node-3

eval $(docker-machine env node-1)

docker swarm init \
    --advertise-addr $(docker-machine ip node-1) \
    --listen-addr $(docker-machine ip node-1):2377

TOKEN=$(docker swarm join-token -q worker)

eval $(docker-machine env node-2)

docker swarm join --token $TOKEN $(docker-machine ip node-1):2377

eval $(docker-machine env node-3)

docker swarm join --token $TOKEN $(docker-machine ip node-1):2377

eval $(docker-machine env node-1)

docker node ls
```

![Docker Swarm cluster with three nodes](../img/swarm/swarm-nodes.png)

Now that we have the Swarm cluster up and running, we can deploy a service.

```bash
docker network create --driver overlay go-demo

docker service create --name go-demo-db \
  --network go-demo \
  mongo

docker service create --name go-demo \
  -e DB=go-demo-db \
  --network go-demo \
  vfarcic/go-demo:1.0
```

Let's wait until both services are running. We can confirm their statuses by executing the `service ls` command.

```bash
docker service ls # Wait until all services are running
```

Both services should, after a while, have replicas set to *1/1*. If they're not, please hold on a while longer.

Now that we have a working Swarm cluster and two services running, we can explore the ways to deploy a new release of the *go-demo*.

Deployment With a Downtime
--------------------------

If we would use Docker Compose, we'd have to change the version inside the *docker-compose.yml* file and execute `docker-compose up -d`. That command would stop the old container and run the new one in its place. Such an action would produce downtime since our service would not be operational during the period the old release is stopped until the new is running and the service inside it is fully initialized. That period can be only a few milliseconds, a few seconds, or, in some cases, even a few minutes. No matter the duration, there would be downtime, our system (or a part of it) would not be operational, our users would not be happy, and our business would suffer. The negative effect caused by this type of downtime is proportional to the deployment frequency. The more often we deploy, the more often parts of our system are not operational. That, in itself, would prevent us from deploying often. Continuous deployment would be unpractical, at best.

How can we design a process that would allow us to deploy as often as we want without producing any downtime? Two of the processes stick out as being most reliable and most commonly used. We can employ *rolling updates* or *blue-green deployment*. The good news is that Docker Swarm has rolling updates incorporated.

Rolling Updates
---------------

The idea behind rolling updates is to upgrade a service over time. It assumes that, at least, two instances are running. Once the update is initiated, the system will upgrade one instance at a time. If the number of instances is big, we can update more than one at a time, as long as the number is always smaller than or equal to the half. That way, at any given moment, at least half of our instances is always operational.

Let's see a simple scenario in action, before going deeper into the process.

Since rolling updates assume that there are, at least, two instances of a service, we'll start by scaling the *go-demo*.

```bash
docker service scale go-demo=2
```

We can confirm that both instances are running by executing the `service ps` command.

```bash
docker service ps go-demo
```

![go-demo service scaled to two instances](../img/swarm/swarm-update-01.png)

Now that we have two instances of the release *1.0*, we can update it to *1.1*.

```bash
docker service update --image vfarcic/go-demo:1.1 go-demo

docker service ps go-demo
```

The output of `service ps` command is as follows.

```
ID                         NAME           IMAGE                NODE    DESIRED STATE  CURRENT STATE                     ERROR
6ao2lnk4qbfyu8nyakgd8khjm  go-demo.1      vfarcic/go-demo:1.1  node-3  Ready          Preparing less than a second ago
36cciqrl70zpg85ydhvip838k   \_ go-demo.1  vfarcic/go-demo:1.0  node-2  Shutdown       Running about a minute ago
4pgiixl8rs7ujrmtr24aqw58n  go-demo.2      vfarcic/go-demo:1.0  node-3  Running        Running about a minute ago
```

As you can see, one of the instances was shut down, and Swarm started bringing up the new release in its place. During this time, the second instance of the old release is still running, and users should not experience any downtime. In the worst case scenario, they might notice that the service is slower during this short period. After all, performance is bound to drop if only 50% of our designed capacity is operational.

![One of the instances updated with the new release](../img/swarm/swarm-update-02.png)

A few moments later, once the first instance of the new release is running, Swarm will repeat the process with the second. If we repeat the `docker service ps go-demo` command, the output should be as follows.

```
ID                         NAME           IMAGE                NODE    DESIRED STATE  CURRENT STATE                    ERROR
6ao2lnk4qbfyu8nyakgd8khjm  go-demo.1      vfarcic/go-demo:1.1  node-3  Running        Running 2 seconds ago
36cciqrl70zpg85ydhvip838k   \_ go-demo.1  vfarcic/go-demo:1.0  node-2  Shutdown       Shutdown 4 seconds ago
0z7d5m1oeek2n2k16eia862mh  go-demo.2      vfarcic/go-demo:1.1  node-2  Running        Starting less than a second ago
4pgiixl8rs7ujrmtr24aqw58n   \_ go-demo.2  vfarcic/go-demo:1.0  node-3  Shutdown       Shutdown 1 seconds ago
```

![Both of the instances updated with the new release](../img/swarm/swarm-update-03.png)

If, for whatever reason, we'd like to rollback the release, we can run the same command again (only with time with the old image). Let's revert to the release *1.0*.

```bash
docker service update --image vfarcic/go-demo:1.0 go-demo
```

A few moments later, the output of the `docker service ps go-demo` command should be as follows.

```
ID                         NAME           IMAGE                NODE    DESIRED STATE  CURRENT STATE              ERROR
8vd6bmfxw0azmp9x7q1s9ovk6  go-demo.1      vfarcic/go-demo:1.0  node-2  Running        Running 10 seconds ago
6ao2lnk4qbfyu8nyakgd8khjm   \_ go-demo.1  vfarcic/go-demo:1.1  node-3  Shutdown       Shutdown 11 seconds ago
36cciqrl70zpg85ydhvip838k   \_ go-demo.1  vfarcic/go-demo:1.0  node-2  Shutdown       Shutdown 3 minutes ago
0x99b6s5it0aobghpi0mufjwi  go-demo.2      vfarcic/go-demo:1.0  node-3  Running        Running 7 seconds ago
6fmjtnhc6xxqoqh55cv7ymq7u   \_ go-demo.2  vfarcic/go-demo:1.1  node-2  Shutdown       Shutdown 9 seconds ago
55j39je5ogyx6g929iqsqwa87   \_ go-demo.2  vfarcic/go-demo:1.0  node-2  Shutdown       Shutdown 3 minutes ago
```

As you can see, Swarm reverted our service to release *1.0*. All we had to do is send an `update` command specifying the previous release as image.

![All instances reverted to the previous release](../img/swarm/swarm-update-04.png)

There are a few additional arguments we can use to fine tune our update process. We can, for example, use `--update-parallelism` and `--update-delay`.

Before we try them out, let's scale our service to six instances. That number will let us better observe the result.

```bash
docker service scale go-demo=6
```

After a few moments, we should have six instances of the *go-demo* service. As before, we can use the `service ps` to see the result. This time, we'll list only services with the *desired state* set to *running*. Please run the command that follows.

```bash
docker service ps -f desired-state=Running go-demo
```

The output is as follows.

```
ID                         NAME       IMAGE                NODE    DESIRED STATE  CURRENT STATE          ERROR
8vd6bmfxw0azmp9x7q1s9ovk6  go-demo.1  vfarcic/go-demo:1.0  node-2  Running        Running 5 minutes ago
6iq1fr4hb09dibcdntihzy5l6  go-demo.2  vfarcic/go-demo:1.0  node-3  Running        Running 3 minutes ago
753h053jwz5u5cmxa20o6ch9x  go-demo.3  vfarcic/go-demo:1.0  node-3  Running        Running 2 minutes ago
0u1rpubcscde991rv1dyrq7yk  go-demo.4  vfarcic/go-demo:1.0  node-2  Running        Running 2 minutes ago
1l3bsva3y1mkgg3gy7t26qeej  go-demo.5  vfarcic/go-demo:1.0  node-1  Running        Running 2 minutes ago
az186cg2qc7u68yn3u649tti8  go-demo.6  vfarcic/go-demo:1.0  node-1  Running        Running 2 minutes ago
```

![The service scaled to six instances](../img/swarm/swarm-update-05.png)

Now that we have six instances up and running, we can, for example, update two at the time and create a delay of 10 seconds between each iteration. The command is as follows.

```bash
docker service update \
    --update-parallelism 2 \
    --update-delay 10s \
    --image vfarcic/go-demo:1.1 \
    go-demo
```

Let's execute the `service ps` command a couple of times and see the result.

```bash
docker service ps -f desired-state=Running go-demo
```

The output is as follows.

```
ID                         NAME       IMAGE                NODE    DESIRED STATE  CURRENT STATE                   ERROR
8vd6bmfxw0azmp9x7q1s9ovk6  go-demo.1  vfarcic/go-demo:1.0  node-2  Running        Running 7 minutes ago
6iq1fr4hb09dibcdntihzy5l6  go-demo.2  vfarcic/go-demo:1.0  node-3  Running        Running 5 minutes ago
753h053jwz5u5cmxa20o6ch9x  go-demo.3  vfarcic/go-demo:1.0  node-3  Running        Running 4 minutes ago
dbwe8wakxeygzqm46ib3oy4o3  go-demo.4  vfarcic/go-demo:1.1  node-3  Running        Running less than a second ago
bv3lz21vpy1pqi7ikiood8opu  go-demo.5  vfarcic/go-demo:1.1  node-2  Running        Running less than a second ago
az186cg2qc7u68yn3u649tti8  go-demo.6  vfarcic/go-demo:1.0  node-1  Running        Running 4 minutes ago
```

![The first iteration with two instances updated with the new release](../img/swarm/swarm-update-06.png)

If we repeat the `service ps` command 10 seconds after the first two instances are running, the output will be as follows.

```
ID                         NAME       IMAGE                NODE    DESIRED STATE  CURRENT STATE           ERROR
8vd6bmfxw0azmp9x7q1s9ovk6  go-demo.1  vfarcic/go-demo:1.0  node-2  Running        Running 7 minutes ago
c0znaatnbpocrx7ype6x9bibl  go-demo.2  vfarcic/go-demo:1.1  node-1  Running        Running 2 seconds ago
1zcixr0xiw9i2pvs3vwzixsyn  go-demo.3  vfarcic/go-demo:1.1  node-2  Running        Running 2 seconds ago
dbwe8wakxeygzqm46ib3oy4o3  go-demo.4  vfarcic/go-demo:1.1  node-3  Running        Running 15 seconds ago
bv3lz21vpy1pqi7ikiood8opu  go-demo.5  vfarcic/go-demo:1.1  node-2  Running        Running 15 seconds ago
az186cg2qc7u68yn3u649tti8  go-demo.6  vfarcic/go-demo:1.0  node-1  Running        Running 5 minutes ago
```

![The second iteration with four instances updated with the new release](../img/swarm/swarm-update-07.png)

Finally, after the third round of updates, the `service ps` output is as follows.

```
ID                         NAME       IMAGE                NODE    DESIRED STATE  CURRENT STATE                   ERROR
2444ozyv65sjbb2khhfrtzt66  go-demo.1  vfarcic/go-demo:1.1  node-3  Running        Running less than a second ago
c0znaatnbpocrx7ype6x9bibl  go-demo.2  vfarcic/go-demo:1.1  node-1  Running        Running 13 seconds ago
1zcixr0xiw9i2pvs3vwzixsyn  go-demo.3  vfarcic/go-demo:1.1  node-2  Running        Running 13 seconds ago
dbwe8wakxeygzqm46ib3oy4o3  go-demo.4  vfarcic/go-demo:1.1  node-3  Running        Running 26 seconds ago
bv3lz21vpy1pqi7ikiood8opu  go-demo.5  vfarcic/go-demo:1.1  node-2  Running        Running 26 seconds ago
2f8vmidev3oyjc7e4jkdpsqd9  go-demo.6  vfarcic/go-demo:1.1  node-3  Running        Preparing 3 seconds ago
```

![The last iteration with all instances updated with the new release](../img/swarm/swarm-update-08.png)

By observing the image and the current state of those outputs, we can see that Swarm updated two instances at a time and waited for ten seconds before starting the next iteration.

Now that we know Docker Swarm *rolling updates* basics, the natural question is whether there is an alternative. Is there another way to deploy services to a Swarm cluster and do the process without producing any downtime?

Blue-Green Deployment
---------------------

The alternative to rolling updates is *blue-green deployment*. I won't go into the process details in this post. If you are not familiar with it, please read the [Blue-Green Deployment](https://technologyconversations.com/2016/02/08/blue-green-deployment/) article. I'll limit myself to a short comparison of the two processes.

Rolling Updates vs Blue-Green Deployment
----------------------------------------

For smaller deployments, let's say less than ten instances of a service, I prefer *blue-green* instead *rolling updates*. With blue-green deployments, we have the opportunity to test the new release in production. If all the tests passed, we can reconfigure the proxy and make it available to the public. That is not to say that rolling updates cannot be tested. They can. However, testing rolling updates is much more difficult and, even if we do have appropriate tests, there is no guarantee that our users will not experience undesirable results. Since the moment the first iteration of the new release is running and until we detect a problem and execute rollback, a part of the system is running faulty instances that are accessible to our users.

If, on the other hand, we are running many instances, the resource overhead produced by blue-green deployments might be too much. After all, during a, hopefully, short period, we need to double the number of instances (the old release plus the new).

The overhead required to write scripts that would support the blue-green deployment process is too big when compared to rolling updates. In the past, the old Swarm (before Docker 1.12) did not support any of the two. We had to implement them ourselves, so the cost was, more or less, the same. Now that rolling updates are an integral part of Docker Engine, my preference is, more often than not, with rolling updates. The process is baked into the engine. There is no need for custom scripts.

No matter which process you'll choose, one of the important things to note is that releases need to be backward compatible. Each deployment means that during some period both the old and the new release will run in parallel. We do not need to make sure that backward compatibility is maintained for long. Having each release compatible with the previous is often enough. The biggest challenges are, often, databases. You have to make sure that your schema changes are backward compatible with the previous release. As with many other cases, the longer the iteration, the more problems we might have with database schema changes. In most cases, making database changes backward compatible is not a hard thing to accomplish when iterations are short.

Docker Update Implications
--------------------------

The new option to run `docker update` commands means that our deployment process should change. Now we need to create a service only once (the first release). All sequential releases do not have to know anything about the service. All we have to do is update the image and Docker Swarm will take care of the rest. That means that we can greatly simplify our deployment scripts. All there is to do is run a single `docker update --image <IMAGE_NAME_AND_TAG> <SERVICE_NAME>` command.

> Docker already simplified our continuous delivery or deployment flows. With the new Swarm mode introduced in version 1.12, simple become even simpler.

What Now?
---------

That concludes the exploration of zero-downtime deployments to a Swarm cluster. In particular, we explored *rolling updates* and compared it to the *blue-green deployment* process.

Is this everything there is to know to run a Swarm cluster successfully? Not even close! What we explored by now (in this and the previous articles) is only the beginning. There are quite a few other questions waiting to be answered.

The next article will be dedicated to the **setup of a continuous deployment pipeline with Jenkins and Docker Swarm**.

Before you leave, please free your resources by removing the machines we created.

```bash
docker-machine rm -f node-1 node-2 node-3
```

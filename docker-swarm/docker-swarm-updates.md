Zero-Downtime Deployments to Docker Swarm (Tour Around Docker 1.12 Series)
==========================================================================

![Docker Swarm](img/swarm.png)

If this is your first contact with the new Docker Swarm (version 1.12+), please read [Docker Swarm Introduction](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) and [Integrating Proxy With Docker Swarm](https://technologyconversations.com/2016/08/01/integrating-proxy-with-docker-swarm-tour-around-docker-1-12-series/) articles. I will assume that you have (at least) a basic understanding of how to deploy Docker services to a Swarm cluster.

Today we'll explore how to accomplish zero-downtime deployments.

The shorter the iterations we are practicing, the greater the frequency of our deployments. Not so long ago, we were used to work in months long iterations that resulted in only a couple of deployments a year. To be honest, I've been involved with projects that had a single deployment every year. Our fear of uncertainty, inability to abandon "factory model" (waterfall) for producing software, very low (if any) automated test coverage, and a few other factors made the industry think that the better you plan and the longer you develop something, the better the end result. As a result, we were deploying rarely. The only exception were hot-fixes that, to be honest, were very frequent after the big *go-live*. That alone should have told us that there's something wrong with the model.

Never the less, almost no one works like that any more. Iterations are getting shorter and shorter, and the frequency of deployments greater and greater. Some of us to a couple of weeks sprints and deploy at the end of it. Others adopted continuous deployment resulting in a new release to production every time a commit is made. No matter the frequency of your deployment, I bet it is higher then it was a couple of years ago. Not only that but chances are that you are continually challenged with requests to deploy more often than before.

The problem with increased deployment frequency is down-time. If we use the "traditional" approach and fully replace the old release with the new one, downtime is inevitable. The old release has to be stopped and the new needs to be deployed and initialized. That period of down-time might be anything from milliseconds to minutes and, sometimes, even hours. While such a downtime might have been acceptable when we were deploying only a couple of times a year, today might be a reason to get out of business. The higher deployment frequency, the bigger total down-time. Even if the whole process takes only a couple of seconds, when we multiply it with all the deployments we perform throughout a day, week, or a month, the total time our services are unavailable might be considerable.

How do we fight deployment downtime?
------------------------------------

The most commonly used method is to not deploy often. One could write a whole book on the subject of important of short iterations and I'm sure you are already familiar with all the benefits of short sprints. Therefore, we'll skip this option.

For those living closer to the current age, two most commonly used methods to deploy without downtime are [blue-green deployment](https://technologyconversations.com/2016/02/08/blue-green-deployment/) and *rolling updates*.

The idea behind rolling updates is to deploy a new release over one or few of the instances. For example, if we are running ten instances of a services, we might want to upgrade two of those, verify that everything works as expected, then upgrade two more, and so on, until all the instances are running the new release. That way, at least one instance of the service is running at any given moment.

Let's see rolling updates in action before we discuss pros and cons of this process. We'll start by setting up a demo Swarm cluster.

Environment Setup
-----------------

The examples that follow assume that you have [Docker Machine](https://www.docker.com/products/docker-machine) version v0.8+ that includes [Docker Engine](https://www.docker.com/products/docker-engine) v1.12+. The easiest way to get them is through [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

> If you are a Windows user, please run all the examples from *Git Bash* (installed through *Docker Toolbox*).

I won't go into details of the environment setup. It is the same as explained in the [Docker Swarm Introduction](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) article. We'll set up three nodes that will form a Swarm cluster.

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
```

Now that we have the Swarm cluster, we can deploy a service.

![Docker Swarm cluster with three nodes](img/swarm-nodes.png)

```bash
eval $(docker-machine env node-1)

docker network create --driver overlay proxy

docker network create --driver overlay go-demo

docker service create --name go-demo-db \
  --network go-demo \
  mongo

docker service create --name go-demo \
  -e DB=go-demo-db \
  --network go-demo \
  --network proxy \
  vfarcic/go-demo:1.0

docker service create --name proxy \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    --network proxy \
    -e MODE=swarm \
    vfarcic/docker-flow-proxy

docker service ls # Wait until all services are running

curl "$(docker-machine ip node-1):8080/v1/docker-flow-proxy/reconfigure?serviceName=go-demo&servicePath=/demo&port=8080"

curl -i $(docker-machine ip node-1)/demo/hello

docker service scale go-demo=6

docker service ps go-demo

curl -i $(docker-machine ip node-1)/demo/hello

docker service update --image vfarcic/go-demo:1.1 go-demo

docker service ps go-demo

curl -i $(docker-machine ip node-1)/demo/hello

docker service update --image vfarcic/go-demo:1.0 go-demo

docker service ps go-demo

docker service update \
    --update-parallelism 2 \
    --update-delay 30s \
    --image vfarcic/go-demo:1.1 \
    go-demo

docker service ps go-demo

curl -i $(docker-machine ip node-1)/demo/hello
```

* Not easy to test
* Explain BG

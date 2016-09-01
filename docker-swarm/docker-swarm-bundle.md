Distributed Application Bundles (Tour Around Docker 1.12 Series)
================================================================

The new Swarm bundled in Docker 1.12+ is a vast improvement compared to the old orchestration and scheduling. There is no more the need to run a separate set of Swarm containers (it is bundled in Docker Engine), failover strategies are much more reliable, service discovery is baked in, the new networking works like a charm, and so on. The list of features and improvements is quite big. If you haven't had a chance to give it a spin, please read the [Docker Swarm Introduction](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) and [Integrating Proxy With Docker Swarm](https://technologyconversations.com/2016/08/01/integrating-proxy-with-docker-swarm-tour-around-docker-1-12-series/).

In those articles we used commands to run Docker services inside the Swarm cluster. If you are like me, you are probably used to the simplicity Docker Compose provides. Instead trying to memorize commands with all the arguments required for running services, you probably specified everything as Docker Compose files and run containers with a simple `docker-compose up -d` command. After all, that is much more convenient than `docker service create` followed by an endless number of arguments. My brain does not have the capacity to memorize all of them.

When I started "playing" with the new Swarm, my first impression was *this is great*, followed by *I don't want to memorize different arguments for all of my services*. I want my Compose files back into the game.

One of the significant changes is that container management has changed from client (*Docker Compose*) to server side (*Docker Service*). As a result, *Docker Compose* has become obsolete (at least when containers are deployed using *Docker Service*). It will stay as a preferable way to run containers in a single server environment but not much more. So, what should we do with all those *docker-compose.yml* files we created?

The good news is we can use *Distributed Application Bundles* or *dab files* as a substitute for *docker service* command line arguments. The bad news is... Let's keep them for the end and explore the good parts first.

We'll start by creating a demo Swarm cluster composed of Docker machines.

Environment Setup
-----------------

The examples that follow assume that you have [Docker Machine](https://www.docker.com/products/docker-machine) version v0.8+ that includes [Docker Engine](https://www.docker.com/products/docker-engine) v1.12+. The easiest way to get them is through [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

> If you are a Windows user, please run all the examples from *Git Bash* (installed through *Docker Toolbox*).

I won't go into details of the environment setup. It is the same as explained in the [Docker Swarm Introduction](https://technologyconversations.com/2016/07/29/docker-swarm-introduction-tour-around-docker-1-12-series/) article. We'll set up three nodes that they will form a Swarm cluster.

```bash
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

![Docker Swarm cluster with three nodes](../img/swarm/swarm-nodes.png)

Now that we have the Swarm cluster, we can deploy a service using a *dab* file.

Deploying Services Using Distributed Application Bundles (DAB)
--------------------------------------------------------------

Instead creating networks and Docker services by specifying an endless amount of arguments, we'll use a *dab file*. Think of it as a Swarm equivalent of Docker Compose. By Swarm, I mean `docker swarm`, `docker service` and other goodies that came with version 1.12+ (not the old Swarm running as a separate container).

Instead trying to figure out the details of the new format for specifying services, we'll create it from a *docker-compose.yml* file.

Let's start by checking out the code of a demo service.

```bash
git clone https://github.com/vfarcic/go-demo.git

cd go-demo

cat docker-compose.yml
```

The last command output the *Docker Compose* project definition. It is as follows.

```
version: '2'

services:

  app:
    image: vfarcic/go-demo
    ports:
      - 8080

  db:
    image: mongo
```

As you can see, it is a very simple project. It consists of two services. The *app* service is the backend that exposes an API. It uses the second service (*db*) to store and retrieve data. The *app* target exposes port *8080* that will serve as an entry point to its API.

Converting this *Docker Compose* definition into a bundle is a two step process. First, we need to pull the images. The creation of the *bundle* will evaluate them and, together with the contents of the *docker-compose.yml* file, output a *dab* file.

Let's try it out.

```bash
eval $(docker-machine env node-1)

docker-compose pull

docker-compose bundle
```

Now that the process is finished, let's take a look at the result.

```bash
cat godemo.dab
```

The output is as follows.

```
{
  "Services": {
    "app": {
      "Image": "vfarcic/go-demo@sha256:f7436796b1cd6812ba63ea82c6523a5164ae7f8a3c05daa9e4ac4bd78341d709",
      "Networks": [
        "default"
      ],
      "Ports": [
        {
          "Port": 8080,
          "Protocol": "tcp"
        }
      ]
    },
    "db": {
      "Image": "mongo@sha256:e599c71179c2bbe0eab56a7809d4a8d42ddcb625b32a7a665dc35bf5d3b0f7c4",
      "Networks": [
        "default"
      ]
    }
  },
  "Version": "0.1"
}
```

The *godemo.dab* file we just created is pretty straightforward. It consists of two services that match those from the *docker-compose.yml* file. Each of them specifies the image that is defined with the hashes of those we pulled. Images are followed by the default network that will surround the services and the ports that should be opened.

There are, at least, two problems with this output. First of all, there is no need to open any ports. Instead, we should have a reverse proxy that will redirect all request to the service. The new Docker Swarm networking makes integration with a proxy easy and we should exploit that. Please read the [Integrating Proxy With Docker Swarm](https://technologyconversations.com/2016/08/01/integrating-proxy-with-docker-swarm-tour-around-docker-1-12-series/) article for more info on the role of a proxy inside a Swarm cluster.

The second issue is that we did not specify any constraints. Deploying unconstrained services to the cluster can quickly turn into a disaster.

A better, yet still very simple Compose definition can be seen in the [docker-compose-swarm.yml](https://github.com/vfarcic/go-demo/blob/master/docker-compose-swarm.yml) file. Its content is as follows.

```
version: '2'

services:

  app:
    image: vfarcic/go-demo
    mem_limit: 250m

  db:
    image: mongo
    mem_limit: 500m
```

As you can see, we removed the port and added a *mem_limit* constraint. It's, still, a very simple Compose file.

Let's create a new bundle output.

```bash
docker-compose -f docker-compose-swarm.yml bundle
```

The output of the `bundle` command is as follows.

```
WARNING: Unsupported key 'mem_limit' in services.app - ignoring
WARNING: Unsupported key 'mem_limit' in services.db - ignoring
Wrote bundle to godemo.dab
```

Now we are coming to the first bad news. The current *bundle* format is very limiting. We can use it for very simple scenarios. As soon as we specify anything more complex we are faced with a warning. In this case, the memory limit was ignored.

Let's leave this limitation aside (for now) and try to deploy the new bundle.

```bash
docker deploy godemo
```

The output of the `deploy` command is as follows.

```
Loading bundle from godemo.dab
Creating network godemo_default
Creating service godemo_app
Creating service godemo_db
```

Both the network and the service were created. We can confirm that by listing all services.

```bash
docker stack ps godemo
```

You should see that the stack consists of two services, each of them deployed somewhere inside the three nodes cluster, and with the current state set to *running*. If the state is anything else, please wait a few moments until containers are pulled and re-run the command.

However, we are still faced with the missing features. Our memory limit was ignored, and we are yet to create an external network *proxy* and attach the *app* service to it.

We can fix those shortcomings by executing the `service update` command. For example, we can create the *proxy* network manually and add the container to it. We can also use the `service update` command to set the memory limit. However, if we start doing all that, we would, probably, be better of without the bundle in the first place.

What To Do Now?
---------------

Before you go off and completely discard the *bundle*, please note that it is in the experimental stage. That was just the taste of what is to come. We can expect significant improvements and full support for all the features Swarm has to offer.

The question is what to do today. There are several paths we can take. One is to wait for the *bundle* to get out of the experimental stage and (hopefully) support all the features Docker Swarm has to offer. The other approach is to use the [Whaleprint project](https://github.com/mantika/whaleprint). It looks like a mixture of a *dab* file with additional features (e.g. constraints) and the approach *Terraform* uses. It is a very promising project. But, just like the *bundle*, it is still in its infancy.

I hope this article gave you a preview of the direction the new Swarm is taking. The *bundle* is under development, and we can expect it to become a reliable alternative to deploying services to the cluster. Please do not get discouraged by its lack of features but think of it as a blueprint of what is to come.

For now, I recommend you to keep an open eye on the *Distributed Application Bundle* and wait until it matures. In the meantime, operate the Swarm cluster through the commands or give the *Whaleprint* project a try.

The next one will be dedicated to *zero-downtime deployments with Docker Swarm*.

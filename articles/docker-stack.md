# Using Docker Stack And Compose YAML Files To Deploy Swarm Services

**Bells are ringing! Docker v1.13 is out!**

The most common question I receive during my Docker-related talks and workshops is usually related to Swarm and Compose.

*Someone*: How can I use Docker Compose with Docker Swarm?

*Me*: You can't! You can convert your Compose files into a Bundle that does not support all Swarm features. If you want to use Swarm to its fullest, be prepared for `docker service create` commands that contain a never ending list of arguments.

Such an answer was usually followed with disappointment. Docker Compose showed us the advantages of specifying everything in a YAML file as opposed to trying to remember all the arguments we have to pass to `docker` commands. It allowed us to store service definitions in a repository thus providing a reproducible and well-documented process for managing them. Docker Compose replaced bash scripts, and we loved it. Then, Docker v1.12 came along and put a difficult choice in front of us. Should we adopt Swarm and discard Compose? Since summer 2016, Swarm and Compose were not in love anymore. It was a painful divorce.

But, after almost half a year of separation, they are back together, and we can witness their second honeymoon. Kind of... We do not need Docker Compose binary for Swarm services, but we can use its YAML files.

Docker Engine v1.13 introduced support for Compose YAML files within the `stack` command. At the same time, Docker Compose v1.10 introduced a new version 3 of its format. Together, they allow us to manage our Swarm services using already familiar Docker Compose YAML format.

I will assume you are already familiar with Docker Compose and won't go into details of everything we can do with it. Instead, we'll go through an example of creating a few Swarm services.

We'll explore how to create [Docker Flow Proxy](http://proxy.dockerflow.com/) service through *Docker Compose* files and the `docker stack deploy` command.

## Requirements

The examples that follow assume that you are using Docker v1.13+, Docker Compose v1.10+, and Docker Machine v0.9+.

> If you are a Windows user, please run all the examples from *Git Bash* (installed through *Docker Toolbox*). Also, make sure that your Git client is configured to check out the code *AS-IS*. Otherwise, Windows might change carriage returns to the Windows format.

## Swarm Cluster Setup

To setup an example Swarm cluster using Docker Machine, please run the commands that follow.

> Feel free to skip this section if you already have a working Swarm cluster.

```bash
curl -o swarm-cluster.sh \
    https://raw.githubusercontent.com/\
vfarcic/docker-flow-proxy/master/scripts/swarm-cluster.sh

chmod +x swarm-cluster.sh

./swarm-cluster.sh

docker-machine ssh node-1
```

Now we're ready to deploy the `docker-flow-proxy` service.

## Creating Swarm Services Through Docker Stack Commands

We'll start by creating a network.

```bash
docker network create --driver overlay proxy
```

The *proxy* network will be dedicated to the proxy container and services that will be attached to it.

We'll use [docker-compose-stack.yml](https://github.com/vfarcic/docker-flow-proxy/blob/master/docker-compose-stack.yml) from the [vfarcic/docker-flow-proxy](https://github.com/vfarcic/docker-flow-proxy) repository to create `docker-flow-proxy` and `docker-flow-swarm-listener` services.

The content of the `docker-compose-stack.yml` file is as follows.

```
version: "3"

services:

  proxy:
    image: vfarcic/docker-flow-proxy
    ports:
      - 80:80
      - 443:443
    networks:
      - proxy
    environment:
      - LISTENER_ADDRESS=swarm-listener
      - MODE=swarm
    deploy:
      replicas: 2

  swarm-listener:
    image: vfarcic/docker-flow-swarm-listener
    networks:
      - proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DF_NOTIFY_CREATE_SERVICE_URL=http://proxy:8080/v1/docker-flow-proxy/reconfigure
      - DF_NOTIFY_REMOVE_SERVICE_URL=http://proxy:8080/v1/docker-flow-proxy/remove
    deploy:
      placement:
        constraints: [node.role == manager]

networks:
  proxy:
    external: true
```

The format is written in version `3` (mandatory for `docker stack deploy`).

It contains two services; `proxy` and `swarm-listener`. Since this article is not meant to teach you how to use the proxy, I won't go into the meaning of each argument.

When compared with previous Compose versions, most of the new arguments are defined within `deploy`. You can think of that section as a placeholder for Swarm-specific arguments. In this case, we are specifying that the `proxy` service should have two replicas while the `swarm-listener` service should be constrained to manager roles. Everything else defined for those two services is using the same format as in earlier Compose versions.

At the bottom of the YAML file is the list of networks which are referenced within `services`. If a service does not specify any, the `default` network will be created automatically. In this case, we opted for manual creation of a network since services from other stacks should be able to communicate with the proxy. Therefore, we created a network manually and defined it as `external` in the YAML file.

Let's create the stack based on the YAML file we explored.

```bash
curl -o docker-compose-stack.yml \
    https://raw.githubusercontent.com/\
vfarcic/docker-flow-proxy/master/docker-compose-stack.yml

docker stack deploy -c docker-compose-stack.yml proxy
```

The first command downloaded the Compose file [docker-compose-stack.yml](https://github.com/vfarcic/docker-flow-proxy/blob/master/docker-compose-stack.yml) from the [vfarcic/docker-flow-proxy](https://github.com/vfarcic/docker-flow-proxy) repository. The second command created the services that form the stack.

The tasks of the stack can be seen through the `stack ps` command.

```bash
docker stack ps proxy
```

The output is as follows (IDs are removed for brevity).

```
NAME                   IMAGE                                     NODE   DESIRED STATE CURRENT STATE         ERROR  PORTS
proxy_proxy.1          vfarcic/docker-flow-proxy:latest          node-2 Running       Running 2 minutes ago
proxy_swarm-listener.1 vfarcic/docker-flow-swarm-listener:latest node-1 Running       Running 2 minutes ago
proxy_proxy.2          vfarcic/docker-flow-proxy:latest          node-3 Running       Running 2 minutes ago
```

We are running two replicas of the `proxy` (for high-availability in the case of a failure) and one of the `swarm-listener`.

## Deploying More Stacks

Let's deploy another stack.

This time we'll use Docker stack defined in the Compose file [docker-compose-stack.yml](https://github.com/vfarcic/go-demo/blob/master/docker-compose-stack.yml) located in the [vfarcic/go-demo](https://github.com/vfarcic/go-demo/) repository. It is as follows.

```
version: '3'

services:

  main:
    image: vfarcic/go-demo
    environment:
      - DB=db
    networks:
      - proxy
      - default
    deploy:
      replicas: 3
      labels:
        - com.df.notify=true
        - com.df.distribute=true
        - com.df.servicePath=/demo
        - com.df.port=8080

  db:
    image: mongo
    networks:
      - default

networks:
  default:
    external: false
  proxy:
    external: true
```

The stack defines two services (`main` and `db`). They will communicate with each other through the `default` network that will be created automatically by the stack (no need for `docker network create` command). Since the `main` service is an API, it should be accessible through the proxy, so we're attaching `proxy` network as well.

The important thing to note is that we used the `deploy` section to define Swarm-specific arguments. In this case, the `main` service defines that there should be three replicas and a few labels. As with the previous stack, we won't go into details of each service. If you'd like to go into more depth of the labels used with the `main` service, please visit the [Running Docker Flow Proxy In Swarm Mode With Automatic Reconfiguration](http://proxy.dockerflow.com/swarm-mode-auto/) tutorial.

Let's deploy the stack.

```bash
curl -o docker-compose-go-demo.yml \
    https://raw.githubusercontent.com/\
vfarcic/go-demo/master/docker-compose-stack.yml

docker stack deploy \
    -c docker-compose-go-demo.yml go-demo

docker stack ps go-demo
```

We downloaded the stack definition, executed `stack deploy` command that created the services and run the `stack ps` command that lists the tasks that belong to the `go-demo` stack. The output is as follows (IDs are removed for brevity).

```
NAME           IMAGE                  NODE    DESIRED STATE CURRENT STATE          ERROR PORTS
go-demo_main.1 vfarcic/go-demo:latest node-2 Running        Running 7 seconds ago
...
go-demo_db.1   mongo:latest           node-2 Running        Running 21 seconds ago
go-demo_main.2 vfarcic/go-demo:latest node-2 Running        Running 19 seconds ago
...
go-demo_main.3 vfarcic/go-demo:latest node-2 Running        Running 20 seconds ago
...
```

Since Mongo database is much bigger than the `main` service, it takes more time to pull it, resulting in a few failures. The `go-demo` service is designed to fail if it cannot connect to its database. Once the `db` service is running, the `main` service should stop failing, and we'll see three replicas with the current state `Running`.

After a few moments, the `swarm-listener` service will detect the `main` service from the `go-demo` stack and send the `proxy` a request to reconfigure itself. We can see the result by sending an HTTP request to the proxy.

```bash
curl -i "localhost/demo/hello"
```

The output is as follows.

```
HTTP/1.1 200 OK
Date: Thu, 19 Jan 2017 23:57:05 GMT
Content-Length: 14
Content-Type: text/plain; charset=utf-8

hello, world!
```

The proxy was reconfigured and forwards all requests with the base path `/demo` to the `main` service from the `go-demo` stack.

For more advanced usage of the proxy, please see the examples from [Running Docker Flow Proxy In Swarm Mode With Automatic Reconfiguration](http://proxy.dockerflow.com/swarm-mode-auto/) tutorial or consult the [configuration](http://proxy.dockerflow.com/config/) and [usage](http://proxy.dockerflow.com/usage/) documentation.

## To Stack Or Not To Stack

Docker stack is a great addition to the Swarm Mode. We do not have to deal with `docker service create` commands that tend to have a never ending list of arguments. With services specified in Compose YAML files, we can replace those long commands with a simple `docker stack deploy`. If those YAML files are stored in code repositories, we can apply the same practices to service deployments as to any other area of software engineering. We can track changes, do code reviews, share with others, and so on.

The addition of the Docker `stack` command and its ability to use Compose files is a very welcome addition to the Docker ecosystem.

## Cleanup

Please remove Docker Machine VMs we created. You might need those resources for some other tasks.

```bash
exit

docker-machine rm -f node-1 node-2 node-3
```

# The DevOps 2.1 Toolkit: Docker Swarm

<a href="https://www.amazon.com/dp/1542468914"><img src="https://technologyconversations.files.wordpress.com/2016/09/cover-ebook-small.png?w=287" alt="The DevOps 2.1 Toolkit: Docker Swarm" width="287" height="300" class="alignright size-medium wp-image-3383" /></a>If you liked this article, you might be interested in **[The DevOps 2.1 Toolkit: Docker Swarm](https://www.amazon.com/dp/1542468914)** book. Unlike the previous title in the series (**[The DevOps 2.0 Toolkit: Automating the Continuous Deployment Pipeline with Containerized Microservices](http://www.amazon.com/dp/B01BJ4V66M)**) that provided a general overlook of some of the latest DevOps practices and tools, this book is **dedicated entirely to Docker Swarm** and the processes and tools we might need to **build, test, deploy, and monitor services** running inside a cluster.

You can get a copy from [Amazon.com](https://www.amazon.com/dp/1542468914) (and the other worldwide sites) or [LeanPub](https://leanpub.com/the-devops-2-1-toolkit).  It is also available as [The DevOps Toolkit Series](https://leanpub.com/b/thedevopstoolkitseries) bundle.

Give the book a try and let me know what you think.

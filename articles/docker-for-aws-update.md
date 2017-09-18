# Extending The Capacity Of A Docker For AWS Cluster

One of the big benefits [Docker For AWS](https://store.docker.com/editions/community/docker-ce-aws) provides is the ability to perform rolling updates to infrastructure services. Almost any aspect of the cluster can be changed without downtime. Moreover, most of the infrastructure is immutable. For example, if we choose to upgrade Docker Server running on the nodes, *Docker For AWS* will destroy the servers and put new ones based on a different image.

There are many other advantages behind *Docker For AWS*. However, the objective of this article is to show how we can extend the capacity of a cluster and to explain what's happening in background.

I'll assume that you already have a *Docker For AWS* cluster. If you don't, please follow the instructions from [Docker for AWS](https://youtu.be/uWTL8gwzZz4) video.

We'll use CloudFormation UI to update the cluster. I think that's a bad practice and you should use AWS CLI to accomplish the same result. However, since it is often easier to understand the process through UIs, we'll stick with it (for now).

## Extending The Capacity Through CloudFormation UI

Among other resources, *Docker For AWS* template created two auto-scaling groups. One is used for masters and the other for workers. Those security groups have multiple purposes.

If we choose to update the stack to, for example, change the size of the nodes or upgrade Docker server to a newer version, the template will temporarily increase the number of nodes by one and shut down one of the old ones. The replicas that were running on the old server will be moved to the new one. Once the new server is created, it will move to the next, and the next after that, all the way until all the nodes are replaced. The process is very similar to rolling updates we performed by Swarm when updating services. The same process is done whenever we decide to update any aspect of the *Docker For AWS* stack.

Similarly, if one of the nodes fail health checks, the stemplate will increase auto-scaling group by one so that a new node is created in its place and, once everything goes back to "normal" update the ASG back to its initial value.

In all those cases, not only that new nodes will be created through auto-scaling groups, but they will also join the cluster as a manager or a worker depending on the type of the server that is being replaced.

We will explore failure recovery in the chapter dedicated to self-healing applied to infrastructure. For now, we'll limit the scope to an example how to update the CloudFormation stack that created our cluster. We even have a a perfect use-case. Our ElasticSearch service needs a worker node, and it needs it to be bigger than those we use as managers. Let's create it.

We'll start by opening CloudFormation home screen.

```bash
open "https://us-east-2.console.aws.amazon.com/cloudformation/home"
```

Please select the stack. Click the *Actions* drop-down list and select the *Update Stack* item. Click the *Next* button

You will be presented with the same initial screen you saw while we were creating the *Docker For AWS* stack. The only difference is that the values are now populated with choices we made previously.

We can change anything we want. Not only that the changes will be applied accordingly, but the process will use rolling updates to avoid downtime. Whether you will have downtime or not depends on the capabilities of your services. If needed, the process will change one node at the time. If you're running multiple replicas of a service, the worst case scenario is that you will experience degraded performance for a short period. However, services that are not scalable like, for example, Prometheus, will experience downtime.

When a node is destroyed, Swarm will move it to a newly created server. If the state of that service is on a network drive like EFS, it will continue working as if nothing happened. However, we must count the time between the service failure due to the destruction of the node and until it is up and running again. In most cases that should be only a couple of seconds. No matter how short the downtime is, it is still a period during which our non-scalable services are not operational. Be it as it may, not all services are scalable, and the process is the best we can do. If there is downtime, let it be as short as possible.

In this case, we won't make an update that will force the system to recreate nodes. Instead, we'll only add a new worker node.

Please scroll to the *Number of Swarm worker nodes?* field and change the value from *0* to *1*.

Since we defined that ElasticSearch should reserve 3GB of memory, we should change worker instance type. Our managers are using *t2.small* that comes with 2GB. The smallest instance that fulfills our requirements is *t2.medium* that comes 4GB of allocated memory.

Please change the value of the *Agent worker instance type?* drop-down list to *t2.medium*.

We will not change any other aspect of the cluster, so all that's left is to click the *Next* button twice, and select the *I acknowledge that AWS CloudFormation might create IAM resources.* checkbox.

After a few moments, the *Preview your changes* section of the screen will be populated with the list of changes that will be applied to the cluster. Since this is a simple and non-destructive update, only a few resources related to auto-scaling groups will be updated.

![Figure 13-4: Preview your changes screen from the Docker For AWS template](images/ch13/docker-for-aws-preview-changes.png)

Click the *Update* button and relax. It'll take a minute or two until the new server is created and it joins the cluster.

While waiting, we should explore a different method to accomplish the same result.

Please open the *Auto-Scaling Groups Details* screen.

```bash
open "https://console.aws.amazon.com/ec2/autoscaling/home?#AutoScalingGroups:view=details"
```

You'll be presented with the *Welcome to Auto Scaling* screen. Click the *Auto Scaling Groups: 2* link.

Select the item with the name starting with *[THE_NAME_OF_THE_STACK]-NodeAsg*. If, for example, your stack is called *my-stack*, the security group name should start with *my-stack-NodeAsg*. Click the *Actions* drop-down list, and select the *Edit* item. We're looking for the *Desired* field located in the *details* tab. It can be changed to any value, and the number of workers would increase (or decrease) accordingly. We could do the same with the auto-scaling group associated with manager nodes. Do not make any change. We're almost finished with this chapter, and we already have more than enough nodes for the services we're running.

The knowledge that we can change the number of manager or worker nodes by changing the values in auto-scaling groups is essential. Later on, we'll combine that with AWS API and Prometheus alerts to automate the process when certain conditions are met.

The new worker node should be up-and-running by now unless you are a very fast reader. If that's the case, go and grab a coffee.

Let's go back to the cluster and list the available nodes.

```bash
ssh -i [PATH_TO_SSH_KEY] docker@$CLUSTER_IP

docker node ls
```

Please replace `[PATH_TO_SSH_KEY]` with the path to your key (e.g. `workshop.pem`).

The output is as follows (IDs are removed for brevity).

```
HOSTNAME                                    STATUS AVAILABILITY MANAGER STATUS
ip-172-31-2-119.us-east-2.compute.internal  Ready  Active
ip-172-31-32-225.us-east-2.compute.internal Ready  Active       Leader
ip-172-31-10-207.us-east-2.compute.internal Ready  Active       Reachable
ip-172-31-30-18.us-east-2.compute.internal  Ready  Active       Reachable
```

In your case, the list of the nodes might be different. My cluster had only three managers before the update and now a new node is added to the mix. Since its a worker, manager status is empty.

Your first thought might be that it is a simple process. After all, all that AWS did was create a new VM. That is right from AWS point of view, but there are a few other things that happened in the background.

During VM initialization, it contacted Dynamo DB to find out the address of the primary manager and the access token. Equipped with that info, it sent a request to that manager to join the cluster. From there on, the new node (in this case worked) is available as part of the Swarm cluster.
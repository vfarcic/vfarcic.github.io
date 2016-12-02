# Choosing The Right Tools To Create And Manage Docker Swarm Clusters In AWS

Swarm Mode is taking Docker scheduling by the storm. You tried it in your lab or by setting up a few VMs locally and joining them into a Swarm cluster. Now its time to move it to the next level and create a cluster in AWS. Which tools should you use to do that? How should you set up your AWS Swarm cluster?

If you are like me, you already discarded the option to create servers manually through [AWS Console](TODO), enter each with SSH, and run commands that will install Docker Engine and join the node with others. You know better than that and want a reliable and automated process that will create and maintain the cluster.

Among a myriad of options we can choose from to create a Docker Swarm cluster in AWS, three stick from the crowd. We can use *Docker Machine* with *AWS CLI*, *Docker for AWS* as *CloudFormation* template, and *Packer* with *Terraform*. That is, by no means, the final list of the tools we can use. The time is limited and I promised to myself that this article will be shorter than *War and Peace* so I had to draw the line somewhere. Those three combinations are, in my opinion, the best candidates as your tools of choice. Even if you do choose something else, this article, hopefully, gave you an insight into the direction you might want to take.

Most likely you won't use all three combinations so the million dollar question is which one should it be?

Only you can answer that question. Now you have the practical experience that should be combined with the knowledge of what you want to accomplish. Each use case is different, and no combination would be the best fit for everyone.

Never the less, I will provide a brief overview and some of the use-cases that might be a good fit for each combination.

### To Docker Machine Or Not To Docker Machine?

Docker Machine is the weakest solution we explored. It is based on ad-hoc commands and provides little more than a way to create an EC2 instance and install Docker Engine. It uses *Ubuntu 15.10* as the base AMI. Not only that it is old but is a temporary release. If we choose to use Ubuntu, the correct choice is 16.04 LTS (Long Term Support).

Moreover, Docker Machine still does not support Swarm Mode so we need to manually open the port before executing `docker swarm init` and `docker swarm join` commands. To do that, we need to combine Docker Machine with AWS Console, AWS CLI, or CloudFormation.

If Docker Machine would, at least, provide the minimum setup for Swarm Mode (as it did with the old Standalone Swarm), it could be a good choice for a small cluster.

As it is now, the only true benefit Docker Machine provides when working with a Swarm cluster in AWS is Docker Engine installation on a remote node and the ability to use the `docker-machine env` command to make our local Docker client seamlessly communicate with the remote cluster. Docker Engine installation is simple so that alone is not enough. On the other hand, `docker-machine env` command should not be used in a production environment. Both benefits are too week.

Many of the current problems with Docker Machine can be fixed with some extra arguments (e.g. `--amazonec2-ami`) and in combination with other tools. However, that only diminishes the primary benefit behind Docker Machine. It was supposed to be simple and work out of the box. That was partly true before Docker 1.12. Now, at least in AWS, it is lagging behind.

Does that mean we should discard Docker Machine when working with AWS? Not always. It is still useful when we want to create an ad-hoc cluster for demo purposes or maybe experiment with some new features. Also, if you don't want to spend time learning other tools and just want something you're familiar with, Docker Machine might be the right choice. I doubt that's your case. The fact that you are reading this article tells me that you do want to explore better ways of managing a cluster.

The final recommendation is to keep Docker Machine as the tool of choice when you want to simulate a Swarm cluster locally. There are better choices for AWS.

### To Docker For AWS Or Not To Docker For AWS?

[Docker for AWS](https://beta.docker.com/docs/aws/) is opposite from Docker Machine. It is a complete solution for your Swarm cluster. While Docker Machine does not do much more than to create EC2 instances and install Docker Engine, *Docker for AWS* sets up many of the things we might have a hard time setting up ourselves. Autoscaling groups, VPCs, subnets, and ELB are only a few of the things we get with it.

There is almost nothing we need to do to create and manage a Swarm cluster with *Docker for AWS*. Choose how many managers and how many workers you need, click the *Create Stack* button, and wait a few minutes. That's all there is to it.

There's even more. *Docker for AWS* comes with a new OS specifically designed to run containers.

So much praise for *Docker for AWS* inevitably means that it's the best choice? Not necessarily. It depends on your needs and the use case. If what *Docker for AWS* offers is what you need, the choice is simple. Go for it. On the other hand, if you'd like to change some of its aspects or add things that are not included, you might have a hard time. It is not easy to modify or extend it.

As an example, *Docker for AWS* will output all the logs to [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/). That's great as long as CloudWatch is where you want to have your logs. On the other hand, if you prefer the ELK stack, DataDog, or any other logging solution, you will discover that changing the default setup is not that trivial.

Let's see another example. What if you'd like to add persistent storage. You might mount an EFS volume on all servers, but that's not an optimum solution. You might want to experiment with RexRay or Flocker. If that's the case, you will discover that, again, it's not that simple to extend the system. You'd probably end up modifying the CloudFormation template and risk not being able to upgrade to a new *Docker for AWS* version.

Did I mention that *Docker for AWS* is still in beta? At the time of this writing, it is, more or less, stable, but it still has its problems. Otherwise, it would not be beta.

All this negativity does not mean that you should give up on *Docker for AWS*. It is a great solution that will become only better with time.

The final recommendation is to use *Docker for AWS* if it provides (almost) everything you need or if you do not want to start working on your solution from scratch. The biggest show stopper would be if you already have a set of requirements that need to be fulfilled no matter the tool you'll use.

If you decide to host your cluster in AWS and you do not want to spend time learning how all its services work, read no more. *Docker for AWS* is what you need. It saves you from learning about security groups, VPCs, elastic IPs, and a myriad of other services that you might, or might not need.

### To Terraform or Not To Terraform?

Terraform, when combined with Packer, is an excellent choice. HashiCorp managed to make yet another tool that changes the way we configure and provision servers. Such a praise begs the question whether we should use *Docker for AWS* or *Terraform* with *Packer*?

Unlike Docker Machine that was easy to reject for most cases, the dilemma whether to use *Terraform* or *Docker for AWS* is harder to resolve. It might take you a while to reach with Terraform the state where the cluster has everything you need. It is not an out-of-the-box solution. You have to write the configs yourself. If you are experienced with AWS, such a feat should not cause much trouble. On the other hand, if AWS is not your strongest virtue, it might take you quite a while to define everything.

Still, I would discard learning AWS as the reason to choose one over the other. Even if you go with an out-of-the-box solution like *Docker for AWS*, you should still know AWS. Otherwise, you're running a risk of failing to react to infrastructure problems when they come. Don't think that anything can save you from understanding AWS intricacies. The question is only whether you'll learn the details before or after you create your cluster.

The final recommendation is to use *Terraform* with *Packer* if you want to have a control of all the pieces that constitute your cluster or if you already have a set of rules that need to be followed. Be ready to spend some time tuning the configs until you reach the optimum setup. Unlike with *Docker for AWS*, you will not have a definition of fully functioning cluster in an hour. If that's what you want, choose *Docker for AWS*. On the other hand, when you do configure Terraform to do everything you need, the result will be beautiful.

### The Final Verdict

What should we use? How do we make a decision? Fully functioning cluster made by people who know what they're doing (*Docker for AWS*) versus fully operational cluster made by you (*Terraform*). Beta (*Docker for AWS*) versus whatever you'd like to label your own solution (*Terraform*). More things than you need (*Docker for AWS*) versus just the resources you want (*Terraform*).

Making the choice is hard. *Docker for AWS* is still too young and might be an immature solution. Docker folks will continue developing it and it will almost certainly become much better in not so distant future. *Terraform* gives you freedom at a price.

Personally, I will closely watch the improvements in *Docker for AWS* and reserve the right to make the verdict later. Until that time, I am slightly more inclined towards Terraform. I like building things. It's a very narrow victory that should be revisited soon.

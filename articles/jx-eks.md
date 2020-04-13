Source: https://web.archive.org/web/20190416142629/https://aws.amazon.com/blogs/opensource/continuous-delivery-eks-jenkins-x/

Amazon Elastic Container Service for Kubernetes (Amazon EKS) provides a container orchestration platform for building and deploying modern cloud applications using Kubernetes. Jenkins X is built on Kubernetes to provide automated CI/CD for such applications. Together, Amazon EKS and Jenkins X provide a continuous delivery platform that allows developers to focus on their applications. This blog post by Henryk Konsek explains how to automate your CI/CD needs following GitOps principles, allowing you to be more productive.

—Arun

We all want to be high-performing teams, following the best practices outlined by the Accelerate book and the State of DevOps report. This includes practices such as using Continuous Integration and Continuous Delivery, using trunk-based development, and using the cloud well.

These days, using the cloud well means using a container management platform such as Kubernetes, which automates the running and load balancing of containers on any cloud infrastructure. It also means scaling the nodes and containers elastically, all of which can be managed by your cloud provider.

Amazon EKS is AWS’ managed Kubernetes offering, which enables you to focus on building applications, while letting AWS handle managing Kubernetes and the underlying cloud infrastructure.

Jenkins X builds on top of Kubernetes to provide automated Continuous Integration and Continuous Delivery, making it easy for teams to move to Kubernetes and automate their CI/CD using best practices outlined by the Accelerate book.

This post demonstrates how to leverage the power of AWS services such as Amazon Elastic Compute Cloud (Amazon EC2), Amazon Route 53, Amazon Elastic Container Registry (Amazon ECR), and Amazon EKS to provide a solid foundation for Continuous Delivery pipelines based on the Jenkins X project.

What You Will Create
The diagram below demonstrates what we would like to build. Our goal is to have a EKS cluster deployed exposed to the outside world using Elastic Load Balancing (ELB) and Route 53 domain mapping. Inside our cluster, we want to have a Jenkins server (reacting on the Git changes) which can start Kubernetes-based builds which end up as Docker images pushed into Elastic Container Registry (ECR). Finally, we want Jenkins to deploy our application image into an EKS cluster and expose it via ingress to the outside world. All the persistence needs of our infrastructure and applications will be handled by Amazon services, for example using Amazon Elastic Block Store (Amazon EBS), which will be used by ECR or Kubernetes persistent volumes.

diagram: what we will create

Configuring the Project Domain in Route 53
Let’s start our Continuous Delivery journey by configuring a domain that will be used by our customers to access our application, and by our devOps team to access our Jenkins server.

Keep in mind that, technically, we could use the nip.io service instead of a real domain, as Jenkins X provides out of the box nip.io support. If you want to go the nip.io route, just hit enter when it suggests using the 1.2.3.4.nip.io domain during the install (where 1.2.3.4 would be replaced by your IP address of the Network Load Balancer setup for you by the installer). Then the foo.bar.1.2.3.4.nip DNS name would resolve to your IP address, 1.2.3.4 giving you wildcard DNS without having to touch DNS or Route 53.

However, in this post we would like to demonstrate how to properly add a real domain with Route 53 and instruct Jenkins X to use it.

In order to add a domain to AWS, choose Route 53 Service from the AWS console and click the blue Create Hosted Zone button. In the dialog box, type the name of your domain and click the blue Create button. In the example below we use the konsek.cloud domain.

create hosted zone dialog

After creating the hosted zone, you should see it in your Route 53 console.

Route 53 console showing hosted zone

If you purchased your domain outside of AWS, you should configure your domain to delegate to the AWS name servers defined in NS record of your hosted zone as shown here:

delegate to the AWS name servers defined in NS record of your hosted zone

The DNS changes may take a few minutes to propagate, but from this point your domain is ready to be used by Jenkins X.

Installing the Jenkins X cli client
The Jenkins X cli client is called jx. It is used to manage the Jenkins X infrastructure and your Continuous Delivery pipelines. Detailed instructions on how to install jx, can be found here.

After successful installation of jx client you should now be able to display the jx client version by executing the following command:

$ jx version
jx                 1.3.366
Creating the EKS Kubernetes Cluster
Now that we have jx client installed, we’re ready to create the EKS cluster which will be used to run the Jenkins X server, CI builds, and the application itself. Jenkins X makes this task trivial by leveraging the power of the eksctl project. Don’t worry if you don’t have eksctl, kubectl (Kubernetes client), Helm (package manager for Kubernetes), or the Heptio Authenticator for AWS installed: jx will detect anything that’s missing and can automatically download and install it for you.

Before you start working with EKS, ensure that you have your AWS credentials set up. The Jenkins X client is smart enough to retrieve AWS credentials from standard AWS cli locations, including environment variables or ~/.aws config files. For the purposes of this example, we can just use environment variables:

export AWS_ACCESS_KEY_ID=myAccessId
export AWS_SECRET_ACCESS_KEY=mySecret
Let’s create the new Kubernetes cluster with EKS:

jx create cluster eks --cluster-name=konsek-cloud --skip-installation=true
Execution of this command can take a while as eksctl waits until the EKS cluster is fully initialized. However, as soon as the command finishes, you will be able to see your cluster using this jx command:

$ jx get eks
NAME
konsek-cloud
Or by displaying it in the AWS web console:



You should also be able to see the EC2 worker nodes associated with your cluster.

EC2 worker nodes associated with a cluster

Installing the Jenkins X platform Into Your Kubernetes Cluster
Now that we have the EKS cluster up and running, we can install the Jenkins X platform into it. The Jenkins X platform consists of the Jenkins server itself, a Nexus server, configuration stored in Kubernetes, and a couple of other components, all packaged into single Helm chart. The Jenkins X platform can be installed using the following command:

jx install --provider=eks --domain=konsek.cloud --default-environment-prefix=konsek-cloud
During the installation process, jx may ask you to confirm some settings, mostly related to Git configuration. Jenkins X follows GitOps principles and uses git for storing environment deployment definitions. The same git configuration is also used by the Jenkins server deployed into Kubernetes to access the sources of your applications. By default, jx assumes that you’re using GitHub, but other git providers (including BitBucket and GitLab) are also supported.

jx requires you to define an API token, which it will use to access Git repositories on your behalf.

define GitHub API token

Just follow the instructions from jx to generate the API token (by clicking the link generated for you by jx). In the GitHub dialog window, specify the unique name of the token as shown below:

New personal access token dialog

Then click the green Generate Token button, copy the value of the token, and paste it to the jx cli input.

During the installation process you might notice that jx automatically opens the Jenkins server running on http://jenkins.jx.your.domain.com address (http://jenkins.jx.konsek.cloud, in our example), logs into it, and saves some settings. This is just jx using headless browser automation to generate Jenkins API token on your behalf. This token will be later used internally by Jenkins X to automatically create Jenkins jobs on your behalf.

Jenkins login

After a few minutes, the jx install command should finish creating the Jenkins X platform. It should also tell you the URL that you can use to access your Jenkins server, and a random admin password for this server.

creating GitHub webhook screen

In our example the URL is http://jenkins.jx.konsek.cloud and the random admin password generated by jx is toothglory. Now equipped with Jenkins credentials, we can log into our Jenkins server and see that Jenkins has successfully provisioned two environments for us: a staging environment and a production environment.

Jenkins console-staging and production environments created

You can also navigate to GitHub and see that Jenkins X provisioned the projects representing the environments’ Helm chart definitions as just built by Jenkins.

GitHub projects provisioned by Jenkins

Now let’s jump back to the configuration of our domain in Route 53. As you can see, Jenkins X created the new *.konsek.cloud DNS CNAME entry for the AWS Elastic Load Balancer. This ELB in turns points to a Kubernetes Nginx Ingress controller. This allows us to access the http://jenkins.jx.konsek.cloud address via the Internet.

create record set

Creating a New Spring Boot Project
Now that we have a Kubernetes cluster running and Jenkins X installed into it, we can create our very first project and try to deploy it into cluster using our CD pipeline. Jenkins X supports many different project types, and comes with a set of handy quickstarts that you can use to bootstrap new applications easily. In this example, we will create a generic Spring Boot REST application from a Spring Boot initializer using the following jx command:

jx create spring -d web -d actuator
During the process of creating a new application, jx will ask you questions such as project name, the language you want to use for the project, Maven coordinates, and so forth.

jx questions to answer screen

Here, Jenkins X is informing us that our application has been created on our local laptop, pushed into the remote GitHub repository, and added into the Jenkins X CD pipeline. Let’s check that the latter is true! Execute the jx get pipe command and see for yourself:

jx get pipe command

The command above displays the list of pipelines registered in Jenkins X. As you can see, we have dedicated pipelines for changes that should be applied to staging and production environments. There is also a dedicated pipeline for building our new Spring Boot application, which happens to be currently still building. You can also use the Jenkins UI to see the pipeline progress.

use the Jenkins UI to see the pipeline progress

After the application pipeline is completed, you can see your application in the listing provided by jx client. In order to see this listing, execute the jx get app command.

jx get app command

Jenkins X has now built and deployed your application into the staging environment. Let’s use the URL of the application provided by the jx command output (http://eks-demo.jx-staging.konsek.cloud in our case) to see if it is up and running:

Spring Whitelabel error message

If you can see the Spring Whitelabel error message, your application has been successfully deployed into your EKS cluster and exposed via the Ingress controller.

Now let’s try to change something in our application, for example appending some text into our project readme file.

example appending some text into our project readme file

Give Jenkins X some time to rebuild and redeploy the project, then take another look at the output of jx get app:

output of jx get app at version 2

As you can see, the version of the application changed from 0.0.1 to 0.0.2.

Now let’s take a look at what happens when you import a new project into Jenkins X, or trigger a version control change.

GitOps on AWS
Jenkins X applies GitOps principles to application deployments and promotion through your environments (Dev -> Staging -> Production). Briefly, the GitOps approach to deployments means that you store the configuration of your environment in a version control system, for example in a YAML file which describes what should be deployed into given environment. This approach follows the general Kubernetes declarative philosophy, that you should specify the expected state of the environment you want to maintain, leaving it up to Kubernetes and other tooling to achieve that state in a reconciliation loop.

Whenever you change your application, Jenkins X detects this and attempts to build the application. The build usually starts with running tests and all the necessary pre-checks against the project, followed by the actual Docker image build step, then finally pushing the versioned Docker image into the ECR registry. Jenkins X the creates a pull request against the git project holding the configuration of the environment to which image should be deployed. This pull request contains a proposal to use the more recent Docker image version. If Jenkins X can successfully deploy the requested changes, the pull request is merged into the master branch. Otherwise, Jenkins X creates deployment job logs that can be used to see what prevented deployment.

Pull Requests and Preview Environments
Following the best practices of high-performing teams outlined in the Accelerate book, we recommend trunk-based development (releasing from the master branch), keeping the release branch clean and working at all times. We therefore recommend that you develop code in small batches, and submit them frequently via short-lived pull requests.

When you create a pull request, Jenkins X automatically triggers a pipeline which validates that your code compiles and the tests run. It also generates a dynamic Preview Environment for each pull request, deploys the proposed code there, and comments on the pull request with a link of where you can try out your application:

Preview Environment for pull request

This is particularly useful If you are developing a web application, so your team can review the changes quickly to see if changes to layout, CSS, or behavior match the requirements.

Developing on Jenkins X
Though the example we showed above uses Spring Boot, Jenkins X supports many programming languages and build tools. An alternate way to get started is via a quickstart:

jx create quickstart
This command returns a list of sample applications in different programming languages and runtimes.

If you already have some source code on your laptop that you want to import into Jenkins X, you can import it via:

jx import
Once you have installed Jenkins X and created or imported code for all your applications, you work with your source code in the usual git manner via git commits and pull requests, while Jenkins X automates the rest. Your development team won’t need to worry about details like Kubernetes, Docker images, Jenkins pipelines or GitOps – you can focus on your application code and spend most of your time in your IDE of choice!
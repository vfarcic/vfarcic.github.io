# The Present


<!-- .slide: data-background="img/idp-present-01.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-02.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-03.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-04.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-05.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-06.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-07.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-08.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-09.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/landscape.png" data-background-size="contain" -->

Note:

Kubernetes eventually built the biggest ecosystem ever seen and we could choose among an infinite number of solutions for any problem we could face. Most of that was enabled through CRDs and controllers. Most of use started by either building of using those third-party services, and we were not an exception.


# Core Capabilities


<!-- .slide: data-background="/img/products/knative.png" data-background-size="contain" -->

Note:

Mauricio:

In 2018, I jumped to work with the Knative team at VMware, after almost 3 years of working full time helping developers and teams to adopt Kubernetes-based projects I realized that working with Go for this ecosystem made a lot of sense, but at the same time by 2020, the cloud native community was much more than Go. Communities like Java, dotnet, Python, and Node were getting closer to the Kubernetes ecosystem.


<!-- .slide: data-background="/img/products/argo.png" data-background-size="contain" -->

Note:
Viktor:

I got interested into ways how to manage "stuff" running inside Kubernetes clusters and that, inevitably, led me to GitOps and, through it to Flux and, in my case, to Argo CD.

All of a sudden, people started writing YAML and pushing it to Git. From there on, "GitOps magic" did the rest.

Nevertheless, the beauty of Kubernetes is that we are not limited only to third-party services. We eventually understood that we could build our own, and that led both of us in that direction.


# Make it your platform


<!-- .slide: data-background="/img/products/dapr.png" data-background-size="contain" -->

Note:
Mauricio:

This journey led me back to developers, when in Nov 2022 I joined Diagrid a company working on the Dapr project. Same story again, cloud native project, written in Go but aiming to provide developers using any language APIs to abstract away the complexities of creating and running distributed applications. 


<!-- .slide: data-background="/img/products/crossplane.png" data-background-size="contain" -->

Note:
Viktor:

Crossplane, KubeVela, Kratix, and a few other projects showed us that building our own APIs (CRDs) and services (controllers) with relative ease. A new type of tools emerged, with a tentative name control planes, that enabled us to convert both third-party and our own services into a platform with custom APIs and controllers that, when combined enabled us to build developer platforms in the same way as general purpose platforms like AWS, Azure, and Google Cloud. Those are based on the same principles, but with modern tech, that allow us to build platforms that meet the specific needs of an organization as opposed to being general-purpose. All those are based on the principles we discussed earlier.


<!-- .slide: data-background="img/dapr+crossplane.png" data-background-size="contain" -->


<!-- .slide: data-background="img/idp-present-10.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-11.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-12.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-13.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-14.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-15.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-16.png" data-background-size="contain" data-background-color="black" -->


<!-- .slide: data-background="img/idp-present-17.png" data-background-size="contain" data-background-color="black" -->


# Blueprints


<!-- .slide: data-background="img/book-cover.jpg" data-background-size="contain" -->

Note:
We, as platform engineers, are getting really comfortable at combining these tools.
Mauricio:
In Feb of 2020, I started writing the book published in Oct 2023 titled Platform Engineering on Kubernetes, this book was all about Kubernetes-based projects and the natural adoption journey for all these tools. I had a very ambitious goal, I wanted to make this book about software delivery, hence I needed a complex application (not a hello world) to show how the cloud native ecosystem can help companies to deliver software, but let's be clear, if you are in KubeCon you are closer to DevOps and infrastructure, not application development. 


<!-- .slide: data-background="img/backstack.png" data-background-size="contain" -->

Note:
We have seen a lot of consolidation happening in the space, with tools blueprints like CNOE, BACK Stack and Kusion stack building combinations of tools.
This shows maturity around projects that are now integrated with one another and presented in common use cases.


<!-- .slide: data-background="img/cnoe-diagram.png" data-background-size="contain" -->


<!-- .slide: data-background="img/kusion-stack-diagram.png" data-background-size="contain" -->


<!-- .slide: data-background="img/idp-present-17.png" data-background-size="contain" data-background-opacity="0.2" -->
## High-level architecture of internal platforms is the same as architecture of public platforms (e.g. AWS, Azure, Google, etc.) but on top Kubernetes

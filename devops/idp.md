<!-- .slide: data-background-image="img/catalog.jpg" data-background-size="cover" data-background-color="black" -->

Note:
Internal Developer Platforms are not the same as service
  catalogs.
Adding Backstage or a similar tool on top of whichever tooling
  you already have is like wrapping a piece of shit with a gift
  wrap.
The wrap is nice, but only until you open it and realize that
  it's shit inside it.
Now, to be clear, shit is very useful.
Some farmers still use it as fertilizer so there's clearly
  value in it, but not to you, not to the one that got it
  wrapped as a present.
You'll need more than a gift wrap if you want to have an
  internal developer platform and if you want people in your
  company to self-manage their needs.
Let me recap the SDLC we discussed so far.
A simplified version of software development life cycle could
  be like this.


<!-- .slide: data-background-image="img/idp-01-01.jpg" data-background-size="contain" data-background-color="black" -->

Note:
 An engineer writes some code. By code, I mean "something that
   can be understood by machines" and that means Java, Go, or
   JavaScript code, but also a Shell script, a YAML manifest,
   or anything else understood by machines.
 That "code" is pushed to Git and that stdarts a CI/CD process
   that runs unit tests, builds artifacts, scans the code and
   those artifacts, deploys the artifacts somewhere, runs
   functional and other types of tests that require the process
   to be up-and-running, and, finally, observes the process
   until it is replaced by the new release.
 Now, to be clear, there are likely many other steps involved
   in SDLC, but I won't dive into those here.
 This is not a detailed description of everything we might or
   might not do in SDLC, but, rather, a simplistic view meant
   to help us understand that SDLC contains a number of steps or
   tasks that should be executed.
 ... and not comes Internal Developer Platform...


<!-- .slide: data-background-image="img/idp-01-02.jpg" data-background-size="contain" data-background-color="black" -->

Note:
For many, that is a UI like, for example, Backstage, that
  sits on top of everything running somewhere as well as the
  tasks that were executed as part of SDLC.


<!-- .slide: data-background-image="img/idp-01-03.jpg" data-background-size="contain" data-background-color="black" -->

Note:
What does a UI like Backstage do?
It serves two primary purposes.
First of all, it allows us to define something.
That could be a form with some fields and drop-down lists
  through which we can define a new application, or a database,
  or a cluster.
Most of the time its limited to applications, but, at least in
  theory, anything is possible.
Those definitions can be presented to the user or pushed
  directly to Git.
Further on, we can use it to observe stuff.
That can be applications running in a cluster, results of
  unit tests, builds, security scans, deployments, functional
  tests, or, even, metrics, logs, and traces of the processes
  running in production.
Now, since each of those tend to have a lot of information and
  might have fairly complex representations, we often get a
  summary of what's going on with a link to some other tool
  where we can see more details.
That could be, for example, a summary of an execution of
  Jenkins or GitHub Actions build which leads to those same
  tools for more details.
It could be a summary of security scanning with the link to
  Snyk or Trivy.
That could also be some rudimentary metrics from Prometheus,
  logs from Loki, or traces from Jaeger.
All those might lead to an endless number of dashboards in
  Grafana.
Now, that might seem like a great solution.
With Backstage and similar tools, we get a single pane of glass
  or, to be more precise, the gateway from which we can access
  everything.
We can see what's running, what failed, what is having
  performance issues, what is insecure, and so on.
To top it all of, we can even use it to create new stuff that
  will be added to that catalog.
That's amazing, right?
Well... not really.
That's the gift wrap I mentioned earlier.


<!-- .slide: data-background-image="img/idp-01-04.jpg" data-background-size="contain" data-background-color="black" -->

Note:
You see, the major problem is not that we cannot find the
  information we're looking for or the tools that contain the
  information we need.
The problem is that the information is made for experts in
  certain fields and the tools were designed to accomodate
  those same experts.
Someone deeply familiar with Kubernetes will have no problem
  to stitch together a Deployment, a Service, an Ingress, a
  Horizontal Pod Autoscaler, a Virtual Service, and quite a
  few other building blocks that are required to run an
  application.
A database administrator that spent enough time learning AWS
  will know that a PostgreSQL database can be created by
  combining RDS with a VPC, a few subnets, a subnet groups,
  a gateway, a few routes, and so on and so forth.
Actually, more often than not, even a database administrator
  will not know that and will need help from someone fully
  dedicated to AWS.
There are many other examples and it all boils down to the
  fact that there is hardly anyone that can do everything.
So, we cannot define what we want.
A person working on an application cannot know how to define
  that application as a bunch of Kubernetes low-level building
  blocks, nor she can define the database for that application,
  nor the cluster, nor many other things required for an
  application to be created and run successfully.
Now, if we cannot define everything by, let's say, writing
  YAML manifests, having all that exposed as fields in a UI
  will not help either.
Moving on, everyone knows Git, so it should not be a problem
  to push stuff to Git, if only we would know what to push.
Unit tests are certainly a problem.
If I don't know what I'm defining, I certainly cannot write
  tests for that something.
Even if someone else writes them for me, I will not be able to
  understood their outputs.
If there is an error, if an assert failed, I will not know what
  that means nor how to fix it.
Moving on...
Builds should not be a problem.
... or maybe they are, but I'll be generous and say that they
  are not.
Now, scanning is a problem.
It's probably the most dreaded of the steps in SDLC.
Things we do not understand are scanned for vulnerabilities,
  and the outcomes often state that there are hundreds or even
  thousands of violations that we cannot fix.
We cannot remedy those violations because they are described in
  a language we do not understand, with references that are
  cryptic, and with fixes that are not obvious.
Now, to be clear, security experts do understand those, but
  not the rest of us.
It seems that even tasks are not a problem, so I'll give
  deployments a pass, even though when they fail we won't
  understand why they failed since we were not able to define
  what those deployments are in the first place.
Still, I'm generous today so, in the spirit of saying that
  even tasks are easy, I'll give it a pass, and move to
  testing that requires live processes which, just as unit
  testing results in uncomprehensible outcomes since, again,
  they are depending on much more than the code of the apps
  themselves.
Service mesh might be misbehaving, storage might be slow, 
  network might be flaky, and so on and so forth.
Finally, obsevability of the live system, call it prouction,
  might be fighting with security scanning for being the
  most dreaded of the steps in SDLC.
There's memory and CPU usage, there are both application and
  system logs bundled together, there are traces, and so on
  and so forth.
All those are often tightly coupled with the infrastructure,
  networking, storage, security, and many other things that
  are not part of the application itself.
All in all, we have a shiny UI that allows us to catalog and
  observe everything from one place with redirections to
  different tools for more details.
That's mostly useless for majority of us.
If you're not an expert in one of the fields, the information
  is too hard to digest and the tools you're led to were
  designed to serve someone else.
Experts in those area will go directly to those tools bypassing
  whichever UI we put on top, while the information that tool
  is presenting is almost useless to anyone else.
We just wasted time setting up, developing, and maintaining
  backstage that serves almost no one.
Does that mean that a UI like Backstage is useless?
Not at all.
What that means is that it is useless by itself.
It's a gift wrap that should have a present inside, and not a
  piece of shit.


<!-- .slide: data-background-image="img/idp-01-05.jpg" data-background-size="contain" data-background-color="black" -->

Note:
What we need is to create services and those services should be
  at the right level of abstractions.
"What is the right level of abstration?" you might ask.
Well...
If you are creating a service that will act as an application,
  or a database, or a cluster, the users of that service are
  your customers.
The right level of abstraction is whatever your customers
  would like it to be.
For example, when I shop on Amazon, they are the service
  provider and I am a customer.
They know that I might want to have standard shipping that
  takes a couple of days, or that I would pay for express
  shipping and get it the same day.
The level of abstration they created contains a single question
  asking me whether I want standard or express shipping.
There's are also "advanced" settings that allow me to choose
  the time of the day when the shippment should arrive.
Then there are things that I am not asked; that I do not need
  to worry about.
I am not asked whether it should be shipped with tracks or
  planes or boats or a combination of those.
I am not asked which highway trucks should take.
I am in control of things that matter to me, and those that do
  not are abstracted away.
Amazon figured out what is the right level of abstraction for
  me, at least when shipping is concerned.
That service and the right level of abstraction is a contract
  between Amazon and me.
I guarantee that the type of shipping I chose is the one I want
  and that the shipping address is correct.
Amazon will hold me accountable for that.
On the other hand, they guarantee that the package will arrive
  at the agreed destination and at the agreed time.
I don't care how they do it and they assume that what I
  specified is correct.
We need something similar for our services.
People who are experts in something should create abstractions
  that will allow everyone else to consume their services.
That can be applications, databases, clusters, or anything
  else.
One of the tasks of providers of those services is to make
  sure that the lower level resources are spun up from
  instances of abstractions the end users create.
If, for example, I create an instance of an application and
  that application should be running in Kubernetes, the job
  of that service is to create and manage lower-level resources
  like Deployments, Services, Ingressses, Horizontal Pod
  Autoscalers, and so on and so forth.
Once we create such services with such abstractions, the
  first issue in the SDLC is solved.
Everyone knows how to create an instance of the service or
  the abstraction simply because they are designed to cater
  to the needs of the end users.
Now, let's move to unit testing.


<!-- .slide: data-background-image="img/idp-01-06.jpg" data-background-size="contain" data-background-color="black" -->

Note:
That also becomes easy, as long as we know who tests what.
If I am the service provider, my job is to guarantee that
  the service I provide does the right thing.
I am testing that the service itself is working as expected.
If I would make a parallel with AWS, they are ensuring that,
  for example, hypervisors behind EC2 instances are working
  as expected.
They do not care whether EC2 instances their end-users are
  demanding are specified correctly and, for example, whether
  I choose the right size.
That's not their job.
Their job is to make sure that any allow instance type can be
  created and that it will be running as expected.
On the other hand, I, as the end user, the customer of AWS,
  have the responsability to test that what I said I want, like
  the size and the OS of an EC2 instance, is what I actually
  want.
The logic is the same when working on internal platforms.
The service provider, an expert in something, is responsible
  for testing that the service is working as expected.
On the other hand, the user of that service, let's say me,
  an application developer, should have no problem verifying
  that what I specified is what I want.
After all, I am the one that specified it.


<!-- .slide: data-background-image="img/idp-01-07.jpg" data-background-size="contain" data-background-color="black" -->

Note:
As a result, defining unit tests and observing their results
  is easy since it's limited to the scope of the abstraction.
That's what should be sent to the UI like backstage since
  the rest, the part managed by service providers, is already
  covered by whichever tools they use.
As a result, the scope of that UI is getting reduced.
It's not any more a single pane of glass for everything and
  everyone.
That would be a waste of time since each of us is already
  familiar and used to tools that are specific to whichever
  type of work we're specialized in.
Instead, the UI is becoming a single pane of glass for
  people who need to do something that is outside of their
  area of expertise.
If you're a database administrator, you already have very
  specific tools that help you deduce whether database servers
  you're offering as a service are working as expected.
The "new" UI is there to provide visibility to your end users
  who are only concerned with a fraction of the information
  that concerns them directly.
If I go back to the Amazon shipping example, I can see whether
  my package was shipped and, if it is, where it is.
That's the information I am presented with, and that's only a
  fraction of the data Amazon has.
Those acting as shipping providers can see which transportation
  method was used, what is the QR code of the package, who is
  driving the tuck, and so on and so forth.


<!-- .slide: data-background-image="img/idp-01-08.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Let's move to security...
Traditionally, security experts delegate fixing threats to
  application developers.
That almost never worked for a simple reason that they often
  do not understand low-level details involved in security
  issues, especially since many of the issues can be fixed
  by upgrading the OS, or the base image, or a OS library,
  and so on and so forth.
It's unrealistic to expect someone to fix something he or she
  did not choose or did choose randomly.
However, once we move towards providing services consumable by
  application developers, we have a clear separation who should
  fix what.
Is the security threat caused by something you defined?
If that's a library you imported into the code you wrote, it
  must be your responsability to fix it.
If that's an outcome of consuming a service created by someone
  else, it's someone elses responsability to fix it.
Here comes the tricky part.
The vulnerability can be caused by one person, or a team,
  using something that is defined by you, but managed by
  someone else.
For example, a database administrator might have created
  database-as-a-service and you are running an instance of it.
That could be, for example, a PostgreSQL 13 database.
Now, there are two scenarios that could have happened.
You might have created an instance of the PostgreSQL 13
  database provided to you as a service that already has known
  vulnerability.
If that's the case, the database administrator that provides
  that service should have known better and setup policies
  that prevent you from doing that in the first place.
Thirtteen should not have been an option in the first place and
  the policy should prevent its instantiation with a
  recommendation to use version 14.
We cannot blame users of our services by doing things they
  shouldn't do.
Prevention of bad practices is or, to be more precise, should
  be a part of the services.


<!-- .slide: data-background-image="img/idp-01-09.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Anyways...
It the resopnsability of service authors to esure that the 
  resources created as a result of using a service are secure,
  and it's up to users of those services.
That means that service owners, the authors, should be scanning
  "low level" resources created from service instances, while
  service users should scan the instances themselves, those
  created through abstractions.


<!-- .slide: data-background-image="img/idp-01-10.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Hence, we solved the security part of SDLC.


<!-- .slide: data-background-image="img/idp-01-12.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Testing should follow the same principles.
I must assume that service owners are ensuring that all the
  supported permutations of their services are always working
  as expected, that they are fault tollerant, scalable, and
  so on and so forth.
The customers, service users, only need to ensure that they
  choose what they want, and not much more.
For example, if I create an AWS EC2 instance, my job, as a
  service user, is to ensure that I selected size that suits
  my needs, and the operating system I want to use.
Almost everything else depends on AWS.
They need to ensure that the is enough capacity to create that
  EC2 instance in the zone I selected, that it is
  up-and-running for as long as I need it to be running, that
  it is accessible, and so on and so forth.
That creates a clear delineation of who tests what.
I, the user, test that my scripts are making the API calls
  to AWS API, and AWS ensures that what's happing after those
  calls is correct.
We can think of that division as before and after something
  reaches the API.
The same is valid for internal services.
If a user needs a database, that user needs to ensure that
  the API call is correct and that the information provided
  in that request matches the desired state.
Whatever happens after the API, inside the control plane, is
  the responsability of service owners to test in order to
  guarantee proper functioning of the service.


<!-- .slide: data-background-image="img/idp-01-13.jpg" data-background-size="contain" data-background-color="black" -->

Note:
Finally, we get to observability.
This might be the biggest difference between the data and the
  tooling used by service owners and service users.
It's pointless to expose to end users anything that is not
  a part of the service abstraction we created.
For example, if a user can specify the amount of memory that
  should be dedicated to that database, memory should be
  provided as one of the graphs in whichever observability
  tool is provided to end-users.
On the other hand, if memory specification is not the part
  of the abstraction, we must assume that it's up to the
  service itself to assign as much as needed, and adding that
  information to end-user observability only inreases the
  confusion.
Now, memory might not be the best example since that is likely
  going to be exposed to service users so change my examples
  to something else like the number of threads, subnets, VPCs,
  or any other of hundreds or even thousands of details that
  matter to you, the service owner, but not to the end users.
In this case, I'll refer back to my previous example with 
  Amazon shipping.
There is no information about truck drivers or the routes since
  that is irrelevant to me.
All I want to know is whether my shipment will arrive and when
  that will happen.


<!-- .slide: data-background-image="img/catalog.jpg" data-background-size="cover" data-background-color="black" -->

Note:
Internal Developer Platforms are hard to build, at least when
  we want to do them right or, to be more precise, when we
  understand what IDPs really are.
Building a UI like Backstage on top of existing tools and
  processes is not a developer portal.
An IDP is not a service catalog.
An IDP is a collection of services that enable the end-users
  to perform tasks that are outside their core competency.
IDP cannot be built by a single team.
Instead, a team can build a platform that enables others to
  add their services to the catalog.
Ultimately, experts in certain fields like databases,
  infrastructure, application architecture, and other areas
  are those building services that constitute an IDP.
Otherwise, an attempt to make teams self-sufficient and
  auntonomous by simply automating SDLC will fail.
If people cannot define what they need and if they cannot
  observe the state of their applications and underlying
  infrastructure, automation is not going to help with that
  goal.

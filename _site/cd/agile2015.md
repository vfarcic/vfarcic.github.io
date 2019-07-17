Title
=====

Continuous Deployment: The Ultimate Culmination of Software Craftsmanship
-------------------------------------------------------------------------

Often, automatic, fast, with zero-downtime and the ability to rollback


Co-Presenter
============

Featured Participants
=====================

Track
=====

Technical: DevOps

Session Type
============

Talk

Audience Level
==============

Learning

Room Setup
==========

Theater

Duration
========

75 minutes

Keywords
========

Continuous Delivery, Continuous Deployment, CD, Docker, DevOps

Abstract
========

Introduction
------------

Continuous Deployment is the natural evolution of continuous integration and delivery. It is the ultimate culmination of software craftsmanship. Our skills need to be on such a high level that we have a confidence to continuously and automatically deploy our software to production.

We usually start with continuous integration with software being built and tests executed on every commit. As we get better with the process we proceed towards continuous delivery with process and, especially tests, so well done that we have the confidence that any version of the software that passed all validations can be deployed to production. We can release the software any time we want with a click of a button. Continuous deployment is accomplished when we get rid of that button and deploy every "green" build to production.

We'll try to explore the goals of the final stage of continuous deployment, the deployment itself. We'll assume that static analysis is being performed, unit, functional and stress tests are being run, test code coverage is high enough and that we have the confidence that our software is performing as expected after every commit.

The goals of deployment process that we should aim for are:

* Run often
* Be automatic
* Be fast
* Provide zero-downtime
* Provide ability to rollback

**Deploy Often**

We'll try to explore why it is important to deploy often. What are the pros and cons deploying on every commit instead once a month or few times a year? What are the prerequisites for successful deployment? 

**Automate everything**

Why automation? What are the pros and cons of provisioning tools like Chef and Puppet? What are containers (e.g. Docker) and how do they help? Do we need provisioning tools if we adopt containers?

**Be fast**

Speed is the key. Can we deploy often if the process is not fast? What is the relation between fast deployments and time-to-market? What is the acceptable deployment duration?

**Zero-downtime**

We cannot deploy often without zero-downtime. If there is any downtime during deployment, it will be multiplied with the number of deploys we do. We'll go through one blue-green deployment as one possible way to accomplish zero-downtime.

**Ability to rollback**

Unexpected happens sooner or later and the ability to rollback is a must. How can we accomplish automated, fast and reliable rollback? What are the major obstacles?  

Deployment Strategies
---------------------

We'll explore different strategies to deploy software. This session will in no way provide an exhaustive list of ways to deploy applications but will try to discuss few common ways that are in use today.

Each of the strategies presented is based on practical experience and each of them created a different set of issues. We'll go through both concepts behind those strategies and specific issues we faced when implementing them.

**Mutable monster server**

We are used to build and deploy big mutable applications. That's how we did it during most of the short history of software industry. What are pros and cons of "mutable monster server"? Can we deploy it often with zero-downtime and easily rollback? Is automation of such a server the way to go? Can it be fast? Are there any alternatives?

**Immutable servers**

What are immutable servers? How can we deploy them? What is blue-green deployment in the context of immutable servers? What are the benefits?

**Immutable microservices**

What are microservices? Why do they fit perfectly into the concept of immutable servers?

Live Example
------------

Once we are all familiar with Continuous Deployment and different strategies that can be employed, we'll got through one example of deploying fast, often, automatically, with zero-downtime and the ability to rollback. We'll use Docker, Ansible, nginx and few other tools together with microservices approach to architecture coupled with TDD to release and deploy an application. All examples will be run live.

Summary
-------

Continuous deployment sounds to many as too risky or even impossible. Whether it's risky depends on the architecture of software we're building. As a general rule, splitting application into smaller independent elements helps a lot. Microservices is the way to go if possible. Risks aside, in many cases there is no business reason or willingness to adopt continuous delivery. Still, software can be continuously deployed to test servers thus becoming continuous delivery. No matter whether we are doing continuous deployment, delivery, integration or none of those, having automatic and fast deployment with zero downtime and the ability to rollback provides great benefits. If for no other reason, because it frees us to do more productive and beneficial tasks. We should design and code our software and let machines do the rest for us.

Learning Outcomes
=================

In this session you will learn:

* What is Continuous Deployment
* Importance to run deployment often, automatically and fast with zero-downtime and the ability to rollback
* Different deployment strategies
* Deployments and architecture of immutable microservices as the key to successful Continuous Deployment

You will also see few case studies and "real world" examples.


Prerequisite Knowledge
======================

Information for Review Team
===========================

The overall flow will be:

* Introduction to deployment techniques and Continuous Deployment
  * Discussion about evolution of deployment techniques
  * Discussion around 5 key elements of successful implementation of Continuous Deployment: run often, be automatic, be fast, provide zero-downtime and ability to rollback.
* Deployment strategies
  * Mutable servers
  * Immutable servers
  * Immutable microservices
* Live example
* Summary

The session should be very interactive. I'll try to present my experiences and engage audience to share their own.

Presentation will be a mix of prepared slides and live coding and demos. 
 
Presentation History
====================

Similar presentation has been given in Barcelona Software Craftsmanship 2014.

Workshop on the same subject will be given in a 8 hour workshop in [Craft 2015](http://craft-conf.com/2015#workshops/ViktorFarcic).

It was presented and was part of workshops that attended more than 300 employees of the company I worked for. Presentation and workshops had a success that resulted in requests to repeat the same for our clients in US, UK, Finland, Spain, Poland and Singapore. Since then I changed the company and am currently presenting, holding workshops and applying it in several big insurance and banking corporations.

I wrote many articles on the subject of [Continuous Integration, Delivery and Deployment](http://technologyconversations.com/category/continuous-integration-delivery-and-deployment/) and am currently writing a book.

Presentation Sample
===================

http://vfarcic.github.io/cd/

This is the last presentation I gave on a similar subject. The one planned for Agile 2015 will have similar content.

Bio
===

Viktor Farcic is a Software Architect at everis.

He coded using plethora of languages starting with Pascal (yes, he is old), Basic (before it got Visual prefix), ASP (before it got .Net suffix), C, C++, Perl, Python, ASP.Net, Visual Basic, C#, JavaScript, etc. He never worked with Fortran. His current favorites are **Scala** and **JavaScript** even though most of his office hours are spent with **Java**.

His big passions are Behavior-Driven Development (BDD), Test-Driven Development (TDD) and Continuous Integration, Delivery and Deployment (CI/CD).

He is major contributor to the open source project BDD Assistant and often speaks at community gatherings and conferences.


Contact Details:

* E-mail: viktor@farcic.com
* Twitter: @vfarcic
* Skype: vfarcic
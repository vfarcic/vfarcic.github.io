Continuous Delivery: Best Practices
===================================

CI vs CD
--------

* Continuous integration

  * Automated integration flow
  * Merge to main branch often (at least once a day)
  * Not a "production ready" process

* Continuous delivery

  * Every commit to VCS that passed the flow **can be** deployed to production
  * No manual actions but pressing the button to deploy to production

* Continuous deployment

  * Every commit to VCS that passed the flow **is** deployed to production
  * No manual actions of any kind

Repeatable reliable process
---------------------------

* Same artifacts
* Same process
* Same release process

  * QA == staging == integration == production

Automate everything
-------------------

* Manual steps

  * Slow / non-efficient
  * Not repeatable
  * Prone to errors

* No manual steps

  * build
  * testing
  * release
  * configuration
  * provisioning

* Right tool for a job

Version control everything
--------------------------

* Everything in VCS

  * Code
  * Configuration
  * Scripts
  * Database deltas
  * Documentation
  * Delivery flow

* Everything related to a single project in single repository

Short feedback loops
--------------------

* Continuous != monthly != weekly
* Continuous == (at least) daily
* Fix of a delivery flow failure = priority
* Time to fix the problem !~ time it was detected
* Delivery flow must be fast

Done == released
----------------

* Release == running in production

Team responsibility
-------------------

* Team != departments
* Cultural change
* Architectural change

Continuous everything
---------------------

* Continuous development & testing
* Continuous delivery
* Continuous improvement

Build once, deploy multiple times
---------------------------------

* Immutable deployments

Branches
--------

* Eliminate or minimize to short lived
* Google, Facebook or Amazon commit to main branch

Delivery flow
-------------

* Generates everything

  * Binaries
  * Environment(s)
  * DB changes
  * Documentation

CD & DevOps
-----------

TODO

Delivery pipeline aspects
-------------------------

* Visibility

  * All aspects of the delivery system including building, deploying, testing, and releasing are visible to every member of the team to promote collaboration.

* Feedback

  * Team members learn of problems as soon as possible when they occur so that they are able to fix them as quickly as possible.

* Continually deploy

  * Through a fully automated process, you can deploy and release any version of the software to any environment.

Benefits
--------

* Time-to-market

  * CD lets an organization deliver the business value inherent in new software releases to customers more quickly. This capability helps the company stay a step ahead of the competition.

* Building the Right Product

  * Frequent releases let the application development teams obtain user feedback more quickly. This lets them work on only the useful features. If they find that a feature isn’t useful, they spend no further effort on it. This helps them build the right product.

* Improved Productivity and Efficiency

  * Significant time savings for developers, testers, operations engineers, etc. through automation.

* Reliable Releases

  * The risks associated with a release have significantly decreased, and the release process has become more reliable. With CD, the deployment process and scripts are tested repeatedly before deployment to production. So, most errors in the deployment process and scripts have already been discovered. With more frequent releases, the number of code changes in each release decreases. This makes finding and fixing any problems that do occur easier, reducing the time in which they have an impact.

* Improved Product Quality

  * The number of open bugs and production incidents has decreased significantly.

* Improved Customer Satisfaction

  * A higher level of customer satisfaction is achieved.
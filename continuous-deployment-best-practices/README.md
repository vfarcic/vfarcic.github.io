Continuous Delivery: Best Practices
===================================

How long would it take your organization to deploy a change that involves just one single line of code? Do you do this on a repeatable, reliable basis?

Mary Poppendieck

WHY SHOULD WE CARE ABOUT CONTINUOUS INTEGRATION, DELIVERY OR DEPLOYMENT?
------------------------------------------------------------------------

* BECAUSE IT IS MODERN?
* BECAUSE IT IS POPULAR?
* BECAUSE EVERYBODY TALKS ABOUT IT?
* WE SHOULD CARE BECAUSE...
  * Earlier feedback to business
  * Faster development
  * Fewer merge conflicts
  * Lower deployment risk
  * Changes done faster (no need to wait for release)

CI vs CD
--------

* Continuous integration

  * Automated integration flow
  * Merge to main branch often (at least once a day)
  * Not a "production ready" process

* Continuous delivery

  * YOU’RE DOING CONTINUOUS DELIVERY WHEN...

    * You are already doing continuous integration
    * Your software is deployable throughout its life-cycle
    * Your team prioritizes keeping the software deployable
    * Anybody can get fast, automated feedback on the production readiness
    * You can perform push-button deployments

  * Every commit to VCS that passed the flow **can be** deployed to production
  * No manual actions but pressing the button to deploy to production

* Continuous deployment

  * YOU’RE DOING CONTINUOUS DEPLOYMENT WHEN...

    * You are already doing continuous delivery
    * There are no buttons to push

  * Every commit to VCS that passed the flow **is** deployed to production
  * No manual actions of any kind

* Everything following a commit is automated

  * Everything you were doing after the commit needs to be done in advance
  * The order of tasks changes
  * Reactive &gt; proactive

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

Culture & technology
--------------------

* Change on all levels

  * Culture
  * Technology
  * Architecture
  * Organization structure

* Organizations which design systems ... are constrained to produce designs which are copies of the communication structures of these organizations

— M. Conway

* CD is vertical

  * It's not another process
  * It's not another layer
  * It spans the whole structure vertically
  * Affects the whole SDLC
  * From business and requirements, through development and testing, all the way until operations and maintainance... is a single, continuous process without delays.
  *  There can be no hand-offs

Repeatable reliable process
---------------------------

* The same artifacts
* The same process
* The same release process

  * QA == staging == integration == production == immutable deployments

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

Branches
--------

* Eliminate or minimize to short lived
* Google, Facebook or Amazon commit to main branch

Done == released
----------------

* Release == running in production





Delivery flow
-------------

* Generates everything

  * Binaries
  * Environment(s)
  * DB changes
  * Documentation

Delivery pipeline aspects
-------------------------

* Visibility

  * All aspects of the delivery system including building, deploying, testing, and releasing are visible to every member of the team to promote collaboration.

* Feedback

  * Team members learn of problems as soon as possible when they occur so that they are able to fix them as quickly as possible.

* Continually deploy

  * Through a fully automated process, you can deploy and release any version of the software to any environment.

Continuous everything
---------------------

* Continuous development & testing
* Continuous delivery
* Continuous improvement

CD & DevOps
-----------

* CD without DevOps?

Do & Do Not
-----------

* Do not

  * Form a CD team
  * Do not task one department to create a CD flow
  * Do not automate inside a CD tool

* Do

  * Form a multifunctional and autonomous team capable of delivering a service
  * Include someone with CD experience inside the team
  * Choose an easy target
  * Trust the team
  * Short iterations
  * A feature/story is done when it is ready for (or deployed to) production
  * It's a learning experience
  * The team will fail, learn from failure, improve, repeat
  * Support in failure

TODOs
-----

* What leaders need to know about CI/CD?
* What to focus on?
* What is expected from/by teams
* Advantages/disadvantages
* Concrete examples
* Concrete numbers in terms of speed
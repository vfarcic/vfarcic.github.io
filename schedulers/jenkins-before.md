# Monster master

* Single point of failure<!-- .element: class="fragment" -->
* Performance issues<!-- .element: class="fragment" -->
* Difficult to upgrade<!-- .element: class="fragment" -->
* No isolation<!-- .element: class="fragment" -->

## ... becomes one master per team<!-- .element: class="fragment" -->


# Traditional Distributions

* Hard to automate<!-- .element: class="fragment" -->
* Mutable<!-- .element: class="fragment" -->
* Hard to upgrade<!-- .element: class="fragment" -->

## ... move into Docker images<!-- .element: class="fragment" -->


# Docker containers

* Not fault tolerant<!-- .element: class="fragment" -->
* Not highly available<!-- .element: class="fragment" -->
* Inefficient resource usage<!-- .element: class="fragment" -->

## ... are handled by schedulers<!-- .element: class="fragment" -->


# FreeStyle Jobs

* Undocumented<!-- .element: class="fragment" -->
* Inappropriate for complex operations<!-- .element: class="fragment" -->
* No review<!-- .element: class="fragment" -->
* Centralized<!-- .element: class="fragment" -->

## ... became Jenkinsfile<!-- .element: class="fragment" -->


# Jenkins Agents

* Wasted resources<!-- .element: class="fragment" -->
* Hard to provision<!-- .element: class="fragment" -->
* Inflexible<!-- .element: class="fragment" -->

## ... became one-shot agents<!-- .element: class="fragment" -->
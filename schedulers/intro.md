# Today's Requirements

* High availability<!-- .element: class="fragment" -->
* Scalability<!-- .element: class="fragment" -->
* Fault tolerance<!-- .element: class="fragment" -->
* Self-healing<!-- .element: class="fragment" -->
* Self-adaptation<!-- .element: class="fragment" -->
* Automation<!-- .element: class="fragment" -->


# Before

* Mutable: not reliable, not replicable<!-- .element: class="fragment" -->
* Static: not healable, not available, not fault tolerant, expensive<!-- .element: class="fragment" -->
* Manual: unreliable<!-- .element: class="fragment" -->


# Today

* Immutable<!-- .element: class="fragment" -->
* Dynamic<!-- .element: class="fragment" -->
* Automated<!-- .element: class="fragment" -->


# What Does That Mean?

* VMs instead bare metal<!-- .element: class="fragment" -->
* Image instead runtime provisioning<!-- .element: class="fragment" -->
* Packaging as container images instead RPM/DEB/JAR/WAR/...<!-- .element: class="fragment" -->
* Deploying service through schedulers instead CM<!-- .element: class="fragment" -->
* Communication through service discovery instead fixed addresses<!-- .element: class="fragment" -->
* Stateless when possible, replicated when stateful or persisted on network drives<!-- .element: class="fragment" -->


# Containers vs Schedulers

* Containers are NOT the future<!-- .element: class="fragment" -->
* Schedulers are the future<!-- .element: class="fragment" -->
* How did we get here?<!-- .element: class="fragment" -->

# Database-as-a-Service (DBaaS) with Crossplane, External Secrets, Dapr, and Atlas Operator

## Description

What is required to make a Database-as-a-Service (DBaaS)? One might think that creating a user-friendly interface that exposes a service that creates, manages, and deletes database servers like, for example, PostgreSQL, is all it takes. That's far from the truth. We need much more than that.                  
                                                                                                                                                             
We need to manage users and databases inside the server. We need a way to apply database schema. We need to generate secrets with authentication data and propagate those secrets to clusters with applications that should use those databases. We need to enable applications to connect to those databases transparently and frictionlessly. Finally, we need a way to wrap all of those together and expose them through an easy-to-understand and use interface. 
                                                                                                                                                             
How can we accomplish all that? How can we create a Database-as-a-Service solution?
                                                                                                                                                             
Today we'll explore one possible solution that combines Crossplane, External Secrets Operator (ESO), Atlas Operator, Dapr, and a few other tools.

## Benefits to the ecosystem

* Expanded Adoption of CNCF Technologies like Crossplane, External Secrets Operator and Dapr.
* Reduced Operational Overhead and Costs: Database-as-a-Service eliminates the need for manual resource provisioning and management, significantly reducing operational overhead and associated costs. This cost-efficiency benefits both developers and organizations.
* Enhanced Developer Productivity: Database-as-a-Service simplifies application development and deployment, freeing up developers to focus on writing high-quality code and innovative features without waiting for . This increased productivity contributes to overall development efficiency.
* Expanded Application Use Cases: Serverless architectures on Kubernetes enable the development of a broader range of applications, including event-driven, microservices-based, and edge computing applications. This versatility expands the scope of cloud-native development.
* Stronger Community Collaboration: Combining CNCF projects brings together developers and infrastructure experts from different backgrounds, fostering collaboration and knowledge sharing within the CNCF community. This collaboration contributes to the advancement of those projects.

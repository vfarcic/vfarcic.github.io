Applications Development
========================

This series will try to provide one possible way to develop applications. We'll go through the full applications lifecycle. We'll define high-level requirements and design, use BDD to define executable requirements and develop using TDD. Architecture will be based on Microservices and the whole process will be backed by continuous deployment. Every commit to the repository will be deployed to production if it passed all tests. We'll programm in JavaScript backed by AngularJS and Scala with Spray. Configuration management will be done with Ansible. Microservices and front-end will be built and deployed with Docker. Depending on where this leads us, there will be many other surprised on the way.

This will be an exiting journey that starts with high-level requirements and ends with fully developed application deployed to production.

High Level Requirements
-----------------------

We are building Books Retailer application. We should have a web site that can be used on any device (desktop, tables and mobiles). Users of that site should be able to list and search for books, see their details and purchase them. Purchase can be done only by registered users. On the other hand, site administrators should be able to add new books and update or remove existing ones.

High Level Design
-----------------

We'll build our application using Microservices architectural approach. Each service our application needs will be designed, developed, packed and deployed as a separate service or application. Each microservice will expose RESTful API that front-end, others services and third parties can use. Data will be stored in Mongo DB.

Front-end will be decoupled from back-end and communicate with it by sending RESTful JSON requests.

Everything will be packed in and deployed as self sufficient Docker containers.
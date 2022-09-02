# How To Build Your Own Heroku in 2022?

Heroku was one of the most innovative and useful platforms ever created. Yet, its appeal slowly faded, even though most companies are trying to build their own "Heroku". Why did that happen? How can we build self-serving, opinionated, tailor-made platforms that fulfill specific needs and be easy to use without sacrificing anything? What is the recipe?

All the ingredients are already available. We know that the base platform should be Kubernetes, that it should have monitoring, logging, networking, storage, and all the other things we might need, no matter whether we are using them directly or not. We know that it should involve both the infrastructure and the application resources. What is missing is simplicity tailored for the specific needs of a company we work in. Neither Kubernetes alone nor infrastructure tools give us the ability to create simple-to-use abstractions, at least not easily.

We need a way for operators (SREs, DevOps) to create services that everyone else can easily consume while still doing everything we need those services to do. That's where Heroku failed. It was an opinionated platform created with the idea that the same opinions work for everyone. Instead, we should aim for platforms that enable us to create opinions instead of the tools with opinions baked in.

The missing ingredient is Crossplane Compositions. If we add those two to the mix, we can build our own Heroku that will be just as simple yet tailor-made for our specific needs.

Let's see (through a hands-on demo) how we can create our own Heroku.

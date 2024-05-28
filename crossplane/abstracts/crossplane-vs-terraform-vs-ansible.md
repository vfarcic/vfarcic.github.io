# Terraform vs. Crossplane vs. Ansible - Rivals or Allies?

## Description

I am often asked to compare Crossplane with Terraform, or Pulumi, or Ansible, or any other tool that primarily manages resources, be it those in hyperscalers like AWS, Google Cloud, and Azure, or in Kubernetes, or anywhere else. Well... Today I'm here to tell you that none of those tools are going away any time soon. We need all of those. We need configuration management tools like Ansible, we need Infrastructure-as-Code (IaC) tools like Terraform and Pulumi, and we need control planes, be it opinionated ones like AWS, Google Cloud, and Azure, or those that allow us to build our own control planes like Crossplane.

This will be one of those talks where you are likely going to get mad and yell at me. If that happens, my advice is to calm down since my goal will be to show you how all those should work together. They should be treated as a group of friends singing Kumbaya (my Lord, Kumbaya). Now, just to be sure that your adrenalin keeps pumping, I will also claim that many of the tools I will mention missunderstood their strengts and ended up trying to perform tasks they are not good at.

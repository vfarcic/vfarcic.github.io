# Automating Infrastructure Management With Jenkins X And Terraform

It is clear that Infrastructure-as-Code is the direction we are all moving to and that Git should be the only source of truth. As a result, most companies are managing their infrastructure through Terraform, Ansible, or some similar tools. However, we still tend to run them from our laptops, instead of adhering to GitOps principles.

Can we take a step further and focus only on writing code (or configs) and pushing them to Git and let machines do the rest of the work? Can we manage our infrastructure without having direct access to it?

We'll explore how we can automate convergence of the actual into the desired state by letting Jenkins X take over the processes after we push changes to a Git repository and how we can make those changes safe through pull requests, reviews of plans, and approvals.

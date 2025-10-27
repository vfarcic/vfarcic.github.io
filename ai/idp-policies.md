<!-- .slide: data-background="img/idp-problem-policies.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Now let's talk about policies. While patterns teach AI how to assemble resources according to your organizational know-how, policies are about what values are allowed or required in the fields of those resources.

For example, policies define constraints like "all databases must run in the us-east-1 region", "container images cannot use the 'latest' tag", or "all pods must have resource limits defined". These are field-level constraints that ensure compliance and security.

Here's the key insight: solutions like Kyverno, OPA, or Kubernetes Validating Admission Policies can enforce these policies, but they don't teach AI or people how to do "the right thing" from the start. Without policy learning, you end up with a trial-and-error approach where you keep hitting enforcement barriers until all the checks finally pass. That's inefficient and frustrating.


<!-- .slide: data-background="img/idp-solution-policies.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
What we're building here teaches the AI the policies upfront, so it can create compliant resources from the beginning instead of learning through rejection.


<!-- .slide: data-background="img/policies-06.png" data-background-size="contain" data-background-color="black" -->

Note:
The process for handling policies is mostly the same as with patterns. You identify policies from various sources, create embeddings, and store them in a database.


<!-- .slide: data-background="img/policies-07.png" data-background-size="contain" data-background-color="black" -->

Note:
But here's the key difference: we can also convert those policies into enforceable rules using Kubernetes Validating Admission Policies, Kyverno, OPA, or whatever policy implementation you're using (7). This gives you both proactive guidance for the AI and reactive enforcement in the cluster.

This creates a powerful **two-layer system**: the AI can use data in the Vector database to learn which policies apply to a specific intent and create compliant resources from the start, while Kyverno and similar implementations serve as the last line of defense, just as they always have. Best of both worlds: proactive compliance and enforcement backup.

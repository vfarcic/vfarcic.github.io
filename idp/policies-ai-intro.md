# What Are Policies?


<!-- .slide: data-background="img/policies-ai-01.png" data-background-size="contain" data-background-color="black" -->
NOTE: Let's start with a fundamental question that most people think they know the answer to, but really don't. **What are policies?** You probably think you know. Hell, you might even have dozens of them implemented in your clusters right now. But here's the thing: most of what you call policies aren't actually policies at all.

A real policy is a business rule, a guideline, a principle. It's "Never use `latest` as an image tag because it makes rollbacks impossible and debugging a nightmare." It's "Databases in Google Cloud must always run in the `us-east1` region, those in Azure must run in `eastus`, and AWS databases go in `us-east-1`." These are policies. They're the rules we've established about how things should be done, why they should be done that way, and what happens when they're not.


<!-- .slide: data-background="img/policies-ai-02.png" data-background-size="contain" data-background-color="black" -->
NOTE: Now, Kyverno, OPA, Kubernetes Validating Admission Policies? These aren't policies. They're **technical implementations** of policies. They're the bouncers at the door, the enforcement mechanisms that catch you when you've ignored or weren't aware of an actual policy. They're important, sure, but they're not the policy itself. They're just the way we enforce it.

Here's what happens when all you have are Kyverno policies. Do you read through them all to learn what should be done and how? Of course not. Nobody does that. Instead, you do something, apply it, watch it fail validation, change it, apply again, see it fail a different validation, and repeat this dance until you eventually succeed. It's frustrating, time-consuming, and completely backwards.

Is this what we expect AI to do? Just be completely oblivious to company policies and keep trying until it accidentally succeeds? That's exactly what happens today. We give AI agents access to our clusters and expect them to magically know our rules, but they don't. They can't.


<!-- .slide: data-background="img/policies-ai-03.png" data-background-size="contain" data-background-color="black" -->
NOTE: AI acts remarkably similar to people. It knows what it knows from its training, and it needs to combine that knowledge with your company's specific guidelines, capabilities, patterns, and policies. Only then does it stand a chance of doing the right thing without constantly failing. The AI has access to general information from the internet, sure, but it doesn't have the information specific to your company. It doesn't have the tribal knowledge locked in your head. And that's a problem, because you need to feed it that information somehow.


<!-- .slide: data-background="img/policies-ai-04.png" data-background-size="contain" data-background-color="black" -->
NOTE: So **where are these policies actually stored?** Here's the uncomfortable truth.

**They're everywhere and nowhere at the same time.** They're buried in internal documents and wiki pages that nobody reads. They're hidden in existing code as comments or conventions. They're scattered across thousands of Slack messages and buried in transcripts of Zoom calls that nobody will ever watch again. But more importantly, and this is the real problem, those policies are locked in people's heads. They're in your head right now. The senior engineer who's been here for five years? Their head is full of policies that have never been written down anywhere.

So how do we feed that information to AI? We can't extend AI's knowledge directly. Models are what they are. They're trained on data up to a certain point, and that's it. We can feed information into models during a conversation, but it's only temporary. The moment you start a new session, that context is gone.

If we can't permanently augment what's stored in models, we need a different approach to "teach" AI. Today, we're specifically focused on policies, starting with a question: how can we teach AI what our company policies actually are?

The answer lies in **embeddings, semantic search, and vector databases**. This is how we bridge the gap between what AI knows and what it needs to know about your specific environment.


<!-- .slide: data-background="img/policies-ai-05.png" data-background-size="contain" data-background-color="black" -->
NOTE: This information needs to serve two purposes: first, we need to feed it to AI so it understands what is and isn't acceptable in your environment. Second, we need to create Kyverno resources as the **last line of defense**. That way, even if a person or an AI makes a mistake, Kubernetes itself won't allow wrong values in resources. It's a belt-and-suspenders approach, and it works.

<!-- .slide: data-background="img/idp-problem-patterns.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
Now let's talk about patterns. Here's something important to understand: AI is already perfectly capable of using Kubernetes, assembling solutions in AWS, GCP, Azure, and handling other tasks that are public knowledge. We don't need to teach it those things.

What we need to teach AI are the things that are specific to our company. The patterns that represent how we do things, our standards, our preferred approaches, and our organizational wisdom that isn't documented anywhere in the public internet.


<!-- .slide: data-background="img/idp-solution-patterns.jpeg" data-background-size="contain" data-background-color="black" -->

Note:
AI already knows how to assemble resources based on an intent - that's public knowledge. But patterns teach it how to assemble resources according to **your organization's specific know-how**. Maybe your company always pairs databases with specific monitoring setups, or has a standard way of handling ingress with particular security configurations. These organizational assembly patterns are what we need to capture.


<!-- .slide: data-background="img/patterns-01.png" data-background-size="contain" data-background-color="black" -->

Note:
So where do these organizational patterns live? They can be scattered across existing code repositories, documentation, Wiki pages, Slack conversations, or anywhere else you store institutional knowledge (1).


<!-- .slide: data-background="img/patterns-02.png" data-background-size="contain" data-background-color="black" -->

Note:
 But here's the problem: a lot of these patterns aren't written down anywhere. They exist in people's heads (2), in the collective experience of your team members who know "how we do things around here."


<!-- .slide: data-background="img/patterns-03.png" data-background-size="contain" data-background-color="black" -->

Note:
So what's the AI supposed to do with all these scattered patterns (3)? Should it go through every single document, every Slack conversation, every code repository every time someone asks for something? That's not practical or efficient.


<!-- .slide: data-background="img/patterns-04.png" data-background-size="contain" data-background-color="black" -->

Note:
The solution is similar to what we did with capabilities. We need to identify the actual patterns first - and let me be clear, not everything is a pattern worth capturing. Then we create embeddings from those patterns (4)...


<!-- .slide: data-background="img/patterns-05.png" data-background-size="contain" data-background-color="black" -->

Note:
...and store them in a Vector database (5). The logic is exactly the same as with capabilities, but the sources of data are different.


<!-- .slide: data-background="img/patterns-06.png" data-background-size="contain" data-background-color="black" -->

Note:
Once the patterns are stored in a Vector database, AI agents can perform semantic search to find the patterns that match specific intents (6). Now instead of randomly guessing how to implement something, the AI can follow your organization's established patterns and best practices.

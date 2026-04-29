<!-- .slide: data-background-image="img/remediation/3am.png" data-background-size="contain" data-background-color="black" -->
<br/><br/><br/><br/><br/><br/><br/><br/><br/>
## [Viktor Farcic](http://technologyconversations.com/about/)

#### [@vfarcic](https://twitter.com/vfarcic) | [DevOps & AI Toolkit YouTube](https://youtube.com/c/devopstoolkit) | [Upbound](https://upbound.io)

Note:
It's 3 AM. Your phone buzzes. Production is down. A Pod won't start. You run `kubectl events`, wade through hundreds of normal events to find the one warning that matters, describe the Pod, check the ReplicaSet, trace back to the Deployment, realize a PersistentVolumeClaim is missing, write the YAML, apply it, validate the fix. Thirty minutes later, you're back in bed, wondering if there's a better way.

There is. What if AI could detect the issue, analyze the root cause, suggest a fix, and validate that it worked? What if all four phases happened automatically, or at least with your approval, while you stayed in bed?

I'm going to show you exactly how to do this with Kubernetes. First, we'll walk through the manual troubleshooting process so you understand what we're automating. Then I'll show you an AI-powered solution using Claude Code and the Model Context Protocol that handles detection, analysis, remediation, and validation. Finally, we'll look under the hood at how the system actually works.

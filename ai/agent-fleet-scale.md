## InMotion

> Open the laptop agent that set up InMotion.

```sh
dot-agent-deck connect inmotion
```

> `Ctrl+N` -> repository -> dispatcher

Note:
And the mini PC is out of room. If the team is going to grow, it needs more hardware, so I add a server in InMotion Cloud. I don't set it up myself either. I ask an agent on my laptop to do it, and it takes care of the rest.
Once it's ready, I connect to the InMotion server. There, I start another dispatcher, with its own queue of issues and room for more of them to work in parallel. I use the prompt the mini PC dispatcher prepared, because the mini PC is already working on other issues.


## More parallel work

> Paste the copied mini PC prompt, then add:

```text
Keep 6 in parallel.
```

> Open the [pull requests](https://github.com/vfarcic/dot-agent-deck/pulls), then [PR #1702](https://github.com/vfarcic/dot-agent-deck/pull/1702) again.

Note:
I paste the prompt I got from the mini PC dispatcher and increase the concurrency. This machine has room for more work in parallel, but the workflow is the same. The skills already know how to dispatch the issues, check the results, and keep the team busy.
It fills all the available slots right away. Separate teams, in separate places, and neither knows the other exists. The only coordination between them is whatever I put in their prompts. Remember that. It'll matter.
In the earlier run, a few hours later, I opened GitHub. A bunch of open pull requests, most of them opened while I was away. Each of them went through the same process as the very first one. Take the one I showed earlier as an example. Qodo summarized it and reviewed it.
Review agents review, workflows validate, and then there's the approval agent, running in GitHub Actions. Its job is to confirm that everything is green and that every finding from the reviewers was resolved. Only then does it approve. The result is a pull request with the approval it needs and all the checks passing, waiting for someone to decide whether it goes in.

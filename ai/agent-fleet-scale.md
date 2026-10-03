## InMotion

```sh
dot-agent-deck connect inmotion
```

Note:
And the mini PC is out of room. If the team is going to grow, it needs more hardware, so I add a server in InMotion Cloud. I don't set it up myself either. I ask an agent on my laptop to do it, and it takes care of the rest.
**Presenter cue:** Open the laptop agent's completed setup of the InMotion host. Inspect the real setup session prepared before the talk, including its result and remote registration. Do not wait for provisioning on stage or create a second server just to replay the story. The point is additional capacity, not a comparison of hosting providers.
Once it's ready, I connect to the InMotion server. There, I start another dispatcher, with its own queue of issues and room for more of them to work in parallel. I use the prompt the mini PC dispatcher prepared, because the mini PC is already working on other issues.
**Presenter cue:** Connect to the prepared InMotion environment. Press Ctrl+N, select the repository, and choose dispatcher mode. inmotion is the remote name prepared for this demo. The repository and committed base branch on this host must match the intended work; each host has its own checkout and dispatcher.


## More parallel work

**Paste** the copied mini PC prompt, then add:

```text
Keep 6 in parallel.
```

Note:
I paste the prompt I got from the mini PC dispatcher and increase the concurrency. This machine has room for more work in parallel, but the workflow is the same. The skills already know how to dispatch the issues, check the results, and keep the team busy.
It fills all the available slots right away. Separate teams, in separate places, and neither knows the other exists. The only coordination between them is whatever I put in their prompts. Remember that. It'll matter.
**Presenter cue:** Paste the handoff prompt from the mini PC into the InMotion dispatcher and add the displayed concurrency line before submitting. The cap is six work units, not individual agent processes. Confirm that the handed-off issues are different from the mini PC's active batch and inspect the spawned work. The other workflow instructions are already encoded in skills.
In the earlier run, a few hours later, I opened GitHub. A bunch of open pull requests, most of them opened while I was away. Each of them went through the same process as the very first one. Take that first pull request as an example. Qodo summarized it and reviewed it.
**Presenter cue:** Open the repository's pull requests, including work completed earlier. Describe the amount of work without quoting a fixed total. Open the prepared reviewed PR in the browser for the next beat.
Review agents review, workflows validate, and then there's the approval agent, running in GitHub Actions. Its job is to confirm that everything is green and that every finding from the reviewers was resolved. Only then does it approve. The result is a pull request with the approval it needs and all the checks passing, waiting for someone to decide whether it goes in.
**Presenter cue:** Copy the PR URL from the agent's output and open it in the browser. Inspect the reviewer findings, fixes, and approval workflow. Use a PR where the approval workflow really ran. Show the Actions run, resolved findings, checks, and approval separately; an approval on its own is not proof that all checks passed. Say explicitly that this is earlier completed work if the live batch is still running.

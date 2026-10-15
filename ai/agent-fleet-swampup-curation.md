## Guarded dependencies

```sh
cd ../dot-agent-deck-jfrog

claude --permission-mode auto
```

```text
The desktop app does not build. Fix it in this worktree.
```

> Open the [Curation audit](https://devreleplus.jfrog.io/ui/package-curation/audit)

Note:
There's one thing that pipeline doesn't see. It reviews what the agent wrote. It doesn't review what the agent pulled in on the way there. In auto mode, the agent no longer asks me before it installs a package, and by the time a pull request exists, that package was already downloaded and its install scripts already ran on my machine. Back when I approved every command, at least in theory I was the one checking that. In practice, I was saying "yes" to that too.
And agents love old versions. They learned from code written years ago, and the versions they remember are often the ones with known vulnerabilities. This branch has exactly that: an update checker someone ported from an old project, together with the axios version that project pinned. Good instructions don't help much if the code the agent starts from already asks for a vulnerable package.
So my agents don't talk to public registries directly. Every package goes through Artifactory, and JFrog Curation decides whether it gets in at all. Watch what happens when the agent installs the dependencies. The registry refuses. Not after the fact, in a scan of a pull request, but before a single byte of that package lands on the machine.
And the agent deals with it the way it deals with a failing test. It reads the error, which even tells it which versions fix those CVEs, upgrades to one the policy allows, and carries on. I didn't have to step in. That's the same kind of trust as before, just one layer lower. Instructions tell the agent how to work. The pipeline checks what it produced. And the registry decides what it's allowed to touch in the first place. Auto mode is only as safe as what the agent can reach.

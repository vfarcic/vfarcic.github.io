## Guarded dependencies

```sh
cd ../dot-agent-deck-jfrog

claude --permission-mode auto
```

```text
The desktop app does not build. Fix it.
```

Note:
There's one thing that pipeline doesn't see. It reviews what the agent wrote. It doesn't review what the agent pulled in on the way there. In auto mode, the agent no longer asks me before it installs a package, and by the time a pull request exists, that package was already downloaded and its install scripts already ran on my machine. Back when I approved every command, at least in theory I was the one checking that. In practice, I was saying "yes" to that too.
*From the dot-agent-deck checkout on the laptop, enter the demo/jfrog-curation worktree prepared in setup and start Claude Code in auto mode. If the agent asks whether to use a worktree or a branch, choose a branch, so the work stays on top of demo/jfrog-curation.*
And agents love old versions. They learned from code written years ago, and the versions they remember are often the ones with known vulnerabilities. This branch has exactly that: an update checker someone ported from an old project, together with the axios version that project pinned. Good instructions don't help much if the code the agent starts from already asks for a vulnerable package.
So my agents don't talk to public registries directly. Every package goes through Artifactory, and JFrog Curation decides whether it gets in at all. Watch what happens when the agent installs the dependencies. The registry refuses. Not after the fact, in a scan of a pull request, but before a single byte of that package lands on the machine.
*Show the agent's pnpm install failing with the 403 for axios 0.21.1 and the CVEs Curation lists. Then open the Curation audit (https://devreleplus.jfrog.io/ui/package-curation/audit) and show the block_vulnerable_packages policy that refused it.*
And the agent deals with it the way it deals with a failing test. It reads the error, which even tells it which versions fix those CVEs, upgrades to one the policy allows, and carries on. I didn't have to step in. That's the same kind of trust as before, just one layer lower. Instructions tell the agent how to work. The pipeline checks what it produced. And the registry decides what it's allowed to touch in the first place. Auto mode is only as safe as what the agent can reach.
*Show the agent upgrading axios, or replacing it, and the build passing. If it stalls or asks for help, describe the block and move on; the refused install is the point of this beat.*

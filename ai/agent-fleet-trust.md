## Single-agent work

```sh
claude --permission-mode manual
```

```text
Pick an issue, create a worktree, and fix it.
```

> Approve a few requests, then switch to auto mode.

> Open [PR #1702](https://github.com/vfarcic/dot-agent-deck/pull/1702)

Note:
Back then, it was a team of one. One agent, and me watching every move it makes. It's in manual mode, which means it can't do much of anything without asking me first.
I tell it to pick an issue and fix it in its own worktree, and before it has even looked at the issues, it stops and asks whether it's allowed to run gh issue list. That's how it goes with a team member I don't trust yet. I approve this, then the next thing, then the one after that. The work gets done, but all of my attention goes into babysitting a single agent, so the team can't grow beyond one. There's nobody left to manage the others.
Trust changes that. At some point, my skills and the rest of the agent's instructions became reliable enough that I noticed I was saying "yes" to almost everything it asked. Once approving turns into a reflex, it's no longer oversight. It's just me slowing the agent down. So I switch it to auto mode, and it stops asking about every command. It creates a worktree, loads the skill that tells it to reproduce a bug before fixing it, and carries on without me. That's the moment a manager stops supervising and starts delegating.
When an agent opens a pull request, like this one from an earlier issue, that kicks off everything I'd expect around a change made by anyone on a team. Workflows built and tested it on Linux, macOS and Windows, and ran the security checks. Review bots, Greptile and Qodo, went through the code over several rounds, and every time they found something, the agent fixed it and pushed again. By the time it comes back to me, all the required checks are green and no review thread is left open. My job comes down to delegating the work and judging the outcome. If something is off, I tell it what to change. That's the other half of trust. Good instructions make the agent reliable, and the pipeline catches whatever still slips through.

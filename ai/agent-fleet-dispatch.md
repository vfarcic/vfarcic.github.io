## Mini PC

```sh
dot-agent-deck connect mini-pc
```

Note:
Once agents can work without me hovering over them, the size of the team is no longer limited by my attention. My job shifts to handing out work, and one agent in one terminal isn't enough for that anymore. That's where Agent Deck comes in, an open-source terminal app I built for running and managing many coding agents at once, whether that's Claude Code, Codex, OpenCode, or others. In it, I start a dispatcher, an agent whose only job is to take work and delegate it to other agents.
**Presenter cue:** Connect to the mini PC, press Ctrl+N, select the repository, and choose dispatcher mode. mini-pc is a registered remote name, not a built-in default. Use the name prepared for the talk. Start the dispatcher from a committed default-branch checkout with the team's configuration already in place.


## Pick an issue

```text
Pick an issue to work on.
```

Note:
The simplest version is one issue per agent. I ask the dispatcher to pick an issue. It spins up an agent for that issue, in its own worktree cut from main, so it can't step on other agents' toes.
**Presenter cue:** Type the prompt and let the dispatcher choose an issue using the existing skills. The deck's worktrees come from the dispatcher's current committed checkout; use main here only if that is the repository's prepared base branch. Confirm the spawned-worktree report and that the task reached its agent, not just that dispatch returned successfully.
The work happens in an isolated copy of the repository, so this agent's edits don't interfere with other agents' working directories. I can open its pane and see what it's doing without taking over the others.
**Presenter cue:** Open the worker's pane and inspect its working directory and branch while explaining isolation. Stay in the live demo; no separate worktree-command slide is needed.


## Pick a PRD

```text
Pick a PRD to work on.
```

Note:
Not everything fits a single agent, though. For something bigger, like a PRD, I ask the dispatcher to hand the work to a whole team instead. An orchestrator coordinates a coder, a reviewer, an auditor, a tester and a release agent, each with its own role. They're not even the same agents. Claude Code, Codex, OpenCode and Pi all work on the same PRD, and they're not running the same models either. Some models are better than others at certain tasks, and some are cheaper while still being more than capable of doing a specific job, so each role gets whatever fits it best.
**Presenter cue:** Type the prompt and let the dispatcher select a PRD using the existing skills and configured team. Open the orchestration's panes and identify their actual roles, agents, and models. If the configuration differs from the manuscript, match the narration to it. Remove the video's cross-promotion rather than interrupting the live demo.


## Detach and reconnect

**Detach:** `Ctrl+D` -> `Ctrl+C` -> `Detach`

```sh
dot-agent-deck connect mini-pc
```

Note:
All of that runs on a dedicated machine, the mini PC in my office, not on my laptop. My laptop holds plenty of things agents have no business seeing, and it goes to sleep whenever I close the lid. When I was micromanaging a single agent, that didn't matter, since I had to be there anyway. Now that I'm not, there's no point keeping my laptop awake just so agents can work. Which means that, once the work is handed out, I can walk away. I detach, the agents keep running on the mini PC, and I go do something else.
**Presenter cue:** Press Ctrl+D for command mode, then Ctrl+C. Choose Detach, reconnect using the command, and show that the agents are still running. Choose Detach rather than Stop; Stop shuts the daemon and agents down. The reconnect is a quick live proof, not a claim that the tasks have already finished.
Here's a batch I handed out earlier. All the units are done. A bunch of pull requests, each with a short list of what's still needed before it can be merged: a review, a couple of checks the agents couldn't run on that box, and my go-ahead. From here, I can dig into any of them, approve, or send it back with corrections.
**Presenter cue:** Open the dispatcher session from an earlier completed batch and inspect its completion reports and linked pull requests. This is a real prepared checkpoint, not the issues and PRD just launched. Inspect the actual remaining work and adjust the examples if everything has already passed.
There's a problem with that picture, though. Some of those agents finished hours ago. This one worked for hours and then just sat there, waiting for me. Agents should be working all the time, as many of them as the machine they're on can handle, not waiting for me to show up with the next task. A manager who hands out one task at a time and then disappears ends up with a team that spends most of its day waiting.
**Presenter cue:** Show when an earlier worker finished and when you returned. The point is the delay between finishing and getting the next task; describe it in relative terms rather than quoting a fixed duration.


## Keep the team busy

```text
Pick 20 issues to work on.
Keep 3 in parallel.
```

Note:
So, instead of handing out work a few items at a time, I let the dispatcher keep picking issues. A bunch more work. Its skills already tell it how to dispatch the work, check the results, and keep the queue moving. It decides whether each issue gets a single agent or a whole team, and it keeps a few of them working in parallel.
**Presenter cue:** Type the prompt and let the dispatcher choose the issues. The concurrency is three work units, including already-running work, not necessarily three agent processes. Selection, dispatch, PR checks, and replenishment are already encoded in skills and do not need to be repeated in the prompt. This is a standing instruction to this dispatcher, not a built-in cross-machine scheduler.
It fills the available slots right away, and when one of them finishes, the dispatcher checks its pull request and sends out the next one. Why limit it? Because I want the team busy without pushing the mini PC past what it can handle. A team can only be as big as the environment it works in.
**Presenter cue:** Inspect the active units and the pending queue. Show a completed unit reporting back and the next one starting. Count already-running units against the cap. If none finishes during this segment, open the prepared queue dispatcher and inspect its real completion-and-refill conversation; identify that session as an earlier run.


## Prepare a handoff

```text
Pick another 20 issues to work on without dispatching.
I need a prompt I can copy and paste into a different deck.
```

**Copy:** the prompt returned by the dispatcher.

Note:
I also ask it to prepare work for another deck. Not to run it here, just to pick another batch and give me a prompt I can take with me. That way I don't have to choose the next issues by hand. The work already running on the mini PC keeps going, and I have another batch ready for a different machine.
**Presenter cue:** Submit this to the mini PC dispatcher. Copy the returned prompt from its output and keep it ready for the other deck. These newly selected issues should not be dispatched on the mini PC.

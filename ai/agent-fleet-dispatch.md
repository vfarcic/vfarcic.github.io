## Mini PC

```sh
dot-agent-deck connect mini-pc
```

> `Ctrl+N` -> repository -> dispatcher

Note:
Once agents can work without me hovering over them, the size of the team is no longer limited by my attention. My job shifts to handing out work, and one agent in one terminal isn't enough for that anymore. That's where Agent Deck comes in, an open-source terminal app I built for running and managing many coding agents at once, whether that's Claude Code, Codex, OpenCode, or others. In it, I start a dispatcher, an agent whose only job is to take work and delegate it to other agents.


## Pick an issue

```text
Pick an issue to work on.
```

> Open the worker's pane.

Note:
The simplest version is one issue per agent. I ask the dispatcher to pick an issue. It spins up an agent for that issue, in its own worktree cut from main, so it can't step on other agents' toes.
The work happens in an isolated copy of the repository, so this agent's edits don't interfere with other agents' working directories. I can open its pane and see what it's doing without taking over the others.


## Pick a PRD

```text
Pick a PRD to work on.
```

> Open the orchestration's panes.

Note:
Not everything fits a single agent, though. For something bigger, like a PRD, I ask the dispatcher to hand the work to a whole team instead. An orchestrator coordinates a coder, a reviewer, an auditor, a tester and a release agent, each with its own role. They're not even the same agents. Claude Code, Codex, OpenCode and Pi all work on the same PRD, and they're not running the same models either. Some models are better than others at certain tasks, and some are cheaper while still being more than capable of doing a specific job, so each role gets whatever fits it best.


## Detach and reconnect

> Detach: `Ctrl+D` -> `Ctrl+C` -> `Detach`

```sh
dot-agent-deck connect mini-pc
```

> Open the dispatcher of an earlier, completed batch.

Note:
All of that runs on a dedicated machine, the mini PC in my office, not on my laptop. My laptop holds plenty of things agents have no business seeing, and it goes to sleep whenever I close the lid. When I was micromanaging a single agent, that didn't matter, since I had to be there anyway. Now that I'm not, there's no point keeping my laptop awake just so agents can work. Which means that, once the work is handed out, I can walk away. I detach, the agents keep running on the mini PC, and I go do something else.
Here's a batch I handed out earlier. All the units are done. A bunch of pull requests, each with a short list of what's still needed before it can be merged: a review, a couple of checks the agents couldn't run on that box, and my go-ahead. From here, I can dig into any of them, approve, or send it back with corrections.
There's a problem with that picture, though. Some of those agents finished hours ago. This one worked for hours and then just sat there, waiting for me. Agents should be working all the time, as many of them as the machine they're on can handle, not waiting for me to show up with the next task. A manager who hands out one task at a time and then disappears ends up with a team that spends most of its day waiting.


## Keep the team busy

```text
Pick 20 issues to work on.
Keep 3 in parallel.
```

> Watch a unit finish and the next one start.

Note:
So, instead of handing out work a few items at a time, I let the dispatcher keep picking issues. A bunch more work. Its skills already tell it how to dispatch the work, check the results, and keep the queue moving. It decides whether each issue gets a single agent or a whole team, and it keeps a few of them working in parallel.
It fills the available slots right away, and when one of them finishes, the dispatcher checks its pull request and sends out the next one. Why limit it? Because I want the team busy without pushing the mini PC past what it can handle. A team can only be as big as the environment it works in.


## Prepare a handoff

```text
Pick another 20 issues to work on without dispatching.
I need a prompt I can copy and paste into a different deck.
```

> Copy the prompt the dispatcher returns.

Note:
I also ask it to prepare work for another deck. Not to run it here, just to pick another batch and give me a prompt I can take with me. That way I don't have to choose the next issues by hand. The work already running on the mini PC keeps going, and I have another batch ready for a different machine.

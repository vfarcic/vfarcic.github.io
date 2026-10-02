# Your Agents Scale. You Don't. From Babysitting One Agent to Managing a Fleet

Running one coding agent is easy. Running forty-five across a laptop, a mini PC, and a cloud server changes your job. You're no longer the person writing the code. You're the manager delegating work, resolving conflicts, and removing obstacles. The agents can produce weeks of work in hours. But can you keep up?

This talk follows the evolution of my own agent fleet, starting with a single agent that needed permission for every command. Better instructions, automated tests, and independent code reviews made it possible to stop supervising every action and start judging outcomes. That opened the door to dispatchers assigning issues to agents in isolated Git worktrees, specialist teams tackling larger changes, and queues keeping the workers busy without overwhelming their machines. When one machine ran out of room, the fleet spread to another.

Each step solved one problem and exposed the next. More agents meant more work getting done, but also more places to look for questions, completed tasks, and stalled progress. Using the open-source Agent Deck, we'll explore how a unified view brings distributed agents together while preserving their native terminal sessions. Then comes the harder part: pull requests pile up, merges create conflicts, and independent dispatchers don't know what the other teams are doing. Once you can see the whole fleet, the next bottleneck is you.

Attendees will leave with a practical progression for growing beyond a single agent, an understanding of what limits each stage, and a clearer picture of where human attention still matters when agents do the implementation.

## Short Abstract

What changes when one coding agent becomes forty-five across three machines? Your job. This talk follows the evolution from approving every command to delegating work through dispatchers, isolated Git worktrees, specialist teams, and continuously replenished queues. Using the open-source Agent Deck, we'll explore fleet-wide visibility without replacing the agents' native interfaces, then confront the bottlenecks that remain: review capacity, merge conflicts, and coordination between machines. Agents can produce weeks of work in hours. Managing that output is a different problem. Learn what enables each stage of growth, and why your attention becomes the next scaling limit.

## Key takeaways:

* How reliable instructions and automated validation let you move from approving actions to judging outcomes
* How dispatchers, isolated Git worktrees, and specialist teams enable parallel agent work
* Why work queues and concurrency limits matter as much as the number of agents
* How fleet-wide visibility helps you find and unblock agents across machines while preserving their native workflows
* Why review capacity, merge conflicts, and cross-machine coordination become the next bottlenecks

## Open Source Projects Used

- Agent Deck
- Git
- OpenCode
- Pi

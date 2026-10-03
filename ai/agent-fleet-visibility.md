## What did I miss?

Note:
And that's where it starts breaking down. Not the agents, and not the hardware. Visibility. Seeing what one team does on one machine works fine. I open Agent Deck, there's the list of agents, and I can tell who's working, who's done, and who's waiting for me. But now I have a team on the mini PC, another one in InMotion, and a few agents on my laptop, and each of them knows only about itself. Every machine is a separate tab in my terminal, and I jump between them hoping I didn't miss the one that needed an answer an hour ago. That falls apart after a couple of machines. The more the fleet grows, the less of it I can see, and I can't delegate, unblock, or review what I can't see. A manager with teams in several offices needs one place to see all of them, and a way to reach any one of them when it needs attention.
**Presenter cue:** Switch between the laptop, mini PC, and cloud terminal tabs. Find an agent that needs attention. Have one real session waiting for input and one completed session ready for review. Do not spend time searching randomly; use the prepared examples to make the visibility problem concrete.


## One fleet view

Note:
That's why I built the desktop version of Agent Deck. When I'm focused on one agent and working through something with it in depth, the terminal is still where I want to be. But when the question is what's going on with the whole fleet, I want one app that brings all of it together. Here it is. The whole bunch of agents I mentioned at the start, all the machines, in one place. The first group is my laptop, with the few agents I use for investigation.
**Presenter cue:** Open Agent Deck Desktop with all the environments connected. Show the fleet overview, then the laptop group. Point out the mix of active and completed work without quoting fixed counts. Desktop connects to daemons already running on the remote hosts.


## Done
### or
## Needs input

Note:
Below it is the mini PC. Waiting doesn't mean stuck. Those agents finished their work and are waiting for me to review what they did. An agent with a question for me would show up differently, as waiting for input. Either way, they need me, and this is where I find out.
**Presenter cue:** Expand the mini PC group. Compare completed work with a session waiting for input. Use the actual status labels in the installed version. Describe activity in relative terms, and open the relevant report or question to establish why the agent needs attention.


## Another machine
### Same view

Note:
Scroll further down and there's the InMotion server, with its own agents. I can see who's running and who's waiting, without opening another terminal tab. The machines still have their own teams, but now I have one place to find out which team needs me.
**Presenter cue:** Expand the InMotion group and inspect its active agents. Pick a remote agent that needs your attention. Describe the activity without quoting a fixed headcount, and select the prepared question or completed report.


## Native agent session

```text
/help
```

Note:
When I want to work with one of them, I open it. This is the part I care about the most. What's in that terminal is the agent itself. It's the real Claude Code session, the same one I'd get if I connected to that machine from a terminal, reached over SSH through the Agent Deck daemon on that box. The app doesn't put its own interface between me and the agent. Slash commands, skills, hooks, keybindings, everything I've invested in works exactly the way it always does.
**Presenter cue:** Open the remote agent's terminal inside the desktop app and answer its question. Use a Claude Code session for this wording. Then type /help in the agent terminal and show a native command, installed skill, or keybinding you normally use. Close the help overlay using the agent's controls before returning to the fleet. Do not answer through a wrapper control while explaining the native session.


## One fleet view
### Real agent sessions

Note:
That distinction matters. I don't want tools that wrap agents in their own UI. Claude Code, Codex, OpenCode and the rest ship improvements every week, and a wrapper is always a step behind them. What agents don't give me is an overview of every agent on every machine, so that's what a central app should do. The conversation itself is something agents already do better than anyone, so the app should take me to the real thing and get out of the way. If you think you can do better, build a better agent, not a wrapper around someone else's.

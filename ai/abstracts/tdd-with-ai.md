# I Haven't Read My Code in Months: Test-Driven Development in the Age of Agents

I let a crew of agents write a whole feature on their own, and then I confirm it works in a few seconds without reading a single line of the code they produced. That's not recklessness. It's Test-Driven Development, pushed to an altitude I never thought I'd reach.

I've written tests first for most of my career. For me it was never about the safety net. Writing the test first forced me to think about the problem before touching the solution. Think, red, green, repeat. When agentic AI showed up, I did the obvious thing: my pair was now the agent. I wrote a test, it wrote the code to make it pass. Same loop, different partner. And the test turned out to matter more to the agent than it ever did to me, because a test is an objective function — a fixed target a machine can check. Take it away, hand an agent a vague goal, and it does what they all do: it declares victory early, drifts off course, and tells you it's done when it isn't.

So I kept climbing. Instead of bouncing one test at a time, I now write a detailed PRD and let a whole crew of specialized agents rip through it — an orchestrator, a tester, a coder, reviewers, and a release agent. The test-first loop is still the engine underneath, just without me holding the pen. And that raises the obvious objection: if an agent writes the tests and an agent writes the code, what stops the whole thing from being a sham? Trivially-true tests, code-first-then-bless-it, deleting the red to force green — if you've used these agents for more than a day, you've seen all three.

This talk is the answer to that objection, demonstrated live. The tester writes the critical failing tests and is forbidden from writing production code; a separate coder makes them pass, so the one with a motive to cheat never defines what passing means. The critical tests trace straight back to the PRD and I approve them myself before any code is written, so the agents can't move the goalposts. And those tests are black-box — spec by example, readable by me and by the model — so they can't be faked by tailoring code to the test. Along the way I'll show why this **inverts the testing pyramid**: coarse behavior tests used to be painful because a tired human had to hunt down what broke, but an agent will re-run, bisect, and dig through logs at basically zero cost, so the math flips and the pyramid flips with it.

Then I'll show the payoff. There are only two moments in the whole process that need me. At the start, I approve the plan. At the end, the agents record the critical tests as they actually run, assemble them into a short demo reel, and stop — refusing to merge until I watch it and give the go-ahead. What used to be slow, hands-on validation becomes a few seconds of video. The spec, the test, and the demo become the same artifact.

## Short Abstract

I let a crew of agents write entire features on their own, then confirm the work in seconds without reading a line of the code. This talk shows how, through Test-Driven Development pushed to its limit. The test-first loop is still the engine, but agents hold the pen: a tester writes critical, black-box, failing tests traced back to a PRD I approve up front, and a separate coder makes them pass — so the agent with a motive to cheat never defines what "done" means. I'll demonstrate the whole pipeline live, explain why agents flip the testing pyramid upside down, and show the final trick: the agents record the critical tests as they run and hand me a short demo reel, refusing to merge until I've watched it. Two gates for me, total autonomy in between.

## Key takeaways:

* Why a test is the objective function an agent needs, and what agents do when you take it away
* How to keep agents honest when they write both the tests and the code: separation of duties, PRD-traced tests, and human-approved contracts
* Why black-box, behavior-level tests are the right guarantee when nobody reads the low-level code anymore
* Why agentic AI inverts the testing pyramid — behavior-first, top-heavy — and why the usual "double down on unit tests" advice misses who pays the bill now
* How a multi-agent setup (orchestrator, tester, coder, reviewers, release) turns a PRD into a merged pull request with only two human gates
* How to turn critical tests into recorded demo reels so validating an agent's work becomes watching a short video instead of reading code

# Agent Fleet (SwampUp): Presenter Preparation

Presenter-only guide for `agent-fleet-swampup.html`, the SwampUp variant of `agent-fleet.html`. It adds a laptop setup section after the cover (`agent-fleet-swampup-setup.md`), a JFrog Curation section between Trust and Dispatch (`agent-fleet-swampup-curation.md`), and a cleanup section after the closing (`agent-fleet-swampup-cleanup.md`); everything else matches the original deck. The deck is a hands-on demonstration, not a screenshot walkthrough. Speaker notes use `../devops-catalog/manuscript/development/agent-fleet.md` as their backbone; presenter cues identify the small adaptations needed for a live session.

## Before the talk

Prepare the laptop, mini PC, and InMotion host with authenticated agents, GitHub access, Agent Deck, and the repositories used in the manuscript. The terminal executable is `dot-agent-deck`, not `agent-deck`. Agent Deck Desktop needs access to daemons already running on each host.

This presentation intentionally depends on the presenter's machines, repositories, issues, skills, and pipeline. There is no claim that another person can replay those exact IDs. Attendees can reproduce the pattern with their own issues and one agent, then add a dispatcher and more machines.

### Reserve the live work

Set `DEMO_REPO` in the laptop terminal used for the preparation commands to the actual `owner/repository`. Choose and substitute the demo values before presenting:

| Demo value | What to prepare |
|---|---|
| `$DEMO_REPO` | GitHub `owner/repository` with the demonstrated issue-to-PR pipeline |
| `mini-pc` | Registered remote name for the dedicated office machine |
| `inmotion` | Registered remote name for the cloud machine |
| `<single-issue>` | Small reproducible bug for the manual-to-auto agent |

The mini PC dispatcher chooses its own issue, PRD, and further issues through the existing skills. Ensure the repository has eligible work and that the selection and execution skills are available. Its queue prompt picks 20 issues with concurrency 3. The InMotion dispatcher uses the copied handoff prompt with concurrency 6; rehearse each cap on its host. Before submitting the handoff, compare its issue list with the mini PC's active work so the assignments do not overlap. Narrate the scale in relative terms rather than quoting fixed headcounts; the displayed numbers set the demo's batch size and concurrency.

At the end of the mini PC segment, ask that dispatcher to pick another 20 issues without dispatching them and return a prompt for a different deck. Copy its output for the next environment; this handoff is manual, while the already-dispatched mini PC work continues.

In the InMotion dispatcher, paste that returned prompt and append `Keep 6 in parallel.` before submitting. The installed skills supply the rest of the workflow. During PR inspection, copy the URL from the agent's output directly into the browser rather than using a separate command slide.

From the laptop:

```sh
dot-agent-deck remote list
dot-agent-deck remote doctor mini-pc
dot-agent-deck remote doctor inmotion
gh issue list --repo "$DEMO_REPO" --state open --limit 100
gh pr list --repo "$DEMO_REPO" --state open --limit 50
```

Before dispatching, each host's source checkout must be at the intended committed base branch, with `.dot-agent-deck.toml`, the PRD, `AGENTS.md`, and skills available to the agents. Worktrees are cut from the dispatcher's current committed checkout, not automatically from `main`. The manuscript's repository uses `main`; adjust that spoken branch name if demonstrating a different repository.

Create a dispatcher with `Ctrl+N`, select the project directory, select `dispatcher` in the Mode field, and use your configured agent command. Confirm the project offers both a single agent and the intended specialist orchestration. Use the configuration already used for your work; this talk does not teach how to build it.

### Prepare JFrog Curation

The Curation beat runs on the laptop, in Claude Code started in auto mode, before the talk moves to remote machines. Everything it needs is on the `demo/jfrog-curation` branch of dot-agent-deck, which must never be merged:

- `desktop/.npmrc` routes npm and pnpm through `https://devreleplus.jfrog.io/artifactory/api/npm/dot/`, a remote repository proxying npmjs.org with Curation enabled. Only checkouts of this branch use JFrog; `main` and every other checkout keep using the public registry.
- `desktop/src/lib/updateChecker.ts` is "ported from an old project" and imports axios. `desktop/package.json` and `pnpm-lock.yaml` pin `axios@0.21.1`, which the organization-wide `block_vulnerable_packages` policy (CVSS 7.0 to 8.9) refuses with a 403 that lists the CVEs and the fixed versions.
- The branch is cut from a `main` commit dated 2026-10-10, with vite 8.3.3. Its frozen lockfile only grows older, so the organization-wide 2-day `block_immature` policy never applies to it. Do not rebase or update the branch; a newer lockfile can reintroduce blocked versions.

The JFrog token lives in Google Secret Manager as `jfrog-token` and is referenced as `JFROG_TOKEN` in dot-agent-deck's `.env.vals.yaml`. pnpm does not expand environment variables in a committed project `.npmrc`, so setup writes the token to the user-level `~/.npmrc`. That entry only authenticates requests to devreleplus; it does not change which registry other checkouts use.

1. **Run the setup slides.** Open `/ai/agent-fleet-swampup.html#/setup` and execute them on the laptop: clone or update dot-agent-deck, add the `../dot-agent-deck-jfrog` worktree, and store the token. If the worktree exists from a rehearsal, run the cleanup slide first.
2. **Verify the block.** In `../dot-agent-deck-jfrog/desktop`, `pnpm install` must fail with `ERR_PNPM_FETCH_403` for `axios-0.21.1.tgz`. Then reset with `git checkout .` and `rm -rf node_modules`.
3. **Rehearse.** Start `claude --permission-mode auto` in the worktree, give it the slide's prompt, and confirm it hits the 403, upgrades or replaces axios, and gets the build passing. Check that the block appears in the Curation audit. Then run the cleanup slide (`/ai/agent-fleet-swampup.html#/cleanup-jfrog`) on the laptop. It removes the demo worktree, resets the local `demo/jfrog-curation` branch to the pushed one, and removes the JFrog token from `~/.npmrc`. Close any pull request the agent opened from the demo without merging it, and delete its branch.
4. **If the block disappears.** Check that `block_vulnerable_packages` is still enabled on devreleplus and still applies to `dot`, and that `dot` is still curated. Do not move the pin to a newer axios: every axios version up to 1.7.9 was also blocked on 2026-10-12, so the planted version is not the fragile part.

Artifactory caches npm metadata for two hours. If a Curation policy changes, resolution can see the old filtered metadata until the cache expires, which can make the agent's upgrade fail with "No matching version found" for unrelated packages. Leave policies unchanged in the hours before the talk.

Keep the JFrog Platform open on the Curation audit view (https://devreleplus.jfrog.io/ui/package-curation/audit), signed in, so the blocked request can be opened right after the agent hits it.

### Prepare real checkpoints

Agent work takes hours. Start small work live, let it run while you continue presenting, and inspect earlier completed work when the next beat requires a result. Say which is which. Do not wait on stage for a fresh PR or present earlier results as newly generated output.

Keep these real, inspectable checkpoints open or easy to reach:

1. A manual-mode session whose first useful command asks for permission. Existing allow rules can suppress the request; rehearse the actual installed permission controls.
2. An auto-mode session showing the reproduction skill and isolated worktree, in case live setup is slow.
3. A completed agent session whose output includes the PR URL, with the demonstrated platform tests, security checks, review findings, fixes, and resolved threads. Copy that URL directly into the browser during the trust demo. If the PR does not have Greptile, Qodo, and repeated review rounds, adjust those specific notes.
4. An earlier dispatcher with completed units and their PRs, including a report showing the delay before the next assignment.
5. A queue dispatcher whose transcript shows completion, PR inspection, and the next unit starting. This demonstrates slot refill without waiting for a long task.
6. The laptop agent's completed setup of the cloud host. Inspect its actions and result rather than provisioning a new server during the talk.
7. A PR with the approval-agent GitHub Actions run and all required checks passing.
8. A remote agent genuinely waiting for an answer, and a different completed agent waiting for review. These should be distinguishable in the desktop app.
9. A rehearsed Curation session on `demo/jfrog-curation` showing the blocked install and the agent's recovery, in case the live agent stalls.

Use the fleet's current status labels and describe its scale in relative terms: a bunch of agents, several machines, some working, and others waiting. Do not tie the narration to a snapshot's exact totals. Distinguish completed work from an agent blocked on a question.

Keep the native Claude Code terminal available for the `/help` demo and a familiar installed skill or keybinding. Confirm the native interface, remote connection, and input all work inside Desktop before the talk.

## On stage

| Section | Execute live | Inspect earlier work when necessary |
|---|---|---|
| Trust | Start the reserved issue, approve a command, switch to the configured auto mode, and open the PR URL from the agent's output | Reproduction/worktree milestone and completed validation PR |
| Curation | Start Claude Code in auto mode in the demo worktree, let the install fail on axios, open the Curation audit for the blocked package | Rehearsed blocked-install session and recovery |
| Dispatch | Let the dispatcher pick an issue and a PRD; detach and reconnect; start its capped batch; request an undispatched batch and copyable prompt for another deck | Completed batch, idle interval, and refill transcript |
| Scale | Connect to the prepared cloud host; paste the handoff prompt with concurrency 6; open PR URLs from agent output | Completed host setup, earlier PR list, approval-agent run |
| Visibility | Switch terminal tabs, open Desktop, distinguish completed work from requests for input, answer a remote question, use `/help` | Existing fleet sessions are the demonstration itself |
| Bottlenecks | Spoken wrap-up on the single illustrated closing slide | Recap the earlier demo, integration bottlenecks, and manual cross-machine handoff |

Commands are executed in a shell on the named machine. Fenced `text` blocks are typed into the indicated agent. The detach key sequence controls Agent Deck and is not an agent prompt. `gh` commands can run on the laptop with `$DEMO_REPO` set. Keep the prompts short: the installed skills already encode selection, isolated worktrees, specialist teams, PR checks, and queue replenishment.

Prose actions such as opening a session, pausing at a permission request, switching windows, and inspecting a result are in the speaker notes with a bold **Presenter cue:** label. Every command or prompt slide has a short context title. The handoff slides also explicitly show what to copy from the mini PC dispatcher and where to paste it on InMotion, alongside the requested detach key sequence.

The closing section combines the recap, remaining bottlenecks, coordination gap, and Agent Deck invitation into one image-only slide. Its monitor contains the real `site/static/img/orchestration-desktop-home.png` from the Agent Deck repository, showing a larger fleet, perspective-composited into a generated photograph. Use it as the closing illustration rather than another product walkthrough, and avoid narrating its screenshot counts as live results.

When detaching the TUI, press `Ctrl+D` to reach command mode, then `Ctrl+C` and choose **Detach**. **Stop** shuts down agents and the daemon. Reconnect with `dot-agent-deck connect <registered-name>`.

## After the demo

Review the real work launched on stage. Tell each dispatcher whether to finish its assigned queue or stop starting new units. Let active workers finish or give them explicit instructions, then review their PRs. Detaching the client is not stopping the work.

Preserve checkpoint sessions until the presentation has been reviewed. When a dispatched unit is done and its work is retained in Git/PRs, close it through Agent Deck's normal controls. Inspect leftover worktrees before reclaiming merged, clean, deck-created worktrees:

```sh
dot-agent-deck worktree list
dot-agent-deck worktree reclaim
```

Worktree reclamation does not delete branches. Do not manually remove active worktrees, and do not destroy the permanent remote hosts as presentation cleanup.

Then run the cleanup slide (`/ai/agent-fleet-swampup.html#/cleanup-jfrog`) on the laptop. It removes the demo worktree, resets the local `demo/jfrog-curation` branch to the pushed one, and removes the JFrog token from `~/.npmrc`. Close any pull request the agent opened from the demo without merging it, and delete its branch. The `jfrog-token` secret stays in GCP for the next talk.

## Review the slides locally

Serve this repository with its normal `docker-compose up` command, or an available static server, then open `/ai/agent-fleet-swampup.html`. Use the left/right arrows to step through the deck, `Esc` for the overview, and `s` for speaker notes. Comment using the section and slide number, or copy the current hash URL. The preparation guide is not loaded as a slide section.

For headless browser checks, `devbox run slides-browser` provisions pinned Playwright Chromium in the ignored `node_modules/.cache/ms-playwright` directory. It works without the ignored Motion Canvas scaffold or its generated package file. Set `PLAYWRIGHT_BROWSERS_PATH="$PWD/node_modules/.cache/ms-playwright"` when running a Playwright check from the repository root, and use the same Playwright version (1.61.1) as the setup command.

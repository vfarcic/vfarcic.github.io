---
name: "slides"
description: "Create or revise Reveal.js conference talks and presentations in this repository from manuscripts, outlines, or approved abstracts. Reuse HTML templates and manuscript-based speaker notes; preserve hands-on source material as live demos with executable presenter instructions. Default to slide-by-slide approval, but build a full draft when the user requests review in actual slides. Prefer images for conceptual slides and use the diagram skill for diagrams. Update talks.md using shared rules. Standalone abstracts and CFP submissions belong to the abstracts skill."
---

# Create Slides (Reveal.js talk)

Build a presentation the way this repo already does it. Slides are markdown loaded by a per-talk HTML file (Reveal.js, moon theme). The guiding principle is **minimal on-slide text — often none. The slide carries an image or a diagram; the words live in the speaker `Note:`.**

## Inputs (ask only for what you can't infer)

- **title**: the talk title (used in `<title>` and talks.md).
- **slug**: short kebab-case name; drives filenames (`<slug>.html`, `cover-<slug>.md`, `img/<slug>/…`).
- **topic**: the topic directory the talk belongs in (`ai`, `kubernetes`, `crossplane`, `idp`, …). Talks live one level deep, so asset paths are `../…`.
- **source**: the outline / bullets / notes the talk is built from. If it's already in the conversation, use it.
- **approved abstract** (optional): use its title, audience, and takeaways to guide the deck, reading the source for detail. A completed abstract is not a prerequisite for creating slides.
- **review mode**: default to one slide at a time; an explicit request to create the deck first and review it in actual slides selects full-draft review.
- **hands-on**: inherit this from the source. Material that demonstrates commands, agent prompts, or hands-on workflows becomes a hands-on talk unless the user explicitly asks otherwise.

## Workflow and existing work

Read the repository root's `CLAUDE.md` for the shared `talks.md` rules. Check for an existing deck, abstract, and catalog entry; reuse their topic and slug and preserve user edits. For an existing deck, inspect its loader and content and continue at the requested slide rather than recreating the scaffold.

Support either order: build slides when the user asks for a presentation; use the `abstracts` skill when the user asks for an abstract first or redirects the current work to an abstract. Pause slide creation during that review and resume when requested. An abstract-only request belongs to `abstracts` and does not need a deck scaffold.

For full-draft review, create the complete deck and check it renders before asking for feedback. Do not pause at the cover or after each slide in this mode. Give the user the browser URL, navigation keys, and notes shortcut so they can review the actual slides. Keep slide units small and identifiable so feedback can target an individual slide.

## Step 0 — Analyze existing slides FIRST

Conventions drift; do not build from memory. Read 2–3 recent decks in the same `topic` (their `.html` loader + a couple of content `.md` files) and `../docs/the-end.md`. Confirm: current separators, image-slide directive, how `Note:` is attached, cover style, image path convention. For a hands-on talk, also read their setup sections and check their position in the loaders; useful examples include `ai/infra-ai-dummies-setup.md`, `ai/idp-setup.md`, and `kubernetes/dbaas-setup.md`. Only then start.

## Step 1 — Scaffold from templates (never hand-write the loader)

Templates live in this skill's `templates/` directory. Copy, don't regenerate.

1. **HTML loader**: copy `templates/talk.html` → `<topic>/<slug>.html`. Replace `{{TITLE}}` with the title and `{{SLUG}}` with the slug. The cover section and `the-end` section are pre-wired; content sections get inserted at the `<!-- CONTENT-SECTIONS -->` marker as you add them.
2. **Cover**: copy `templates/cover.md` → `<topic>/cover-<slug>.md` and fill in the title lines (headings only — no body text).
3. **Image dir**: `mkdir -p <topic>/img/<slug>`.
4. **talks.md entry**: add or update the matching talk using the shared rules in the repository root's `CLAUDE.md`. Link the new loader; include an abstract link only if its file already exists. If an abstract-only entry exists, add the slide link to it in place.
5. In slide-by-slide mode, **pause** and show the user the cover before moving on. In full-draft mode, continue with the content.

## Step 2 — Build for the selected review mode

By default, create a single slide, show it to the user, and wait for explicit confirmation before creating the next one. When the user requests a complete draft to review in actual slides, build the whole draft without intermediate approval pauses. The user's chosen review sequence takes precedence over the default.

For each slide, pick the leanest type that works. See `templates/section.md` for copy-paste examples of every type.

### Slide types (in order of preference)
1. **Image only** — a single full-bleed background, nothing else on the slide:
   ```
   <!-- .slide: data-background="img/<slug>/NN-NN.png" data-background-size="contain" data-background-color="black" -->

   Note:
   Everything you'd say out loud goes here.
   ```
   This is the default. If you're tempted to put a sentence on the slide, put it in the note and find an image instead.
2. **Diagram sequence** — for anything structural (flows, architectures, build-ups). Produced as an **image sequence** via the `diagram` skill, then shown as consecutive image slides so advancing = animation. See "Diagrams" below.
3. **Bullets** — ONLY when there are genuinely must-remember points. 2–4 short fragments, never sentences. Explanation goes in the note.
4. **Headings** — for the cover and section dividers. Alternating `##`/`###`, no body.
5. **Demo cue** — for hands-on material, this is the primary slide type. Put shell commands in ```` ```sh ```` blocks and agent prompts in ```` ```text ```` blocks. Keep prose presenter actions (open, pause, approve, switch, inspect) in the speaker notes, not visible blockquotes. A demo beat without a command or prompt can use a short conceptual heading; do not leave an empty slide. Split long demos into short, executable beats.

### Hands-on talks

- Give every hands-on command or prompt slide a short context title, usually a few words, above its executable content. Add the heading to the existing slide so returning from the terminal restores the audience's context. Conceptual image-only slides do not need an extra title overlay.
- Convert the source's screen recordings and screenshot cues into live demo actions, not screenshot slides. Put what to open, pause at, switch, and inspect, plus the observable result to look for, under `Note:`. Display the commands or prompts to execute on the slide, with only essential conceptual headings.
- Keep a continuous demo on its entry or prompt slide, with intermediate actions and result explanations combined in that slide's notes. Add another visible slide only when it supplies a useful new command, prompt, or concept. If an agent outputs a PR URL, the presenter can open that URL directly; do not add a redundant PR-opening command slide.
- Keep agent prompts limited to the user's intent and meaningful overrides, such as concurrency. Do not restate workflows already encoded in installed skills (worktrees, PR checks, reporting, or replenishment). Prefer simple requests such as "Pick an issue to work on." when the skills supply the procedure. Explicitly requested key sequences or copy/paste instructions can appear on-screen; keep routine prose actions in notes. For a handoff, identify the agent's returned prompt as what to copy and the destination deck as where to paste it.
- Notes are already presenter-only. Do not prefix them with "Presenter cue:" or similar boilerplate. Use the manuscript's spoken prose as the main content, with occasional plain or italic execution instructions separated from the narration when helpful.
- Verify tool commands and shortcuts against local project docs or current official docs. Do not invent commands from a tool's display name. Distinguish shell commands from agent prompts.
- Make machine and repository context explicit. Put installation, authentication, remote registration, and environment-specific values in a presenter preparation guide when they would distract from the talk.
- Label placeholders and explain how to choose or substitute them before presenting. Avoid requiring actual issue IDs or host names before a draft can be written.
- Move slow environment provisioning, such as cluster creation and serving-stack installation, into pre-talk setup. On stage, inspect its manifests and actual outputs; do not replay infrastructure apply commands merely to suggest that prepared resources were just created. Keep the core demonstrated work, such as model deployment and replica scaling, live and asynchronous, with explanation between launch and inspection. Keep long blocking waits in the rehearsal guide rather than on the talk's command slides.
- If the core demo work itself takes longer than a talk can reasonably wait, start it live and inspect an honestly identified, previously completed checkpoint. Prepare real sessions and PRs, not screenshots or fabricated results. Do not attribute checkpoint output to work just launched on stage.
- Prefer relative wording for fleet scale, batch sizes, and elapsed work: "a bunch," "several," "a few," or "hours." Do not tie the narration to a manuscript snapshot's exact headcounts. Keep commands operational: use clearly documented placeholders for configurable numeric limits and substitute concrete values before execution. Preserve numbers needed for technical correctness, versions, or the talk's core structure, such as one issue per agent.
- Add missing required tools to `devbox.json` when the user requests it. Check availability first; do not add packages merely because they were considered and not used.

### Setup sections

Use the repository's compact, executable setup format, even when the presenter runs it before the talk. Setup is a way to reproduce the environment, not a separate presentation of its provisioning stages. See `templates/setup.md` and the existing setup decks above.

- Place setup after the cover (and any approved intro), before the live demo. Developing setup first does not mean moving it before the cover in the finished deck. Provide a direct setup URL for pre-talk execution and a cover URL for the audience.
- Start with the existing `../img/background/hands-on.jpg` divider, headed `## Hands-on Time` and `# Setup`. Follow with a few `## Setup` pages for repository access, prerequisites, and execution. Split only when the commands or prerequisites would not fit.
- Show the public demo repository's `git clone` URL, `cd` command, and `git pull` after entering the directory rather than assuming a sibling checkout or an absolute presenter path. Explain in notes that an existing checkout skips cloning and runs the update from its own directory. During local review of unpublished changes, use the current local checkout; do not imply a fresh remote clone contains those changes.
- Keep short prerequisites visible, including Docker, the standard Devbox video link and manual-tool alternative, and required cloud access where relevant. This is a setup-specific exception to the rule against visible prose demo instructions: attendees need the prerequisites to follow along. Keep presenter actions and detailed troubleshooting in notes or the preparation guide.
- Inspect and reuse the source manuscript's demo repository, filenames, setup entry point, and environment-loading convention. Update its manifests for current APIs rather than creating a parallel demo implementation. Prefer one setup entry point, usually `./dot.nu setup`, followed by `source .env` when setup actually creates that file. Do not expose internal setup stages as a list of user-facing commands. Use `devbox shell` and `chmod +x dot.nu` where appropriate.
- Follow the shared NuShell architecture: `dot.nu` is user-facing and sources topic helpers from `scripts/`. Treat `../nu-scripts` (https://github.com/vfarcic/nu-scripts) as the master repo: clone it if absent, otherwise check its working tree and pull updates without overwriting local work. Inspect its helpers before writing replacements. Update reusable logic there and copy the updated scripts into the demo's `scripts/`; keep project-specific orchestration and manifests in the demo repo. Check current versions and APIs, and add required NuShell tooling to Devbox with a compatible, specific version. The consumer must work without the master checkout at runtime.
- For alternative clouds, choose one provider in setup and export it for provider-specific manifest inspection. Keep the model/demo commands shared wherever possible. Record run ownership so destroy targets the selected cloud and any uniquely created project. Fresh Google demo runs should use unique project IDs; recovery should resume the recorded project rather than orphaning it by creating another.
- Keep the slide commands compact. Rehearsal, preflight details, reset procedures, timing measurements, and troubleshooting belong in the demo README or presenter guide rather than expanding setup into a multi-stage runbook. Include a brief check command if needed to establish that setup succeeded.
- Put a `## Destroy` section after the shared closing section, using one user-facing NuShell command such as `./dot.nu destroy`. Keep dependency-safe teardown and waiting inside the script so the local control plane stays running until cloud resources are removed. Explain any preparation-only actions in notes.
- Follow the user's requested review sequence. If they want setup validated first, complete that section and its runnable prerequisites before authoring the demo, then add intro, closing, and execution-window narration in the requested order.

### Content rules
- **ASCII-only punctuation.** The decks declare `data-charset="iso-8859-15"`, so em-dashes (`—`), curly quotes (`"` `'`), ellipses (`…`), and other non-ASCII characters render as mojibake (e.g. `â`). Use plain hyphens, straight quotes, and `...`. This applies to slide text AND speaker notes.
- **Do not mention talk duration** (e.g. "in the next fifteen minutes") — the same deck may be given at different lengths.
- **Default to no text on the slide.** Prefer image + notes.
- **Speaker notes carry the talk.** For a manuscript-based talk, use the manuscript's prose as the backbone: preserve wording, voice, and order wherever possible. Split it into slide-sized beats; remove video production cues and adapt only transitions, medium-specific references, and claims that depend on the live state. Do not rewrite it into a new script by default. Notes should contain the actual narration, not merely instructions to explain a topic. Separate brief execution or checkpoint instructions without repetitive presenter labels.
- Group slides into content `.md` files by section (`<slug>-<section>.md`). When you start a new section file, add its `<section data-markdown="<slug>-<section>.md" …>` block at the `<!-- CONTENT-SECTIONS -->` marker in the HTML (copy the attribute set from the cover section). Register the section file the first time you write to it.
- Separators inside a `.md`: two blank lines (`\n\n\n`) between horizontal slides; one blank line for vertical; `Note:` begins the notes for the current slide.

### Diagrams (image sequences via the `diagram` skill)
When a slide needs a diagram, invoke the **`diagram`** skill with:
- **mode**: `stills` (pass explicitly so it doesn't ask).
- **mermaid**: describe the diagram in Mermaid with numbered flow `(1)`,`(2)`,… — this is internal notation only; Mermaid never appears on a slide.
- **beats**: one still per build step (cumulative state), so the sequence animates as slides advance.
- **out**: `<topic>/img/<slug>/` — name the stills `NN-01.png`, `NN-02.png`, … for section `NN`.

Then add one **image-only slide per still**, in order, each with a `Note:` describing what that beat adds. Follow the selected review mode. Describe nodes by their visible labels; the Mermaid numbers indicate reveal order and are not rendered on the stills.

For **non-diagram images**:
- **Visual style**: default to photorealistic imagery for generated illustrations unless the user requests another style. "Illustration" describes the explanatory purpose, not a requirement for drawn or cartoon artwork. Make photographic lighting, materials, anatomy, and camera composition explicit in the prompt.
- **Screenshots / real photos**: ask the user to supply the file (or its path) for conceptual or non-demo material. In hands-on sections, use executable demo instructions instead of screenshots.
- **Generated illustrations**: use the **`image`** skill, preferring ElevenLabs to use the user's subscription credits. Honor an explicit provider choice and do not silently switch billing providers. First discuss and agree on the depiction and style before generating. Then write a detailed prompt (16:9, projection-quality, consistent with the deck) and generate into `<topic>/img/<slug>/`. Place it as a full-bleed background slide and review according to the selected mode. In full-draft mode, use lean headings or demo cues where needed rather than blocking the entire draft on an unagreed illustration.
- **If the user is the subject** of the image, ask them to provide photo(s) of themselves and pass those to the `image` skill as references so their likeness is preserved.
- **An exact product interface inside a conceptual photograph**: use a real screenshot composited into a generated blank screen, rather than asking the model to invent the UI. `scripts/composite-monitor.py` perspective-maps the screenshot to four screen corners and can preserve foreground occlusion, using ImageMagick through Devbox. Keep screenshots as live-demo replacements out of hands-on sections; this technique is for explicitly requested conceptual illustrations. Preserve the source screenshot's aspect ratio and record its origin.

## Step 3 — Finish and synchronize

Once the slides are confirmed done, check that the deck delivers the approved abstract's promise, if there is one. Flag any mismatch for review rather than silently changing the proposal. Synchronize approved title changes across the cover, HTML title, abstract heading, and catalog entry while preserving their layout.

If the user requested both a deck and an abstract and no abstract exists yet, use the `abstracts` skill now and pause for its review. For a deck-only request, offer an abstract as a next step rather than automatically writing one.

### Project QR links

When requested, add a project QR alongside the existing channel QR, with a small destination label and clickable link. Use the project's official logo rather than generating one. `scripts/generate-branded-qr.py` embeds an SVG logo in a QR using `qrencode`, high error correction, a four-module quiet zone, and a small white-backed center mark. Run it through Devbox if qrencode is not on PATH. Preserve the QR's module-coordinate viewBox rather than deriving geometry from physical cm dimensions. Decode both the branded QR and any existing QR before labeling them, and verify the branded code at its displayed size as well as a larger size. Check that the footer does not cover slide content or navigation.

## Verify

Check that referenced content files and assets exist, slide text and notes use ASCII punctuation, and the matching catalog entry follows `CLAUDE.md`. Run `git diff --check` for file edits.

For full-draft review, serve and open the actual deck. Check navigation, notes, code-block fit, slide overflow, and console/network errors. For hands-on talks, check every cue has the context and preparation needed to execute it; browser checks do not mean the real agent/cloud demo was run.

For setup sections, verify the divider image, public repository link, working-directory assumptions, setup command, and environment exports against the actual demo repository. Check direct setup and cover URLs in the browser. Give a multi-slide setup container a different id from its first slide to avoid duplicate ids and incorrect hash navigation.

Respect the user's execution boundary. When they will validate cloud provisioning themselves, finish the scripts and slides using schema checks, local tooling, and mocked external commands; do not run the cloud setup as a side effect of verification. State clearly which behaviors still need a real cloud rehearsal, and leave timing-dependent narration provisional until those execution times are known.

Optionally serve locally (`docker-compose up`, http://localhost:8080) and open `<topic>/<slug>.html` to confirm slides render, images load, and notes (press `s`) show. Diagram stills should advance like an animation.

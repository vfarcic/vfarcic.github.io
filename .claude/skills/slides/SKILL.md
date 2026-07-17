---
name: "slides"
description: "Create a Reveal.js talk in this repo following the established pattern: copy the HTML loader template, build slides ONE AT A TIME with confirmation, prefer image-only slides with everything in speaker notes, render diagrams as image sequences via the `diagram` skill, link the talk in talks.md, and finish with an abstract."
---

# Create Slides (Reveal.js talk)

Build a presentation the way this repo already does it. Slides are markdown loaded by a per-talk HTML file (Reveal.js, moon theme). The guiding principle is **minimal on-slide text — often none. The slide carries an image or a diagram; the words live in the speaker `Note:`.**

## Inputs (ask only for what you can't infer)

- **title**: the talk title (used in `<title>` and talks.md).
- **slug**: short kebab-case name; drives filenames (`<slug>.html`, `cover-<slug>.md`, `img/<slug>/…`).
- **topic**: the topic directory the talk belongs in (`ai`, `kubernetes`, `crossplane`, `idp`, …). Talks live one level deep, so asset paths are `../…`.
- **source**: the outline / bullets / notes the talk is built from. If it's already in the conversation, use it.

## Step 0 — Analyze existing slides FIRST

Conventions drift; do not build from memory. Read 2–3 recent decks in the same `topic` (their `.html` loader + a couple of content `.md` files) and `../docs/the-end.md`. Confirm: current separators, image-slide directive, how `Note:` is attached, cover style, image path convention. Only then start.

## Step 1 — Scaffold from templates (never hand-write the loader)

Templates live in this skill's `templates/` directory. Copy, don't regenerate.

1. **HTML loader**: copy `templates/talk.html` → `<topic>/<slug>.html`. Replace `{{TITLE}}` with the title and `{{SLUG}}` with the slug. The cover section and `the-end` section are pre-wired; content sections get inserted at the `<!-- CONTENT-SECTIONS -->` marker as you add them.
2. **Cover**: copy `templates/cover.md` → `<topic>/cover-<slug>.md` and fill in the title lines (headings only — no body text).
3. **Image dir**: `mkdir -p <topic>/img/<slug>`.
4. **talks.md entry**: add the talk now so the link exists (see "talks.md rules"). Use the abstract path `<topic>/abstracts/<slug>.md` even though the abstract is written last.
5. **Pause** and show the user the cover before moving on.

## Step 2 — Build slides ONE AT A TIME (the core rule)

**CRITICAL: Create a single slide, show it to the user, and WAIT for explicit confirmation before creating the next one. Never batch slides. Never write a whole section at once.** This mirrors how the user works — each slide is an independently reviewable unit.

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
5. **Demo cue** (if the talk has live demos) — `> blockquote` for presenter instructions plus ```` ```text ```` blocks for prompts to type, matching existing demo decks.

### Content rules
- **ASCII-only punctuation.** The decks declare `data-charset="iso-8859-15"`, so em-dashes (`—`), curly quotes (`"` `'`), ellipses (`…`), and other non-ASCII characters render as mojibake (e.g. `â`). Use plain hyphens, straight quotes, and `...`. This applies to slide text AND speaker notes.
- **Do not mention talk duration** (e.g. "in the next fifteen minutes") — the same deck may be given at different lengths.
- **Default to no text on the slide.** Prefer image + notes.
- **Speaker notes carry the talk.** Write what the user will actually say, in their voice, as full prose under `Note:`.
- Group slides into content `.md` files by section (`<slug>-<section>.md`). When you start a new section file, add its `<section data-markdown="<slug>-<section>.md" …>` block at the `<!-- CONTENT-SECTIONS -->` marker in the HTML (copy the attribute set from the cover section). Register the section file the first time you write to it.
- Separators inside a `.md`: two blank lines (`\n\n\n`) between horizontal slides; one blank line for vertical; `Note:` begins the notes for the current slide.

### Diagrams (image sequences via the `diagram` skill)
When a slide needs a diagram, invoke the **`diagram`** skill with:
- **mode**: `stills` (pass explicitly so it doesn't ask).
- **mermaid**: describe the diagram in Mermaid with numbered flow `(1)`,`(2)`,… — this is internal notation only; Mermaid never appears on a slide.
- **beats**: one still per build step (cumulative state), so the sequence animates as slides advance.
- **out**: `<topic>/img/<slug>/` — name the stills `NN-01.png`, `NN-02.png`, … for section `NN`.

Then add one **image-only slide per still**, in order, each with a `Note:` describing what that beat adds. Reference nodes by the numbers baked into the still (`(1)`, `(2)`, …).

For **non-diagram images**:
- **Screenshots / real photos**: ask the user to supply the file (or its path).
- **Generated illustrations**: use the **`image`** skill (Gemini / "Nano Banana" by default). First **discuss with the user what the image should depict and its style, and agree before generating** — don't generate blind. Then write a detailed prompt (16:9, projection-quality, consistent with the deck) and generate into `<topic>/img/<slug>/`. Place it as a full-bleed background slide, then **pause for the user to confirm**; iterate on the prompt and regenerate if needed.
- **If the user is the subject** of the image, ask them to provide photo(s) of themselves and pass those to the `image` skill as references so their likeness is preserved.

## Step 3 — Abstract (after slides are confirmed done)

Write `<topic>/abstracts/<slug>.md` following the pattern of recent abstracts in that topic (read one or two first). Include at least a full abstract and a short abstract; for CNCF/KCD submissions also add "Benefits to the CNCF Ecosystem", "Key takeaways", and "Open Source Projects Used" (see `ai/abstracts/modelplane.md`). Ensure the talks.md entry's `[Abstract]` link points to this file. Pause for the user to review.

## talks.md rules (mirror the repo's CLAUDE.md)

- New talks go to the **top** of the **first** `# Talks` section, as the first list item.
- Each `# Talks` section holds a maximum of **5** talks. If the top section already has 5, create a **new `# Talks` section above it** and add the talk there.
- Entry format (talk with slides + abstract):
  `* [<Title>](<topic>/<slug>.html) ([Abstract](https://github.com/vfarcic/vfarcic.github.io/blob/master/<topic>/abstracts/<slug>.md))`
- If a talk has an abstract but no slides yet, use just the title text (no `.html` link), matching existing entries.

## Verify

Optionally serve locally (`docker-compose up`, http://localhost:8080) and open `<topic>/<slug>.html` to confirm slides render, images load, and notes (press `s`) show. Diagram stills should advance like an animation.

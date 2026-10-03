---
name: abstracts
description: "Write or revise conference talk titles, abstracts, short abstracts, and submission takeaways in this repository. Use for conference proposals, CFP submissions, abstracts based on manuscripts or existing decks, and abstract-first or abstract-only requests. Save under the topic's abstracts directory and add or update talks.md using the shared repository rules. Actual Reveal.js deck creation belongs to the slides skill."
---

# Conference Abstracts

Turn a manuscript, talk idea, or existing deck into a conference-ready proposal in the user's voice. An abstract should give the audience a reason to attend and make a promise the talk can actually deliver.

## Inputs

Use the conversation and existing files to infer:

- **Source:** a manuscript, outline, existing presentation, or idea.
- **Title:** reuse an approved title; otherwise propose a title and subtitle grounded in the source.
- **Topic and slug:** reuse the talk's existing paths, or choose a topic directory and a short kebab-case slug.
- **Submission requirements:** audience, conference, word or character limits, and required fields, when supplied.

Ask only for information that materially blocks the draft. A general conference abstract does not require a named conference or a completed deck.

## 1. Read the source and local conventions

Read the relevant source, one or two recent abstracts in the same topic, and the repository root's `CLAUDE.md`, including its shared `talks.md` rules. Check for an existing abstract, deck, and catalog entry before creating anything.

Extract the central audience problem, the narrative progression, concrete evidence, and the practical outcome. If a supplied path does not exist, look for the named file in the indicated neighboring repositories and report the resolved path. Ask if multiple plausible sources remain.

## 2. Shape the proposal

- Lead with the problem, tension, or surprising result that makes this talk worth attending.
- Explain the progression and the concrete techniques or decisions the audience will learn.
- Close with an audience benefit, not just a list of technologies.
- Match the user's direct, conversational voice and the source's point of view. First person works for an experience-based talk.
- Use specific examples and numbers only when supported by the source. Frame personal results as personal results, not general guarantees.
- Distinguish working capabilities from unresolved problems and future plans. Do not present a planned feature as implemented.
- Mention tools when they make the approach concrete, without turning the proposal into a product pitch.
- If the source contains hands-on demonstrations, treat the talk as hands-on unless the user asks otherwise. Carry that format into the proposal using only demonstrations supported by the source; screenshots in a manuscript are often recording cues, not the planned conference format.
- Do not invent live demos, benchmarks, production deployments, or technologies to make the submission sound stronger.
- For a title discussion, offer a small number of distinct options with a recommendation. An approved title does not need another approval round before drafting.

## 3. Write the abstract file

Save to `<topic>/abstracts/<slug>.md`. Preserve unrelated submission variants and user edits in an existing file.

Default structure:

```markdown
# Talk Title

Full abstract: opening problem, approach or narrative, and audience outcome.

## Short Abstract

A standalone compact version of the same promise.

## Key takeaways:

* Three to five concrete things attendees will understand or be able to apply
```

Without supplied limits, aim for roughly 200-300 words in the full abstract and 75-100 in the short abstract. These are drafting targets, not mandatory padding; explicit submission limits take precedence. Count words or characters when a limit is supplied, including headings only if the submission requires them.

Use plain ASCII punctuation for consistency with the decks and easy reuse. Omit manuscript production cues, screenshot placeholders, TODOs, and references to talk duration unless the user explicitly requests a duration-specific submission.

Add `## Open Source Projects Used` when relevant or required. List only projects actually covered and known to be open source; proprietary tools can be mentioned in the prose without appearing in that list.

For CNCF/KCD submissions, also include `## Benefits to the CNCF Ecosystem`, following examples such as `ai/abstracts/modelplane.md`. Tie benefits to the actual talk. Do not add unrelated CNCF projects or claim a project's CNCF affiliation or maturity without verifying it. If the conference requires different fields, follow its requirements.

## 4. Update the catalog

Add or update the matching `talks.md` entry according to the shared rules in the repository root's `CLAUDE.md`. Reuse the talk's slug and update an existing entry in place rather than adding a duplicate. Link the abstract now that the file exists; link slides only if the loader exists.

Abstract-only requests end with the abstract and catalog update. Do not create a presentation scaffold or assets just to populate a link.

If the user approves a title change for a talk with a deck, synchronize the catalog, abstract heading, HTML title, and cover headings while preserving their layout.

## 5. Review and handoff

Check that the full and short versions make the same promise, takeaways are supported by the source, supplied limits are met, paths and links resolve locally, and the catalog entry is unique. Run `git diff --check` for file edits.

Present the full abstract and its file path for review; include the short version when requested or when the submission needs review of both. Revise based on feedback before moving to another deliverable.

For an abstract-first talk, continue with the `slides` skill only after the user approves the abstract and asks to proceed. Pass along the approved title, source, audience, takeaways, topic, and slug. Slides-first requests can use this skill once the deck is ready; neither order is mandatory.

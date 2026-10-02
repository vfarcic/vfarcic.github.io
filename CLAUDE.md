# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is Viktor Farcic's presentation and workshop repository (vfarcic.github.io) containing technical talks and hands-on workshops focused on DevOps, Kubernetes, GitOps, and platform engineering. The site serves static HTML presentations built with Reveal.js framework.

## Architecture

The repository is organized as a static website with:

- **Root level**: Main index and configuration files
- **Topic directories**: Each major topic (crossplane/, devops/, kubernetes/, etc.) contains:
  - Presentation HTML files using Reveal.js
  - Markdown content files
  - Abstract files in `abstracts/` subdirectories
  - Demo scripts and setup files
  - Topic-specific images in `img/` subdirectories
- **Shared resources**:
  - `/css/`: Reveal.js themes and styling
  - `/js/`: Reveal.js JavaScript framework
  - `/img/`: Global images and logos
  - `/docs/`: Shared documentation and setup guides

## Content Structure

**Presentations**: Each topic directory contains HTML files that load Reveal.js presentations from markdown files. The main entry points are typically `index.html` or topic-specific HTML files.

**Workshops**: Interactive, hands-on sessions with step-by-step guides, demo scripts, and cleanup procedures. Workshop files often include setup requirements, demo commands, and tear-down instructions.

**Abstracts**: Summary descriptions of talks and workshops stored in `abstracts/` subdirectories for submission to conferences and events.

## Development Commands

**Local Development**:
```bash
# Run local development server
docker-compose up

# Build Docker image
docker build -t vfarcic/presentations .

# Access locally at http://localhost:8080
```

**Content Management**:
- Presentations are markdown files processed by Reveal.js
- No build step required - direct HTML/CSS/JS serving
- Images should be optimized and placed in appropriate `img/` directories

## Key Files

- `talks.md`: Current active presentations and abstracts
- `workshops.md`: Available workshop offerings
- `index.html`: Main landing page with Reveal.js integration
- `docker-compose.yml`: Local development setup

## Content Guidelines

- Presentations follow Reveal.js markdown format with section separators
- Demo scripts should include setup, execution, and cleanup phases
- Abstract files should be concise and conference-ready
- Images should be placed in topic-specific `img/` directories

## talks.md Rules

These are the shared catalog rules for both the `abstracts` and `slides` skills.

- New talks are always added to the **top** of the first `# Talks` section (as the first list item)
- Each `# Talks` section (page) holds a maximum of **5** talks
- If the top section already has 5 talks, create a new `# Talks` section above it and add the new talk there
- Before adding a talk, check for an existing entry using its title, topic, slug, or links. Update an existing entry **in place**; do not duplicate it or move it to the top as if it were new.
- Reuse the same topic and slug across the deck, abstract, and catalog entry. When a title change is approved, synchronize the catalog title, abstract heading, HTML `<title>`, and cover headings for whichever files exist.
- Link only artifacts that exist. An abstract-only talk uses plain title text with an abstract link; a slides-only talk links the title to the loader and omits the abstract link until the abstract file exists.
- Entry formats:
  - Slides and abstract: `* [<Title>](<topic>/<slug>.html) ([Abstract](https://github.com/vfarcic/vfarcic.github.io/blob/master/<topic>/abstracts/<slug>.md))`
  - Abstract only: `* <Title> ([Abstract](https://github.com/vfarcic/vfarcic.github.io/blob/master/<topic>/abstracts/<slug>.md))`
  - Slides only: `* [<Title>](<topic>/<slug>.html)`
- Keep the existing section separators and unrelated entries unchanged. Check that newly added or updated links point to the matching local files.

## Talk Authoring Skills

- `.claude/skills/abstracts/SKILL.md`: Conference titles, full and short abstracts, takeaways, and submission-specific fields. Supports abstract-only proposals without creating a deck.
- `.claude/skills/slides/SKILL.md`: Reveal.js presentations, built one slide at a time with approval, using image-first slides and speaker notes.
- `.claude/skills/image/SKILL.md` and `.claude/skills/diagram/SKILL.md`: Visual assets used by presentations.

Abstracts and slides can be created in either order. Follow the user's requested deliverable and review sequence; use an approved abstract to guide a later deck and an existing deck to inform a later abstract.

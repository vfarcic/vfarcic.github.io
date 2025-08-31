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
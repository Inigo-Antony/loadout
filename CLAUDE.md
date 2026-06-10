# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

**Loadout** is a modular library of Claude operating instructions. It is the master source; projects get a curated subset installed into their `.claude/` directory via `install.sh`. Nothing here runs as code — all content is Markdown skill files consumed by Claude sessions.

## Installing into a project

```bash
# Wizard (default — interactive personalization)
./install.sh ~/projects/myproject

# Preset
./install.sh ~/projects/myproject --preset saas-launch [--plugins]

# Custom
./install.sh ~/projects/myproject --custom \
  --domains backend-saas,frontend \
  --business outcome-framing,digital-products \
  --meta monetize-or-opensource
```

Available presets: `academic-research`, `saas-launch`, `freelance-services`, `content-creator`, `job-pipeline`, `consultant`, `engineering`.

Core (CLAUDE.md.template, pitfalls.md, thinking/, operating/) is always copied regardless of preset. `--plugins` requires the `claude` CLI in PATH.

## Skill file format

Every file in `domains/`, `business/`, `meta/`, and `core/skills/` must follow this structure:

```yaml
---
name: kebab-case-name
description: One sentence on when to invoke. ~50 tokens always-on.
---

# Body — full content, only loaded when the skill is matched.
```

The description is the always-on cost (~50 tokens). The body costs nothing until matched. Keep descriptions tight and trigger-specific.

## Architecture

```
core/                  → always installed; identity template, voice, tooling rules
  CLAUDE.md.template   → placeholder-driven operator profile (~400 tokens)
  pitfalls.md          → reference, not auto-loaded; consult before designing skills
  skills/
    thinking/          → first-principles.md, systems-thinking.md
    operating/         → token-discipline, walkthrough-then-codify,
                         recursive-refinement, profile-me,
                         governing-algorithm, orchestration-policy,
                         grounding-standard, handoff-log, reasoning-education
domains/               → technical cherry-picks (scientific-python, frontend, backend-saas,
                         engineering-simulation, report-generation, …)
business/              → commercial workflows (outcome-framing, client-services,
                         product-launch, …)
meta/                  → cross-cutting (monetize-or-opensource + sub/open-sourcing,
                         sub/monetization)
ecosystem/             → human-facing references, not skills (plugins-to-install,
                         external-skills)
install.sh             → bash; copies what each project needs
wizard.sh              → interactive personalization, invoked via install.sh --wizard
LICENSE                → Apache-2.0 (code)
LICENSE-CONTENT        → CC-BY-4.0 (skill .md files)
TRADEMARK.md           → Loadout name + branding policy
```

## Maintenance rules

1. When a skill misfires: fix the immediate run, then update the skill body.
2. When a skill misfires twice: retire it and re-author from `walkthrough-then-codify`.
3. New repeatable workflow → walk it manually, then codify via `core/skills/operating/walkthrough-then-codify.md` (the Anthropic skill-creator plugin does the packaging).
4. New tool/plugin available → check `ecosystem/external-skills.md`.

Do not add skills to this library from untrusted external sources without reading them fully. Skill files are instructions; treat them like running someone's binary.

## What lives where

- Operator identity template → `core/CLAUDE.md.template` (placeholders filled by wizard)
- Anti-patterns reference → `core/pitfalls.md`
- Preset definitions → `install.sh` (case block under `# ---- Preset definitions ----`)
- Plugin list → `install.sh` (PLUGINS array)
- Wizard logic → `wizard.sh`
- Licensing policy → `LICENSE` (code) and `LICENSE-CONTENT` (skill files)

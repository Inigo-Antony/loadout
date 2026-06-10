# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

**Loadout** is a thin personal layer of Claude operating instructions that sits on top of the commodity engineering frameworks (superpowers, GSD, context-mode, claude-mem — "Layer 1"). It never rebuilds what Layer 1 does well; it owns voice, token discipline, reasoning policies, and the brainstorm→outcome arc. This repo is the master source; projects get Layer 1 provisioned plus a curated Layer 2 subset installed into their `.claude/` directory via `install.sh`. Nothing here runs as code — all content is Markdown skill files consumed by Claude sessions.

## Installing into a project

```bash
# Wizard (default — interactive personalization)
./install.sh ~/projects/myproject

# Preset
./install.sh ~/projects/myproject --preset saas-launch [--standalone]

# Custom
./install.sh ~/projects/myproject --custom \
  --domains backend-saas,frontend \
  --business outcome-framing,digital-products \
  --meta monetize-or-opensource
```

Available presets: `academic-research`, `saas-launch`, `freelance-services`, `content-creator`, `job-pipeline`, `consultant`, `engineering`.

The default install is layered: Layer 1 plugins are provisioned via the `claude` CLI first, then Layer 2 is copied. `--standalone` skips Layer 1 — pure bash, zero external dependencies. Core (CLAUDE.md.template, pitfalls.md, thinking/, operating/) is always copied regardless of preset.

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
domains/               → thin adapters where a best-in-class external exists
                         (scientific-python, frontend, backend-saas, …); native depth
                         only where none does (engineering-simulation, report-generation, …)
business/              → commercial workflows (outcome-framing, client-services,
                         product-launch, …)
meta/                  → cross-cutting (monetize-or-opensource + sub/open-sourcing,
                         sub/monetization)
ecosystem/             → human-facing references, not skills (plugins-to-install,
                         external-skills)
install.sh             → bash; provisions Layer 1, copies Layer 2 (--standalone = copy-only)
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

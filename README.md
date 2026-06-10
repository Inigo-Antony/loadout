# Loadout

A modular library of operating instructions for Claude (Code, Cowork, web/desktop). The library is the master source; each project gets a curated subset copied into its `.claude/` directory by `install.sh`.

> What's your Claude loadout? Pick a preset, run the wizard, or compose your own.

## The shape in one diagram

```
loadout/
├── README.md
├── LICENSE                          ← Apache-2.0 (code)
├── LICENSE-CONTENT                  ← CC-BY-4.0 (skill .md files)
├── TRADEMARK.md                     ← name + branding policy
├── install.sh                       ← bash; copies what each project needs
├── wizard.sh                        ← interactive personalization
├── core/                            ← always copied to every project
│   ├── CLAUDE.md.template           ← ~400 tokens, placeholders filled by wizard
│   ├── pitfalls.md                  ← reference; not auto-loaded
│   └── skills/
│       ├── thinking/                ← cognitive foundations
│       │   ├── first-principles.md
│       │   └── systems-thinking.md
│       └── operating/               ← how to work with Claude
│           ├── token-discipline.md
│           ├── plan-then-execute.md
│           ├── walkthrough-then-codify.md
│           ├── subagents-and-teams.md
│           ├── recursive-refinement.md
│           ├── skill-creator.md
│           ├── incident-response.md
│           └── profile-me.md        ← in-Claude personalization skill
├── domains/                         ← technical, cherry-pick per project
│   ├── scientific-python.md
│   ├── academic-writing.md
│   ├── data-analysis.md
│   ├── frontend.md
│   ├── backend-saas.md
│   ├── infra-containers.md
│   ├── privacy-opsec.md
│   ├── engineering-simulation.md    ← power systems, microgrids, physical sims
│   └── report-generation.md         ← PDFs via Quarto / Typst / HTML+print
├── business/                        ← money-making, cherry-pick per project
│   ├── outcome-framing.md
│   ├── client-services.md
│   ├── digital-products.md
│   ├── automation-workflows.md
│   ├── content-creation.md
│   ├── ai-consulting.md
│   ├── seo-and-marketing.md
│   ├── outreach-applications.md
│   └── product-launch.md            ← pre-launch / launch-day / retro
├── meta/                            ← cross-cutting workflows
│   ├── monetize-or-opensource.md
│   └── sub/
│       ├── open-sourcing.md
│       └── monetization.md
└── ecosystem/                       ← human-facing references (not skills)
    ├── plugins-to-install.md
    └── external-skills.md
```

## How to install into a project

### Option 1: Wizard (default, recommended)

Run with no flags — drops into the personalization wizard:

```bash
./install.sh ~/projects/myproject
# or explicitly
./install.sh ~/projects/myproject --wizard
```

The wizard asks 5–8 questions (name, role, domains, ship goal, voice, tooling, optional reference markdown files), then writes a fully personalized `CLAUDE.md` plus a curated skill set. Re-running is safe — existing files are backed up.

### Option 2: Preset

Seven presets cover the common project shapes:

```bash
./install.sh ~/projects/myproject --preset academic-research
./install.sh ~/projects/myproject --preset saas-launch
./install.sh ~/projects/myproject --preset freelance-services
./install.sh ~/projects/myproject --preset content-creator
./install.sh ~/projects/myproject --preset job-pipeline
./install.sh ~/projects/myproject --preset consultant
./install.sh ~/projects/myproject --preset engineering
```

Composition of each preset:

| Preset | Domains | Business | Meta |
| --- | --- | --- | --- |
| `academic-research` | scientific-python, academic-writing, data-analysis, report-generation | — | — |
| `saas-launch` | backend-saas, frontend, infra-containers, report-generation | outcome-framing, product-launch | monetize-or-opensource |
| `freelance-services` | — | client-services, outcome-framing, automation-workflows | — |
| `content-creator` | — | content-creation, seo-and-marketing, digital-products, product-launch | — |
| `job-pipeline` | scientific-python, infra-containers | outreach-applications, automation-workflows | — |
| `consultant` | report-generation | ai-consulting, outcome-framing, client-services | — |
| `engineering` | engineering-simulation, scientific-python, data-analysis, report-generation, infra-containers | — | — |

Core (CLAUDE.md.template, pitfalls.md, thinking, operating) is always copied — every preset includes it.

In preset mode, `CLAUDE.md` ships with placeholders unfilled — either edit by hand or re-run with `--wizard`.

### Option 3: Custom

Any combination of files:

```bash
./install.sh ~/projects/myproject --custom \
  --domains backend-saas,frontend \
  --business outcome-framing,digital-products \
  --meta monetize-or-opensource
```

Comma-separated, no spaces. Domains, business, meta are all optional individually.

### Option 4: Plugins too

Add `--plugins` to any mode to also install the recommended Claude Code plugins (skill-creator, frontend-design, superpowers, claude-mem, context-mode, GSD):

```bash
./install.sh ~/projects/myproject --preset saas-launch --plugins
```

This requires the `claude` CLI to be installed and in PATH. Plugins install globally — once per machine, not per project.

### Optional: devcontainer

The repo ships a `.devcontainer/` for running Claude Code in a network-sandboxed Linux environment (requires Docker + a devcontainer-aware tool such as VS Code Dev Containers or the `devcontainer` CLI). It runs the same on macOS, Windows/WSL2, and Linux hosts. It is **not** required to install or use Loadout — `install.sh` and `wizard.sh` are pure bash and run anywhere, with or without the container.

## What gets installed

The script copies into `<project>/CLAUDE.md` and `<project>/.claude/skills/`:

- `CLAUDE.md` — operator profile (placeholders filled by wizard, or left for manual edit in preset/custom mode)
- `.claude/pitfalls.md` — reference for designing/auditing skills
- `.claude/skills/thinking/*.md` — first-principles, systems-thinking
- `.claude/skills/operating/*.md` — token discipline, plan mode, walkthrough, sub-agents, recursive refinement, skill creator, incident response, profile-me
- `.claude/skills/<domain>.md` — selected domain files
- `.claude/skills/<business>.md` — selected business files
- `.claude/skills/<meta>.md` plus `sub/*.md` — selected meta files (sub-skills load automatically when parent meta-skill is included)

## In-Claude personalization

After the wizard runs, invoke the `profile-me` skill inside Claude Code at any time to deepen your profile — it interviews you, optionally reads reference markdown you point it at, and writes new personalized skill files directly into your `.claude/skills/`.

## Format

Every skill is a single `.md` file with YAML frontmatter:

```yaml
---
name: kebab-case-name
description: One sentence on when to invoke. ~50 tokens always-on.
---

# Body — loads only when the agent decides this skill applies.
```

This follows Claude Code's progressive-disclosure convention: the description costs ~50 tokens always-on; the body costs nothing until matched. Each body is also valid as a standalone snippet — strip the frontmatter and paste into a Project's custom instructions, a chat, or a CLAUDE.md.

## How the agent loads it

```
Session start
  ↓
Read CLAUDE.md (~400 tokens)
  ↓
Scan .claude/skills/**/*.md frontmatter (~50 tok per file)
  ↓
[Agent waits for user message]
  ↓
User: "Help me draft a cover letter for X"
  ↓
Frontmatter matches outreach-applications + operator-profile in CLAUDE.md
  ↓
Load outreach-applications.md body (full content)
  ↓
Draft using voice from CLAUDE.md + structure from skill
```

Everything else stays out of context until needed.

## Maintenance

The library is a living thing. Per `core/skills/operating/recursive-refinement.md`:

1. When a skill misfires, fix the immediate run, then update the skill body so the failure can't recur.
2. When a skill misfires repeatedly across iterations, retire it and re-author from scratch (`core/skills/operating/walkthrough-then-codify.md`).
3. When you build a new workflow you'll repeat, codify it via `core/skills/operating/skill-creator.md` (or the Anthropic plugin if installed).
4. When the ecosystem ships better tools, scan `ecosystem/external-skills.md` for additions; install via `ecosystem/plugins-to-install.md`.

Don't download skills from strangers without reading them first — they're instruction files; treat them like running someone's binary.

## Licensing

- **Code** (`install.sh`, `wizard.sh`, future CLI): **Apache-2.0**. Patent grant explicit.
- **Skill content** (all `.md` files in `core/`, `domains/`, `business/`, `meta/`): **CC-BY-4.0**. Attribution required.

See `LICENSE`, `LICENSE-CONTENT`, and `TRADEMARK.md` for the full text.

## Sources

Distilled from:

- **Anthropic** — official `anthropics/skills` repository, Claude Code documentation, agent teams release notes
- **Ross Mak** — skills + progressive disclosure + walkthrough-then-codify methodology
- **Nate Herk** — "I tried 100+ Claude Code skills, these 6 are the best" — plugin layer (skill-creator, superpowers, GSD, /review, context-mode, claude-mem, frontend-design) + outcome-selling principle
- **Claude Code tricks** — 32 tactical mechanisms compendium
- **First Principles Thinking** and **Systems Thinking for ESD** — cognitive foundations
- **MarksInsights** — "How to make money with Claude AI" — 15 income paths and the trade-time-for-money critique
- **ScriptByAI** — Ultimate Claude Code Resource List 2026 — broader ecosystem map
- **everything-claude-code** (Affaan Mustafa) — structural conventions, MCP discipline rules

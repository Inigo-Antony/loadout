# Loadout

A thin personal layer for Claude Code that sits **on top of** the commodity engineering frameworks — superpowers, GSD, context-mode, claude-mem. Those frameworks own engineering execution: planning, TDD, subagent orchestration, context sandboxing, cross-session memory. Loadout never rebuilds them. It owns the parts that are irreducibly *yours*:

- **Think how you think** — an operator profile (voice, conditional concision, reasoning defaults: first-principles → systems-thinking) and a `profile-me` skill that keeps sharpening it from your real sessions.
- **Token-light** — a small skill set, progressive disclosure (~50 tokens per skill until matched), and governance that deletes before it adds.
- **Brainstorm → outcome** — the arc from idea to shipped/monetized result: outcome-framing → product-launch → monetize-or-opensource.

> What's your Claude loadout? Pick a preset, run the wizard, or compose your own.

## The stack

```
LAYER 2 — LOADOUT (the only thing you maintain)
  voice + reasoning defaults     CLAUDE.md operator profile, thinking/ skills
  governance policies            governing-algorithm, orchestration-policy,
                                 grounding-standard, handoff-log, reasoning-education
  outcome arc                    outcome-framing → product-launch → monetize-or-opensource
  compounding engine             profile-me + recursive-refinement + token-discipline

LAYER 1 — COMMODITY ENGINEERING RHYTHM (adopt, never rebuild)
  superpowers    spec-first, TDD, subagent-driven development
  GSD            context engineering, subagent orchestration, quality gates
  context-mode   tool-output sandboxing (anti context-rot)
  claude-mem     cross-session memory, auto folder-CLAUDE.md
  skill-creator, frontend-design  (Anthropic official)

LAYER 0 — Claude Code + the Agent Skills spec
```

The rule that keeps it coherent: when Loadout and Layer 1 could overlap, Loadout yields. The generated `CLAUDE.md` carries a **Layer Contract** that tells Claude to defer engineering execution to Layer 1 and reserves Loadout for voice, token budget, reasoning policies, and the path to outcome.

## The shape in one diagram

```
loadout/
├── README.md
├── LICENSE                          ← Apache-2.0 (code)
├── LICENSE-CONTENT                  ← CC-BY-4.0 (skill .md files)
├── TRADEMARK.md                     ← name + branding policy
├── install.sh                       ← layered install (Layer 1 + Layer 2); --standalone for copy-only
├── wizard.sh                        ← interactive personalization
├── core/                            ← always copied to every project
│   ├── CLAUDE.md.template           ← operator profile + Layer Contract, placeholders filled by wizard
│   ├── pitfalls.md                  ← reference; not auto-loaded
│   └── skills/
│       ├── thinking/                ← cognitive foundations
│       │   ├── first-principles.md
│       │   └── systems-thinking.md
│       └── operating/               ← thin policies; execution delegated to Layer 1
│           ├── governing-algorithm.md   ← question → delete → simplify → accelerate → automate
│           ├── orchestration-policy.md  ← parallel vs. sequential; execution via GSD
│           ├── grounding-standard.md    ← ground claims before asserting
│           ├── handoff-log.md           ← cold-session resume schema, rides on claude-mem
│           ├── reasoning-education.md   ← state the governing principle on non-obvious decisions
│           ├── token-discipline.md
│           ├── walkthrough-then-codify.md  ← Elon step 5: automate last
│           ├── recursive-refinement.md
│           └── profile-me.md        ← the compounding engine
├── domains/                         ← thin adapters where best-in-class externals exist;
│   │                                  native only where none does
│   ├── scientific-python.md         ← adapter → scientific-agent-skills + operator standards
│   ├── academic-writing.md          ← adapter → academic-research-skills + humanizer
│   ├── data-analysis.md             ← adapter → scientific-agent-skills
│   ├── frontend.md                  ← adapter → frontend-design plugin
│   ├── backend-saas.md              ← adapter → superpowers/GSD + mattpocock/vercel skills
│   ├── infra-containers.md          ← native (rootless Podman, SELinux, devcontainers)
│   ├── privacy-opsec.md             ← native
│   ├── engineering-simulation.md    ← native (power systems, microgrids, physical sims)
│   └── report-generation.md         ← native (PDFs via Quarto / Typst / HTML+print)
├── business/                        ← operator judgment, cherry-pick per project
│   ├── outcome-framing.md
│   ├── client-services.md
│   ├── digital-products.md
│   ├── automation-workflows.md
│   ├── content-creation.md          ← overlay → marketingskills
│   ├── ai-consulting.md
│   ├── seo-and-marketing.md         ← overlay → marketingskills
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

By default every mode is **layered**: it provisions the Layer 1 plugins via the `claude` CLI (globally — once per machine), then copies the Loadout personal layer into the project. Add `--standalone` to any mode to skip Layer 1 entirely — the install is then pure bash with zero external dependencies.

### Option 1: Wizard (default, recommended)

```bash
./install.sh ~/projects/myproject
# or explicitly
./install.sh ~/projects/myproject --wizard
```

The wizard asks ~8 questions (name, role, domains, voice, tooling, reference markdown, extra notes — closing with the *outcome you're driving toward*, which selects the business/meta skills), then writes a fully personalized `CLAUDE.md` (profile + Layer Contract) plus a curated skill set, and offers the layered/standalone choice. Re-running is safe — existing files are backed up.

### Option 2: Preset

```bash
./install.sh ~/projects/myproject --preset saas-launch
./install.sh ~/projects/myproject --preset academic-research --standalone
```

| Preset | Domains | Business | Meta |
| --- | --- | --- | --- |
| `academic-research` | scientific-python, academic-writing, data-analysis, report-generation | — | — |
| `saas-launch` | backend-saas, frontend, infra-containers, report-generation | outcome-framing, product-launch | monetize-or-opensource |
| `freelance-services` | — | client-services, outcome-framing, automation-workflows | — |
| `content-creator` | — | content-creation, seo-and-marketing, digital-products, product-launch | — |
| `job-pipeline` | scientific-python, infra-containers | outreach-applications, automation-workflows | — |
| `consultant` | report-generation | ai-consulting, outcome-framing, client-services | — |
| `engineering` | engineering-simulation, scientific-python, data-analysis, report-generation, infra-containers | — | — |

Core (CLAUDE.md.template, pitfalls.md, thinking, operating) is always copied — every preset includes it. In preset mode, `CLAUDE.md` ships with placeholders unfilled — either edit by hand or re-run with `--wizard`.

### Option 3: Custom

```bash
./install.sh ~/projects/myproject --custom \
  --domains backend-saas,frontend \
  --business outcome-framing,digital-products \
  --meta monetize-or-opensource
```

Comma-separated. Domains, business, meta are all optional individually.

### Standalone mode

`--standalone` skips Layer 1 provisioning: no `claude` CLI needed, no plugins, no network — just bash copying markdown. The Layer Contract still lands in `CLAUDE.md`; install Layer 1 later and it simply starts being honored.

### Optional: devcontainer

The repo ships a `.devcontainer/` for running Claude Code in a network-sandboxed Linux environment (requires Docker + a devcontainer-aware tool). It is **not** required — `install.sh` and `wizard.sh` are pure bash and run anywhere.

## What gets installed

- `CLAUDE.md` — operator profile + Layer Contract (placeholders filled by wizard, or left for manual edit)
- `.claude/pitfalls.md` — reference for designing/auditing skills
- `.claude/skills/thinking/*.md` — first-principles, systems-thinking
- `.claude/skills/operating/*.md` — the five governance policies, token-discipline, walkthrough-then-codify, recursive-refinement, profile-me
- `.claude/skills/<domain>.md`, `<business>.md`, `<meta>.md` (+ `sub/*.md`) — the selected adapters and overlays

## The compounding loop

Additive toolkits don't compound; this is built to:

```
your sessions ─► profile-me mines corrections, decisions, voice, skill misses
            ─► refreshes your skills + CLAUDE.md to fit you better
            ─► next project starts more "you" ─► better, faster outcomes
            ─► more signal to capture ─┐
            ▲                          │
            └──────────────────────────┘
  recursive-refinement prunes · token-discipline caps the size · governing-algorithm deletes
```

The engineering substrate (Layer 1) improves by its communities, for free. The personal layer improves by your own usage. You maintain a shrinking, sharpening core and inherit a growing engineering core you didn't write.

## Format

Every skill is a single `.md` file with YAML frontmatter:

```yaml
---
name: kebab-case-name
description: One sentence on when to invoke. ~50 tokens always-on.
---

# Body — loads only when the agent decides this skill applies.
```

The description costs ~50 tokens always-on; the body costs nothing until matched. Each body is also valid as a standalone snippet — strip the frontmatter and paste into a Project's custom instructions or a CLAUDE.md.

## Maintenance

1. When a skill misfires, fix the immediate run, then update the skill body (`recursive-refinement`).
2. When a skill misfires repeatedly, retire it and re-author from `walkthrough-then-codify`.
3. New repeatable workflow → walk it manually first, then codify (`walkthrough-then-codify`; the Anthropic skill-creator plugin does the packaging).
4. When the ecosystem ships better tools, scan `ecosystem/external-skills.md`; if an external now beats a native domain skill, shrink the domain skill to an adapter.

Don't download skills from strangers without reading them first — they're instruction files; treat them like running someone's binary.

## Licensing

- **Code** (`install.sh`, `wizard.sh`): **Apache-2.0**. Patent grant explicit.
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

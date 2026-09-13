# Loadout
<img width="2816" height="1536" alt="loadout-image" src="https://github.com/user-attachments/assets/d49ea1c7-9d5a-4842-84c4-03b9d75336d8" />


Every multiplayer game makes you pick a loadout before you spawn: weapons, perks, equipment. The map is the same for everyone. The ruleset is the same for everyone. The only part that's actually yours is what you choose to carry in.

A Claude Code session starts the same way, except most people re-fight the loadout screen on every project. I kept doing exactly that — new repo, rewrite the same `CLAUDE.md` by hand: my voice, my reasoning defaults, when to brainstorm versus just ship, how much token budget I'm willing to spend before I want the answer. From zero, every time.

Meanwhile I'd already adopted the frameworks that are genuinely good at the engineering side — superpowers, GSD, context-mode, claude-mem. They own planning, TDD, subagent orchestration, context sandboxing, cross-session memory, and they get better for free as their communities improve them. But none of them know anything about *me*. Personalization was never their job, and I kept rebuilding it by hand like that was just the cost of starting a new project.

It isn't. **Loadout** is a thin personal layer that sits **on top of** those commodity frameworks instead of competing with them. It never rebuilds what Layer 1 already does well — it owns the parts that are irreducibly *yours*, and each one earns its place:

- **Think how you think** — an operator profile (voice, conditional concision, reasoning defaults: first-principles → systems-thinking) and a `profile-me` skill that keeps sharpening it from your real sessions. *Why it matters:* every new repo starts as *you* instead of a generic assistant you have to re-train by hand, and it gets more "you" the more you use it.
- **Spend what you mean to spend** — an *execution-budget* directive (Free/Pro vs. Max/Team/API) plus the governance policies: `governing-algorithm` (question → delete before you add), `grounding-standard` (no unsourced claims), and `ship-readiness` (a pre-ship security + claim-integrity gate). *Why it matters:* this is what stops Layer 1's expensive multi-agent patterns from quietly burning your whole token budget on a one-line change — the difference between a productive afternoon and an empty quota — and keeps unsafe or unsubstantiated work from shipping.
- **A flat token fee, not a growing tax** — a small skill set, progressive disclosure (~50 tokens per skill always-on, the body free until matched), and governance that deletes before it adds. *Why it matters:* personalization costs the same whether a skill is shallow or deep, so the layer never becomes the thing slowing you down. (The one real cost to watch: every always-on description competes for the model's attention, so a *bloated* library raises misfire odds — which is exactly why curation is built in.)
- **Brainstorm → outcome** — the arc from idea to shipped/monetized result: outcome-framing → product-launch → monetize-or-opensource. *Why it matters:* the engineering frameworks get you working code; this gets you to a result that actually counts.

One thing it's deliberately **not**: a memory system. Claude Code now ships [native auto memory](https://code.claude.com/docs/en/memory) — Claude writes its own `user`/`feedback`/`project`/`reference` notes as it works, machine-local, learned emergently. Loadout *declares* the same kind of profile up front instead, in plain markdown you can read, `git diff`, version, and reuse across projects or hand to a teammate — a different tradeoff (reviewable, portable, but not self-updating), not a replacement. It's a *customer* of memory, not a competitor: `handoff-log` is a shape you can apply to a native auto-memory `project` note, a claude-mem entry if that plugin is installed, or a committed file — whichever storage the project already has.

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
  claude-mem     session capture, cross-session search, knowledge agents —
                 beyond what native auto memory's plain notes give you
  skill-creator, frontend-design  (Anthropic official)

LAYER 0 — Claude Code (native): auto memory (user/feedback/project/reference
          notes), .claude/rules/*.md path-scoped rules, /doctor CLAUDE.md
          trimming, the Agent Skills spec
```

The rule that keeps it coherent: when Loadout and Layer 1 could overlap, Loadout yields. The generated `CLAUDE.md` carries a **Layer Contract** that tells Claude to defer engineering execution to Layer 1 and reserves Loadout for voice, token budget, reasoning policies, and the path to outcome.

## The shape in one diagram

```
loadout/
├── README.md
├── LICENSE                          ← Apache-2.0 (code)
├── LICENSE-CONTENT                  ← CC-BY-4.0 (skill .md files)
├── install.sh                       ← layered install (Layer 1 + Layer 2); --standalone for copy-only
├── wizard.sh                        ← interactive personalization
├── core/
│   ├── CLAUDE.md.template           ← operator profile + Layer Contract; always copied, placeholders filled by wizard
│   ├── pitfalls.md                  ← reference for skill authors; stays in the repo, not copied to installed projects
│   └── skills/                      ← always copied to every project
│       ├── thinking/                ← cognitive foundations
│       │   ├── first-principles.md
│       │   └── systems-thinking.md
│       └── operating/               ← thin policies; execution delegated to Layer 1
│           ├── governing-algorithm.md   ← question → delete → simplify → accelerate → automate
│           ├── orchestration-policy.md  ← parallel vs. sequential; execution via GSD
│           ├── grounding-standard.md    ← ground claims before asserting
│           ├── ship-readiness.md        ← pre-ship gate: security + claim-integrity, delegates to Layer 1
│           ├── handoff-log.md           ← cold-session resume schema; storage is native auto memory, claude-mem, or a file
│           ├── reasoning-education.md   ← state the governing principle on non-obvious decisions
│           ├── token-discipline.md
│           ├── walkthrough-then-codify.md  ← Elon step 5: automate last
│           ├── recursive-refinement.md
│           ├── profile-me.md        ← the compounding engine
│           └── filing-protocol.md   ← stage-based project layout (1-problem→2-design→3-validation→4-test)
├── domains/                         ← thin adapters where best-in-class externals exist;
│   │                                  native only where none does
│   ├── scientific-python.md         ← adapter → scientific-agent-skills + operator standards
│   ├── academic-writing.md          ← adapter → academic-research-skills + humanizer
│   ├── data-analysis.md             ← adapter → scientific-agent-skills
│   ├── frontend.md                  ← adapter → frontend-design plugin
│   ├── backend-saas.md              ← adapter → superpowers/GSD + mattpocock/vercel skills
│   ├── infra-containers.md          ← native (rootless Podman, SELinux, devcontainers)
│   ├── engineering-simulation.md    ← native (power systems, microgrids, physical sims)
│   └── report-generation.md         ← native (PDFs via Quarto / Typst / HTML+print)
├── business/                        ← operator judgment, cherry-pick per project
│   ├── outcome-framing.md
│   ├── client-services.md
│   ├── digital-products.md
│   ├── automation-workflows.md
│   ├── ai-consulting.md
│   ├── marketing.md                 ← overlay → marketingskills (content + distribution policy)
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

The wizard asks ~9 questions (name, role, domains — toggle-checklist, not typed — voice, tooling, extra notes, a multi-select *outcome you're driving toward* that selects the business/meta skills, your *execution budget* — Free/Pro vs. Max/Team/API, which writes a directive constraining how often Layer 1's expensive multi-agent patterns get invoked, and whether this project wants the stage-based filing structure — `1-problem → 2-design → 3-validation → 4-test`, on by default), then writes a fully personalized `CLAUDE.md` (profile + Layer Contract) plus a curated skill set, and offers the layered/standalone choice. Either toggle menu has a "+ create a new skill from reference files" option that stages your notes in `.claude/skill-drafts/` for a later `walkthrough-then-codify` pass. Re-running is safe — existing files are backed up.

### Option 2: Preset

```bash
./install.sh ~/projects/myproject --preset engineering
./install.sh ~/projects/myproject --preset academic-research --standalone
```

| Preset | Domains | Business | Meta |
| --- | --- | --- | --- |
| `academic-research` | scientific-python, academic-writing, data-analysis, report-generation | — | — |
| `job-pipeline` | scientific-python, infra-containers | outreach-applications, automation-workflows | — |
| `engineering` | engineering-simulation, scientific-python, data-analysis, report-generation, infra-containers | — | — |

Three presets, curated for maintenance cost against zero assumed users — everything else (`backend-saas`, `frontend`, `outcome-framing`, `client-services`, `ai-consulting`, `marketing`, `digital-products`, `product-launch`, `monetize-or-opensource`, …) is still reachable via `--custom` below, or via the wizard's dynamic domain toggle and outcome-driven business selection, which don't go through presets at all.

Core (CLAUDE.md.template, thinking, operating) is always copied — every preset includes it. `pitfalls.md` stays in the repo for skill authors; it is not copied into installed projects. In preset mode, `CLAUDE.md` ships with placeholders unfilled — either edit by hand or re-run with `--wizard`.

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

### What not to commit

If a project uses the filing-protocol skill (`core/skills/operating/filing-protocol.md`), `install.sh` writes `reference/**` and `log/**` into the project's `.gitignore` unconditionally — the scaffold is public, the fill is not. `reference/` holds supplied material you don't have redistribution rights to: papers, client briefs, unpublished drafts. `log/decisions.md` and `log/questions.md` can carry candid rationale (a rejected approach, a client's actual constraint) not meant for a public repo. Either stays local unless you deliberately remove the ignore rule. Work in `2-design/` or elsewhere that isn't ready to be public is an authorial decision, not a filing rule — nothing in the structure publishes it for you, but nothing un-publishes it once you have: prior disclosure isn't undone by a later deletion, in this repo or a fork of it.

### Optional: devcontainer

The repo ships a `.devcontainer/` for running Claude Code in a network-sandboxed Linux environment (requires Docker + a devcontainer-aware tool). It is **not** required — `install.sh` and `wizard.sh` are pure bash and run anywhere.

## What gets installed

- `CLAUDE.md` — operator profile + Layer Contract (placeholders filled by wizard, or left for manual edit)
- `.claude/skills/thinking/*.md` — first-principles, systems-thinking
- `.claude/skills/operating/*.md` — the six governance policies (incl. ship-readiness, the pre-ship security + claim-integrity gate), token-discipline, walkthrough-then-codify, recursive-refinement, profile-me, filing-protocol (stage-based project layout)
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
5. Find which skills go unused: enable the OpenTelemetry [logs exporter](https://code.claude.com/docs/en/monitoring-usage) and set `OTEL_LOG_TOOL_DETAILS=1` so skill names are recorded verbatim instead of redacted. The `skill_activated` event records every invocation in its `skill.name` attribute; `invocation_trigger` records whether a command, Claude, or a nested skill invoked it — together they show what to consolidate or retire. (Source: Claude Code docs, [Set up Claude Code in a monorepo or large codebase → Keep skills discoverable](https://code.claude.com/docs/en/large-codebases#keep-skills-discoverable).)

Don't download skills from strangers without reading them first — they're instruction files; treat them like running someone's binary.

## Licensing

- **Code** (`install.sh`, `wizard.sh`): **Apache-2.0**. Patent grant explicit.
- **Skill content** (all `.md` files in `core/`, `domains/`, `business/`, `meta/`): **CC-BY-4.0**. Attribution required.

See `LICENSE` and `LICENSE-CONTENT` for the full text.

## Sources

**Primary** — cited for any factual claim about Claude Code's own behavior:

- **Anthropic** — official `anthropics/skills` repository, [Claude Code documentation](https://code.claude.com/docs), agent teams release notes

**Secondary — community, unverified.** Cited for design inspiration, curation choices, and methodology, not for claims about how Claude Code behaves:

- **Ross Mak** — skills + progressive disclosure + walkthrough-then-codify methodology
- **Nate Herk** — "I tried 100+ Claude Code skills, these 6 are the best" — plugin layer (skill-creator, superpowers, GSD, /review, context-mode, claude-mem, frontend-design) + outcome-selling principle
- **Claude Code tricks** — 32 tactical mechanisms compendium
- **ScriptByAI** — Ultimate Claude Code Resource List 2026 — broader ecosystem map
- **everything-claude-code** (Affaan Mustafa) — structural conventions, MCP discipline rules

## Comments & Contributions

Loadout grows by adapters, not by rewrites. If your domain or business workflow isn't covered, open a PR — but check `ecosystem/external-skills.md` first. If a best-in-class plugin already exists for your case, the right contribution is usually a thin adapter pointing to it, not a new native skill file.

Found a skill that misfired? Open an issue with the transcript. That's exactly the signal `recursive-refinement` is meant to act on, and it's useful even if you don't fix it yourself.

Questions, disagreements, "this analogy doesn't land for me" — all welcome in the issues tab. This is a personal layer that got open-sourced; tell me where it's still too personal.

## Author

I am Inigo, a vibe-coder with a generalist skillset looking for solving problems while having some fun. I work on different projects that usually solves some problem for me and publish it if I feel its useful for others too. You can contact me on m.inigoantony@gmail.com. Let me know if this project is useful or would like to collaborate on a new project. 

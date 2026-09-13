---
name: filing-protocol
description: Where to file a new artifact, how to name it, and what each CLAUDE.md may contain in a stage-routed project. Use when creating a project, adding a file, dropping in reference material, or unsure which folder something belongs in.
---

# Filing protocol

## Principle

Claude Code loads the root `CLAUDE.md` at launch and loads a subdirectory's `CLAUDE.md` only
when it reads a file in that subdirectory. A directory boundary is therefore a free,
zero-token-until-needed context switch — filing an artifact in the right directory *is* the
act of loading the right rules for it.

Corollary: never file by file type (`docs/`, `src/`, `notes/`). File by **stage of fidelity**,
because that is what changes which rules apply. Numbered folders are stages, worked in order;
unnumbered folders are used at every stage.

Scope against the Layer Contract: this skill owns the stage semantics and the card format,
because they encode how the operator works and thinks about a project's progress. It does not
own validation, CAD/solver tooling, or test execution — those are Layer 1's job, or the
domain's own tools. This skill only decides where evidence and decisions get filed, not how
they get produced.

## The structure

```
project/
  README.md          What this project is. Ten lines.
  CLAUDE.md           Working rules for AI tooling. Under 40 lines.

  1-problem/          What we are solving. Requirements, constraints, targets.
  2-design/           The thing itself. CAD, models, code, logic.
  3-validation/       Does it work on paper. Simulation, analysis, hand calculations.
  4-test/             Does it work in reality. Rigs, trials, instrumented data.

  reference/          Source material not written here. Standards, papers, briefs.
  log/                decisions.md, questions.md
  tools/              Scripts that extract, convert, or check things.
```

### Iteration is not a folder

Iteration is the path from `4-test/` back to `2-design/`. It is never a directory. A project
that grows `iteration-2/` ends up with three copies of everything and no way to tell which is
current. Supersede files instead — see `status` below.

## The card

Most engineering artefacts cannot be read as text: CAD parts, solver result decks, proprietary
model files. These stay in their own systems. What lives in the repository is a **card**: a
short markdown file recording where the real artefact is and what came out of it.

```markdown
---
what: chassis frame, rear subframe
from: NX / Teamcenter item 7742 rev C
evidence: sim
status: current
updated: 2026-09-14
---

Max von Mises 214 MPa at the rear mount under 3g braking.
Yield 275 MPa, margin 1.28.
Mesh 2.1M cells, run 2026-09-12-mesh3.

Regenerate: tools/extract_fea.py --run 2026-09-12-mesh3
```

A hundred of these can be searched, compared, and summarised in seconds — by a person or an AI
assistant — which is not true of a hundred result files. The card format does not change
between platforms: whether the artefact lives in Teamcenter, a SolidWorks directory, or a
solver output folder, only the `from:` line differs.

## The five fields

| Field | Meaning |
|---|---|
| `what` | Plain English, one line. |
| `from` | Origin: a tool and identifier, or another file in this repository. |
| `evidence` | `guess` · `hand-calc` · `sim` · `test` · `measured` |
| `status` | `draft` · `current` · `superseded` |
| `updated` | ISO date of last change. |

`evidence` is the field that matters most and the one most often skipped. It prevents a
back-of-envelope estimate being treated as equivalent to a measurement.

**Conflict rule:** when two files disagree, the stronger evidence wins. The weaker one is
marked `status: superseded` and kept. Nothing is deleted, and no folder is forked. This is how
iteration is recorded.

## Placement decision

- Idea, sketch, requirement, "should we even" -> `1-problem/`
- The thing itself: CAD, model, code, logic -> `2-design/`
- Simulation, analysis, hand calculation -> `3-validation/`
- Rig data, trial results, instrumented measurements -> `4-test/`
- A paper, datasheet, standard, API doc, transcript, screenshot -> `reference/`
- "We chose X over Y because Z" -> `log/decisions.md`
- An open unknown -> `log/questions.md`

If two stages could hold it, file it upstream. Upstream is cheaper to correct.

## Working rules

1. **One thing per file.** One part, one run, one decision.
2. **First line states what the file is**, so five lines of preview are enough to decide
   whether to open it.
3. **Names sort usefully.** `2026-09-12-mesh3.md`, not `final_v2_REAL.md`.
4. **No uncited numbers.** If a value came from a source, name the file in `reference/`. If it
   came from judgement, mark it `evidence: guess`.
5. **`log/decisions.md`** — one line per decision: date, what was chosen, what was rejected, why.
6. **`log/questions.md`** — open unknowns, written down rather than left as silent gaps.

## What each CLAUDE.md may contain

Root `CLAUDE.md`: stage semantics, the one-way flow rule, where `reference/` and `log/` live,
and pitfalls that differ from tool defaults. Not a file tree — Claude derives layout from the
filesystem, and `/doctor` deletes exactly that kind of content.

Per-stage `CLAUDE.md`: 3-5 lines. Only what changes *here*:

```markdown
# 3-validation/CLAUDE.md
Results here are simulated, not measured.
Always state mesh and boundary assumptions alongside any number.
Flag any result whose source geometry revision has changed.
```

Never state the same rule in two `CLAUDE.md` files — conflicting instructions resolve
unpredictably. Keep each one short: long files consume context and reduce how reliably
instructions are followed.

## Starting a project

```bash
mkdir -p 1-problem 2-design 3-validation 4-test reference log tools
touch README.md CLAUDE.md log/decisions.md log/questions.md
```

Create a folder only when it has something in it. An empty `4-test/` on a project that hasn't
been built yet is noise — stages you never use don't get created.

## Maintenance loop

1. When something gets filed in the wrong stage, the stage `CLAUDE.md` was ambiguous — fix it,
   not the file.
2. When two cards disagree, apply the conflict rule (stronger evidence wins, weaker superseded)
   before touching either artefact.
3. When the same correction gets typed twice, it belongs in a `CLAUDE.md`, not repeated in chat.
4. When a stage `CLAUDE.md` passes ~40 lines, split the stage or move procedure into a skill.

## Anti-patterns

- **`@imports` for scale.** Imports are expanded at launch; they organise but save nothing.
  Directories defer, imports do not.
- **An `iteration-N/` directory.** Supersede a card instead; see the conflict rule.
- **Documenting the file tree in `CLAUDE.md`.** Derivable, so it is pure context cost.
- **Verification nagging** ("always double-check", "re-read before answering"). On current
  models this triggers redundant re-checking. State the goal and the invariant; leave the
  method alone.
- **Filing by artefact type.** `docs/` and `notes/` carry no rule change, so they route nothing.

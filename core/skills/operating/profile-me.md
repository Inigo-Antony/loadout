---
name: profile-me
description: Refresh the personal layer from evidence — mine this session or an interview for voice, decisions, and recurring workflows, then update CLAUDE.md and personal skills. Invoke on "profile me", "learn from this session", or "make this a skill".
---

# Profile Me

The compounding engine. Sessions leave a trace — decisions made, corrections given, workflows repeated, skills that fired or misfired. This skill turns that trace into a sharper personal layer: an updated `CLAUDE.md` and refreshed `.claude/skills/*.md`. Run it repeatedly; each pass should make the next session start more "you".

Two modes. Pick by what evidence exists.

## Mode A — Session mining (preferred when there's a session to mine)

Invoke at the end of a substantial session, or pointed at one ("learn from this session", "update my profile from what we just did").

### A1. Harvest the trace

Scan the conversation (and, if installed, claude-mem's record of it) for five signal types:

1. **Corrections** — every time the user redirected output ("shorter", "no bullets", "use Podman not Docker", "stop asking, just do it"). Corrections are the highest-grade profile signal; they are revealed preference, not stated preference.
2. **Decisions + rationale** — non-obvious choices and the principle stated for them (see `reasoning-education`). These become standing rules or skill content.
3. **Voice in the wild** — how the user actually writes when they're not answering interview questions. Sentence length, bluntness, vocabulary that recurs.
4. **Skill hits and misses** — which skills fired and helped, which fired and were ignored or corrected, which workflow had *no* skill and clearly wanted one (the same multi-step dance performed twice = a candidate).
5. **Friction** — steps the user did manually and grudgingly. The "most annoying step" is the highest-value thing to codify.

### A2. Sort into the two write paths

**Direct-apply (no approval gate): voice and profile facts.**
Corrections to voice, tooling facts, OS/language preferences, and the current-focus line are low-risk and self-evidencing — apply them straight to `CLAUDE.md` with `Edit` (never `Write`; never clobber hand-edits; create `CLAUDE.md.bak` first if none exists). Then report what changed:

```
CLAUDE.md updated:
  ~ Voice: added "no bullet-point soup in prose" (you corrected this twice)
  ~ Tooling: Docker → Podman (correction, this session)
```

**Propose-as-diff (approval required): behavioral skills.**
New skills, or substantive rewrites of existing skill bodies, change how future sessions *behave* — and a misread session bakes the misreading in. Present each as a diff or full draft with the evidence line attached:

```
PROPOSED: .claude/skills/sponsor-research.md  (new)
  Evidence: you ran this workflow twice this session; the second run added
  the Trustpilot check after the first one missed a weak sponsor.
  [draft follows]
Approve, edit, or drop?
```

Only write on explicit approval. Name collisions go to `<name>.v2.md` for manual merge — never silently overwrite.

### A3. Close the loop

End with a delta report: what was applied, what was proposed, what evidence was *not* acted on (one occurrence ≠ a pattern — log it for next time instead). If a proposed skill came from a workflow that has never had a clean end-to-end run, route it through `walkthrough-then-codify` first.

## Mode B — Interview (no session to mine, or first deep pass after the wizard)

Compressed to the questions that earn their tokens. Keep the user's answers verbatim — the skill files should mirror the voice they used answering.

1. **What three workflows do you repeat most often?** For each: input, output, and the most annoying manual step (that step is what the skill must own).
2. **What voice do you NOT want?** Negatives are sharper than positives ("no corporate-speak", "no LLM throat-clearing", "no over-hedging"). They become explicit don't-rules.
3. **Tooling non-negotiables.** OS, languages and allergies, containers, MCPs, repo conventions.
4. **Reference markdown.** Ask for paths to notes/CV/prior CLAUDE.md/blog posts. Read them, extract voice and identity signals, **show what you extracted, and confirm before applying** — reference files may be old or written for a different audience.
5. **What outcome are you driving toward?** This keeps the profile pointed at brainstorm → shipped result, not at tooling for its own sake.

Then follow the same two write paths as Mode A: voice/profile facts applied directly, behavioral skills proposed for approval.

## Rules that hold in both modes

- **Evidence or it doesn't ship.** Codify from things that happened (twice, ideally), never from a hypothetical. Speculative skills are unfireable and bloat the set.
- **The set must stay small.** Each new skill is a standing ~50-token tax. When proposing one, also ask whether an existing skill should be retired or absorbed (`recursive-refinement` prunes; the `governing-algorithm` step 2 deletes). A profile-me pass that only ever adds is failing.
- **Specific beats general.** "Journal an options trade from a fill paste" fires; "help with finances" never does.
- **Don't fill silence with defaults.** If the user said nothing about file naming, the skill says nothing about file naming.
- **Idempotent re-runs.** Read the existing CLAUDE.md and skill list first; ask "add, or refine one of these?" instead of re-interviewing settled ground.

## See also

- `core/skills/operating/walkthrough-then-codify.md` — the codification method for workflows that need a clean run first
- `core/skills/operating/recursive-refinement.md` — fixing a generated skill after its first misfire
- `core/skills/operating/handoff-log.md` — the decision records Mode A mines

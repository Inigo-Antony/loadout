---
name: profile-me
description: Refresh the personal layer from evidence — mine this session or an interview for voice, decisions, and recurring workflows, then update CLAUDE.md and personal skills. Invoke on "profile me", "learn from this session", or "make this a skill".
---

# Profile Me

The compounding engine. Sessions leave a trace — decisions made, corrections given, workflows repeated. This turns that trace into a sharper `CLAUDE.md` and refreshed `.claude/skills/*.md`. Mine a session when there's one to mine; interview only when there isn't.

## Mine the session

Scan the conversation (and claude-mem's record of it, if installed) for:

- **Corrections** — every redirect ("shorter", "use Podman not Docker", "stop asking, just do it"). Revealed preference beats stated preference.
- **Decisions + rationale** — non-obvious choices and the principle behind them (`governing-algorithm`).
- **Voice in the wild** — how the user writes when not answering an interview.
- **Skill hits and misses** — what fired and helped, what fired and got corrected, what workflow ran twice with no skill covering it.
- **Friction** — the step the user did manually and grudgingly. That's the highest-value thing to codify.

## Two write paths

**Direct-apply — voice and profile facts.** Low-risk, self-evidencing: apply straight to `CLAUDE.md` with `Edit` (never `Write`; back up to `CLAUDE.md.bak` first if none exists). Report what changed, one line per change.

**Propose-as-diff — behavioral skills.** A new skill or a substantive rewrite changes future behavior, and a misread session bakes the misreading in. Show the draft with its evidence line, wait for approval, write only then. Name collisions go to `<name>.v2.md` — never silently overwrite. A skill proposed from a workflow with no clean end-to-end run yet goes through `walkthrough-then-codify` first, not straight to a draft.

Close with a delta report: applied, proposed, and evidence seen but not acted on (one occurrence isn't a pattern — note it for next time).

## When there's no session to mine

First pass after the wizard, or no substantial session exists yet. Ask only what earns its tokens: three most-repeated workflows (input, output, the annoying manual step), what voice to avoid (negatives are sharper than positives), tooling non-negotiables, and the outcome being driven toward. Keep answers verbatim — skill files should sound like the person who answered, not like a paraphrase. Reference files (CV, notes, prior CLAUDE.md) get read and their extracted signal shown back for confirmation before anything is applied — they may be stale or written for a different audience. Then the same two write paths as above.

## Rules that hold either way

- **Evidence or it doesn't ship.** Twice, ideally. Speculative skills are unfireable and bloat the set.
- **The set must stay small.** Every new skill is a standing token tax. When proposing one, also ask whether an existing skill should retire or absorb into it (`recursive-refinement` prunes; `governing-algorithm` step 2 deletes) — a pass that only ever adds is failing.
- **Specific beats general.** "Journal an options trade from a fill paste" fires; "help with finances" never does.
- **Idempotent.** Read the existing profile first; ask "add, or refine one of these?" instead of re-covering settled ground.

## See also

- `core/skills/operating/walkthrough-then-codify.md` — codification method for a workflow with no clean run yet
- `core/skills/operating/recursive-refinement.md` — fixing a generated skill after its first misfire
- `core/skills/operating/handoff-log.md` — the decision records this mines

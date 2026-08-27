---
name: handoff-log
description: On any major change or decision, write a structured log entry a cold session can resume from. Apply after architecture decisions, schema changes, scope changes, or completing a work phase.
---

# Handoff Log

A schema, not a memory system. Storage and retrieval are delegated to claude-mem (cross-session memory) and the repo itself (`docs/decisions/` or a `HANDOFF.md`, whichever the project already uses). This skill only fixes the *shape* of the entry, so a cold session can resume without re-deriving the state.

## When to write one

Major changes only: an architecture or dependency decision, a schema/API change, a scope cut, a phase completed, a direction reversed. Not every commit — commits already log themselves.

## The entry shape

```
## <date> — <one-line headline of what changed>
- **Decision/change:** what was done, concretely.
- **Why:** the governing reason in one or two lines (see `reasoning-education`).
- **Rejected:** the alternative(s) not taken, and why — this is what cold sessions
  re-litigate when it's missing.
- **State:** where things stand now — what works, what's broken, what's unverified.
- **Next:** the single most likely next action, with the file/command to start from.
```

Five fields, each one line where possible. If claude-mem is installed, it captures the session anyway — the entry's job is to be the *curated* record: the one paragraph you'd want surfaced first.

## The test

Read the entry as if you've never seen the project. If you'd still need to ask "but why is it like this?" or "where do I start?", the entry is incomplete. Fix the entry, not the reader.

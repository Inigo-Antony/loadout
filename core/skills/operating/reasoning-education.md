---
name: reasoning-education
description: On any non-obvious decision, state the governing principle in one line before moving on. Apply during design choices, trade-offs, rejections, and anything a reviewer might ask "why?" about.
---

# Reasoning Education

A behaviour, not a document. When making a non-obvious decision — choosing A over B, rejecting an option, accepting a cost — state the governing principle in one line, in the moment:

> Choosing SQLite over Postgres here — *single-writer local tool; operational surface should be zero* (governing principle: delete parts, don't add them).

## Why one line, in-context

- **The rationale stays where the decision is.** Future turns in this session reason *with* the principle instead of pattern-matching the surface choice.
- **It gets captured.** claude-mem and the `handoff-log` pick it up, so future sessions inherit the *why*, not just the *what*.
- **It educates both directions.** The operator sees which principle the model thinks is governing — and corrects it when wrong, which is the highest-value feedback a session can produce.

## The discipline

- One line. If the principle needs a paragraph, the decision deserves a `handoff-log` entry instead.
- Name the principle, not the vibe. "It's cleaner" is not a principle; "fewer moving parts to operate" is.
- Only non-obvious decisions. Annotating the obvious is noise that trains the reader to skip annotations.

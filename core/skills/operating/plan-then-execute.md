---
name: plan-then-execute
description: Default to plan mode for any non-trivial task. Have the agent ask clarifying questions until 95% confident in scope before writing or executing. Build verification steps into todos. Skip for clearly bounded one-line edits.
---

# Plan, then Execute

The single largest quality gain in agentic workflows is not jumping to action. The model is good enough that the bottleneck is alignment between what you want and what it understood — not its ability to produce. Plan mode forces alignment cheaply.

## The pattern

1. **Enter plan mode** (Shift+Tab in Claude Code, or just instruct the agent: "Don't write anything yet. Plan only.").
2. **Have it ask clarifying questions until ~95% confident.** Explicit instruction: *"Continue asking me questions until you're 95% confident you understand exactly what I need and exactly what you should do. Then propose a plan."*
3. **Review the plan.** Push back on vague steps. Ask the agent to identify the riskiest step and how it'd verify success there.
4. **Approve, then execute.** The agent generates a todo list. Build verification into it.

## Verification-aware todos

Every action todo gets a verification todo immediately after. Examples:

- "Build the form component" → "Take a screenshot of the form rendered" → "Open DevTools and confirm no console errors"
- "Refactor the data loader" → "Run the test suite" → "Diff the function signatures against the call sites"
- "Update the cover letter" → "Re-read against the job spec; flag any unaddressed requirement"

Plus: *"Don't proceed to the next todo until you're 95% confident the current one is complete."* AI will often produce 60–70% solutions in one shot. Forcing per-todo verification raises the floor.

## Treat the agent like a junior, not a tool

Instead of issuing commands ("write a function that does X"), give problems ("how should we handle growth tracking?"). When the agent reasons through the approach, you catch wrong assumptions before code is written. When you give a command directly, the model executes whatever interpretation it formed silently.

Shifts that matter:
- "Fix this bug" → "What's your hypothesis for the root cause?"
- "Refactor this file" → "What's the smallest change that addresses the actual issue?"
- "Add caching" → "What's the cache invalidation strategy and why?"

## When to skip plan mode

- Single-line edits, formatting fixes, type corrections — plan mode is overhead.
- Looking up information (research, doc lookups) — no execution to plan.
- Tasks the agent has already executed correctly multiple times.

## Reinforcing tools

- **Ultrathink** — for the planning step itself when the architecture is genuinely hard. Burn the 32k thinking tokens during plan mode, save them later.
- **Sub-agent for exploration** — spawn a sub-agent to map the codebase first; main thread plans against the summary.
- **Sequential workflow** — for plans with strict ordering, drive each step with explicit prompts; don't let the agent try to one-shot the whole pipeline.
- **`/review` (built-in)** — fast structured review of what was just built. Looks for bugs, edge cases, design issues. Local, cheap. Run it after every meaningful change.
- **`/ultrareview` (built-in, Claude Code 2.1.86+)** — uploads to a cloud sandbox and runs parallel reviewer agents (logic / security / performance / edge cases). Each bug must be independently reproduced before flagging — no false positives. 10–20 minutes, runs in background. Use for merges that actually matter (refactors, payments, auth, DB migrations). Pro/Max plans get free runs; otherwise $5–20.
- **`superpowers` plugin** — for production-grade work. Forces senior-developer rhythm: plan, isolated environment, tests-before-code, two-stage review (spec match + code quality). Most-starred community plugin (~170k★). See `ecosystem/plugins-to-install.md`.

## Common failure: the plan-execute drift

The agent writes a plan, you approve it, then it executes — but the execution doesn't actually match the plan. Mitigation: tell the agent to re-state the current todo at the start of every execution turn, and to flag any deviation from the plan as a question, not a silent decision.

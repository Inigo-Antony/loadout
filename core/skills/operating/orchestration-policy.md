---
name: orchestration-policy
description: Decide whether work runs parallel via subagents or sequential in one context. Apply when a task is large enough to split. The decision lives here; execution is delegated to GSD or the Agent tool.
---

# Orchestration Policy

A decision rule, not an orchestrator. Execution belongs to Layer 1 (GSD's subagent machinery, or Claude Code's native Agent tool). This skill only decides *when* to invoke it.

## Budget gate (check first)

Check the operator's CLAUDE.md "Execution budget" line before applying the rule below — it sets how much subagent fan-out the operator can actually afford, separate from whether a task is technically parallelizable.

- **Light** (Free/Pro plan, tight message budget): default to inline, sequential execution with self-review. Reserve multi-agent patterns like `subagent-driven-development` for fan-outs too large or independent for one context to hold safely, or for changes the operator explicitly flags as high-stakes. On small or mechanical tasks, skip the second (code-quality) review stage — self-review covers it.
- **Generous** (Max/Team plan, or pay-as-you-go API): apply the rule below without modification. Full multi-agent rigor (implementer + spec review + quality review per task) is the default for any non-trivial task.
- **Balanced / unset**: apply the rule below as written, but prefer fewer, larger task dispatches over many small ones — each subagent call has fixed overhead that's wasted on trivial work.

When in doubt about which tier applies, ask rather than assume the expensive default — a single clarifying question is far cheaper than an unwanted multi-agent run.

## The rule

- **Parallel** when the subtasks are *dynamic and independent* — research fan-outs, per-module audits, scraping N sources, anything where one worker's output doesn't change another's input. Spawn subagents; only summaries return to the parent context.
- **Sequential** when the subtasks are *step-by-step dependent* — each step's output is the next step's input, or components must agree on a shared decision (schema, API shape, naming). One context, one driver.
- **Default mode** when neither label clearly fits or the task fits comfortably in one window. Premature parallelisation costs more tokens, more latency, and more failure modes than it saves (pitfalls #6, #7).

## The test

Ask: *if two workers did these pieces without talking to each other, would the results still fit together?* Yes → parallel. No → sequential. "Mostly" → sequential; the integration step would otherwise become the real work.

## Autonomy caveat

Running with bypass-permissions makes fan-out cheap — and makes a confidently wrong subagent expensive. When parallelising, keep GSD's scope-reduction guard active and require each subagent's claims to meet the `grounding-standard` before integrating its output.

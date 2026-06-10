---
name: orchestration-policy
description: Decide whether work runs parallel via subagents or sequential in one context. Apply when a task is large enough to split. The decision lives here; execution is delegated to GSD or the Agent tool.
---

# Orchestration Policy

A decision rule, not an orchestrator. Execution belongs to Layer 1 (GSD's subagent machinery, or Claude Code's native Agent tool). This skill only decides *when* to invoke it.

## The rule

- **Parallel** when the subtasks are *dynamic and independent* — research fan-outs, per-module audits, scraping N sources, anything where one worker's output doesn't change another's input. Spawn subagents; only summaries return to the parent context.
- **Sequential** when the subtasks are *step-by-step dependent* — each step's output is the next step's input, or components must agree on a shared decision (schema, API shape, naming). One context, one driver.
- **Default mode** when neither label clearly fits or the task fits comfortably in one window. Premature parallelisation costs more tokens, more latency, and more failure modes than it saves (pitfalls #6, #7).

## The test

Ask: *if two workers did these pieces without talking to each other, would the results still fit together?* Yes → parallel. No → sequential. "Mostly" → sequential; the integration step would otherwise become the real work.

## Autonomy caveat

Running with bypass-permissions makes fan-out cheap — and makes a confidently wrong subagent expensive. When parallelising, keep GSD's scope-reduction guard active and require each subagent's claims to meet the `grounding-standard` before integrating its output.

---
name: automation-workflows
description: Operating instructions for building business automation using Claude + Zapier/Make/n8n + APIs. Apply when delivering automation to a client or building one for your own operations. Enforces reliability discipline (error handling, monitoring) over ship-and-pray.
---

# Automation Workflows

Automations break in production. The difference between a $500 one-off and a $2k+/month retainer is whether you treat reliability as a feature or hope it works.

## The trigger → process → action pattern

Every automation is the same shape:

```
trigger (event happens)
  → process (Claude or logic decides what to do)
  → action (something gets created, sent, updated)
  → log (record what happened)
  → fallback (handle the cases process didn't anticipate)
```

The first three are usually obvious. The last two are where junior automation work fails.

## Tooling selection

| Tool | Use when |
| --- | --- |
| **Zapier** | Fast prototyping, non-technical clients want to maintain it themselves, simple linear flows |
| **Make** (Integromat) | More complex branching, better debugging UI, lower per-task cost at scale |
| **n8n** | Self-hosted, no per-task cost, full control, technical client comfort, integrates with own infrastructure |
| **Direct code** (Python/Node) | Custom logic, performance-critical, integrates with code you already control |

Default: prototype in Zapier or Make to validate the flow with the client. Migrate to n8n or code only when the prototype has proven the shape.

## Adding Claude to the workflow

Claude (or any LLM) belongs in workflows where the input is variable and the output requires judgement, not transformation. Examples:

- **Good fits:** classifying inbound messages, drafting context-aware replies, extracting fields from unstructured documents, summarising long content, deciding routing based on intent
- **Wrong fits:** summing numbers, formatting strings, deterministic field mapping, anything a regex handles

When using Claude inside automations:
- Define the output schema strictly. JSON, validated. Don't trust free-form output to a downstream system.
- Provide examples in the prompt. Two or three examples beat any amount of instructions.
- Cap input length explicitly. Truncate before sending. A runaway input drives token costs and increases failure rate.
- Use the cheapest model that meets the bar. Most classification and extraction works on Haiku/Sonnet, not Opus.
- Set temperature low (0–0.3) for structured outputs. Higher only for genuinely creative steps.

## Reliability defaults

Each item below has saved a deployed automation from production failure at least once.

- **Idempotency.** If the trigger fires twice for the same event, the action runs once. Use IDs from the source system; check whether you've already processed this ID.
- **Rate limit handling.** Every API has a rate limit. Build in retries with exponential backoff. Fail loudly when exhausted, not silently.
- **Timeout handling.** Long-running steps need timeouts and a defined fallback. Workflows that hang for hours are worse than workflows that fail fast.
- **Logging every run.** Trigger received, decisions made, actions taken, errors encountered. Without logs, you cannot debug; you can only guess.
- **Monitoring.** At minimum: a notification when the workflow fails. Better: a daily digest of runs and outcomes.
- **Error routes.** What happens when the LLM returns garbage? When the API is down? When the input shape changed? Each branch needs an explicit handler, not a silent failure.

## Common workflows by industry

Patterns that pay because the underlying pain is universal:

- **Real estate:** lead enrichment, property description generation, follow-up sequencing, contract review extraction
- **HVAC / trades:** dispatch optimisation, customer SMS confirmations, invoice categorisation, review-request automation
- **Marketing agencies:** content calendar generation, social repurposing across platforms, weekly client reporting, ad copy variation
- **Coaches / professional services:** client onboarding sequences, session note summarisation, scheduling friction reduction, accountability check-ins
- **HR / recruiting:** applicant screening summaries, interview note synthesis, candidate communication automation, internal request triage
- **Accounting / bookkeeping:** receipt categorisation, document data extraction, monthly summary generation, follow-up on outstanding items

The common pain: high-volume routine work that the business owner currently does manually because they don't trust outsourcing the judgement. Claude does the judgement; the workflow does the volume.

## Pricing models

- **Setup + monthly retainer** — most common. Setup covers the build ($1k–$5k typical for one workflow); retainer covers maintenance, monitoring, optimisation ($300–$2k/month per active automation depending on complexity).
- **Per-action pricing** — for high-volume client work where you can measure. Risky if you bear API costs without a floor.
- **Outcome-based** — share of revenue/savings generated. Highest upside, requires trust and measurement.

Avoid pure one-off pricing. Automations need maintenance; if there's no recurring fee, maintenance becomes free work.

## Handoff to a non-technical client

The deliverable is not the workflow — it's a working automation the client can rely on. Include:

- A one-page operating doc: what triggers it, what it does, where outputs go, how to pause it, who to call
- A monthly "did it work" digest set up automatically
- Clear ownership of API keys (they own them, you have access for maintenance — never the reverse)
- Defined response time when something breaks ("I respond within 4 business hours, fix within 1 business day")

## When NOT to apply

- The volume doesn't justify the build. Automating something that happens twice a month is a hobby project, not a business case.
- The process isn't stable yet. Automating a workflow the client is still defining bakes in the wrong assumptions.
- Compliance/security constraints exclude cloud LLMs (medical records, legal privilege) — investigate self-hosted models or decline.
- Hard accuracy requirements that LLMs can't meet (financial calculations, legal determinations) — automate the routing and surface the work to a human, don't automate the decision.

## Anti-patterns

- Shipping without logging — you'll be blind during the inevitable production issue
- Hardcoding API keys in the workflow editor — they leak; rotate from day one
- Promising 100% accuracy with LLMs — set the bar at "much better than current" with human review for the failure cases
- Building the comprehensive workflow before validating one branch
- Letting the client run their own n8n instance you set up — they don't update it, it breaks, you get blamed

## See also

- `business/client-services.md` — the engagement structure around automation work
- `business/outcome-framing.md` — for proposing and pricing
- `business/ai-consulting.md` — when automation is part of a larger implementation
- `domains/backend-saas.md` — when the automation evolves into a real product

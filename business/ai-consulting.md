---
name: ai-consulting
description: Operating instructions for selling AI implementation services to businesses — discovery, proof-of-concept, rollout, training. Apply when the engagement is "help us actually use AI" rather than "deliver a specific automation". Enforces selling outcomes, validating with POCs, and pricing the implementation expertise rather than the AI itself.
---

# AI Consulting

The business of helping businesses adopt AI. Different from automation work in that the deliverable is *capability*, not a specific workflow — you're transferring know-how, not just shipping a tool.

## What clients are actually buying

Not Claude. Not GPT. Not "AI". They're buying:

1. **Implementation expertise** — the know-how to make AI actually work in their environment
2. **Customisation** — solutions adapted to their workflow, data, and constraints
3. **De-risking** — judgement on what to do, what to skip, where the failure modes are
4. **Training and enablement** — their team becomes capable after you leave
5. **Ongoing support** — someone to call when things break or when something new ships

Anyone can subscribe to Claude. Few can implement it well in a non-tech business.

## Discovery — finding the engagement

Most discoveries reveal one of three patterns:

- **The pile of repetitive work** — a workflow that consumes hours and follows similar logic each time. Best entry point. Quantifiable, demonstrable, fast win.
- **The bottleneck** — one step that gates the rest of the process (review, approval, classification). Highest leverage; highest visibility.
- **The unexplored opportunity** — "we could be doing X with AI but don't know how". Highest ambiguity; needs more discovery before scoping.

For each, ask:
- "How long does this currently take?"
- "Who does it now?"
- "What goes wrong, when it goes wrong?"
- "What's the consequence of getting it wrong?"
- "What would 'fixed' look like?"

The answers determine whether this is a $5k job, a $30k job, or not a job (don't sell engagements that won't deliver value).

## The engagement structure

A clean structure that prevents most disputes:

**Phase 1: Discovery audit (1–2 weeks, fixed price)**
- Walk the team's workflows
- Identify 3–5 candidate use cases
- Assess feasibility, value, complexity per candidate
- Deliverable: written audit ranking opportunities

This phase should be billed. Free audits attract tyre-kickers and signal that your time isn't valuable.

**Phase 2: Proof of concept (2–4 weeks, fixed price per use case)**
- Pick 1 candidate from the audit
- Build a working prototype with real client data
- Measure outcome against the baseline (current process)
- Deliverable: working POC + measurement

POCs validate before investment. Most POCs uncover something the discovery missed; better in week 3 than month 3.

**Phase 3: Production rollout (4–12 weeks, fixed or T&M)**
- Harden the POC into production-grade
- Integrate with their actual systems
- Train their team
- Document operations
- Deliverable: working system in production with documented operations

**Phase 4: Retainer (monthly, ongoing)**
- Maintenance and monitoring
- Optimisation as data accumulates
- Next-use-case scoping
- Deliverable: defined monthly hours/scope

This is where the recurring revenue lives. Most consulting engagements end too early because the consultant didn't propose the retainer.

## Pricing

Anchor on value, not effort. If discovery reveals a workflow consuming 20 hours/week × $80 average internal cost = $80k+/year of value, an $8k POC + $25k rollout pays back in months and is a bargain. If you priced on hours, you'd undersell by 5×.

Typical ranges (small-to-medium business clients in 2026):
- Discovery audit: $2k–$8k
- POC: $5k–$15k per use case
- Production rollout: $15k–$60k per use case
- Retainer: $1.5k–$8k/month per active system

For larger clients (enterprise, mid-market), multiply by 3–10×. The work is similar; the procurement structure pays differently.

## What you actually do during delivery

The technical implementation is only part of the work. The rest:

- **Stakeholder management.** The buyer is not always the user. The user has fears (am I being replaced?). The IT department has objections (what about security?). The legal department has questions (data residency?). Address each before they become blockers.
- **Process redesign.** Most workflows weren't designed; they evolved. Implementing AI on top of a tangled process inherits the tangle. Redesign first, automate second.
- **Data work.** Most of the difficulty in real implementations is data — wrong format, inconsistent structure, missing fields, scattered across systems. Budget more time for this than feels right.
- **Change management.** Your AI works perfectly and the team uses it for two weeks then reverts. The implementation didn't fail; the adoption did. Build training, documentation, and ongoing nudges into scope.
- **Measurement.** From day one, capture the baseline. Without it, you can't prove the outcome you delivered.

## Differentiation in a crowded market

Generic "AI consultant" pitches are crowded; specialisation isn't. Pick at least one of:

- **Industry vertical** — real estate AI, HVAC AI, accounting AI. Same pattern, different language and pain.
- **Function** — sales-team AI, customer-support AI, finance-ops AI.
- **Methodology** — "AI implementation in 30 days" with a clear playbook.
- **Stack** — Claude + n8n specialist; or AWS Bedrock specialist; or self-hosted LLM specialist.

The narrower your positioning, the easier to find clients and command premium pricing. Generalists chase work; specialists are sought.

## When NOT to take an engagement

- Client wants AI for AI's sake, not for a measurable outcome
- The data they'd run AI over is too messy/scarce/regulated to actually implement
- Decision-makers haven't bought in — middle-management champion alone won't survive an executive question
- Their accuracy requirements are higher than current LLMs reliably achieve and they won't accept human review
- The relationship feels off in discovery — trust your read

## Anti-patterns

- Free POCs that turn into free production work
- Pitching "AI strategy" without an implementation arm — strategy alone is hard to deliver value on
- Charging for hours when the value is the outcome
- Selling AI without including change management
- Building production-grade in week one (skip POC)
- Letting clients buy decision-making from you and then overrule it on opinion

## See also

- `business/outcome-framing.md` — for proposals and pricing
- `business/client-services.md` — engagement structure
- `business/automation-workflows.md` — frequent deliverable category
- The installed planning rhythm (superpowers/GSD) — internal discipline during delivery

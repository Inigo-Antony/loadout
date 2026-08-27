---
name: monetize-or-opensource
description: Take any project through a structured decision on whether to open-source it, monetise it, both (open-core), or hold. Apply when a project is approaching usability and you're considering what to do with it. Runs Phase 1 discovery, produces a Phase 2 recommendation, then delegates to sub-skills (open-sourcing or monetization) for Phase 3 execution.
---

# Monetize or Open Source

A meta-workflow that takes a project, asks the structured questions, makes a recommendation, and hands off to the appropriate execution skill. Designed for the moment when a project is functional enough to consider releasing — not for ideation, not for finished products.

## Phase 1 — Discovery (the questions)

Ask each in order. Don't propose anything until all are answered.

### Q1. What is the core deliverable?

Pick the closest:
- **Code/software** — runnable artifact others would download
- **Methodology/framework** — a way of doing things, documented
- **Data/dataset** — collected or derived data others would use
- **Insight/research** — findings from analysis or modelling
- **Tool/service** — something hosted that others would access

The category drives the path. Software → typically OSS or SaaS. Methodology → content + course. Data → publication or paid access. Service → consulting or product.

### Q2. Who else needs this?

- **Researchers** (academic peers) — open is conventional and rewards citations
- **Practitioners** (professionals doing similar work) — open builds reputation; paid works if outcome is clear
- **Specific industries** (real estate, HVAC, legal, etc.) — paid works; open doesn't reach them
- **Other developers / tech-savvy users** — open builds adoption; paid works if value is exceptional
- **You only / unclear** — neither path applies yet

### Q3. How much work is left to make it usable by someone else?

- **Days** (light packaging, README, examples)
- **Weeks** (proper docs, install path, edge cases, support)
- **Months** (production-grade hardening, hosting, customer support)

The remaining-work estimate calibrates the effort/return ratio for each path.

### Q4. What competing/related solutions exist?

- **Active OSS projects** in this space — joining the ecosystem may be more valuable than starting alongside
- **Commercial products** — there's a market; if you're not differentiated, the commercial path is harder
- **Nothing comparable** — strongest signal for releasing as either path; either you're early or there's no demand
- **Don't know** — go research before continuing

### Q5. What is your goal?

- **Income** — direct revenue from the project
- **Portfolio / reputation** — visible work for jobs, clients, or audience
- **Citations / academic credit** — if research is the context
- **Community / impact** — others using it matters more than money
- **Don't know yet** — that itself is the answer; the project isn't ready for this decision

### Q6. How sustainable is your continued involvement?

- **High** — willing to maintain, respond to issues, evolve for years
- **Medium** — willing to support for months, then archive or hand off
- **Low** — release-and-step-back; build for a community to take over or accept death-after-release

OSS without sustained maintenance becomes legacy fast. Monetised products without ongoing support churn customers. Match the path to your actual energy.

### Q7. What's your existing audience or distribution?

- **Substantial** (engaged email list, active social, established profile)
- **Modest** (some followers, some readers)
- **None** (starting from zero)

No audience makes monetisation slow; OSS distribution can compensate via inherent virality (if useful, gets shared in technical communities).

## Phase 2 — Recommendation

Combine the answers. The default mappings:

| Pattern | Recommendation |
| --- | --- |
| Researchers + research output + medium-to-low maintenance | **Open Source + paper** — release with permissive license; cite in publications |
| Specific industry + clear outcome + want income + can sustain | **Monetize** — productise or consult |
| Developers + general-purpose tool + want adoption + can sustain | **Open Source** — build community; revenue follows via consulting/sponsorship |
| Strong demand + defensible expertise + can sustain | **Open Core** — open the foundation, paid premium / hosted version |
| Genuine novelty + early stage + sustainability uncertain | **Hold** — iterate to validation before committing to a path |
| You-only audience + no clear external user | **Don't release yet** — keep working, revisit later |

The skill produces:
1. **The recommended path** with reasoning that ties to specific Q1–Q7 answers
2. **The honest critique** — what could go wrong with this path and what conditions need to hold
3. **The alternative** — the second-best path and why it's second-best
4. **The "what if" check** — does this still make sense if your time/energy/audience changes?

Important: the recommendation must call out the trade-time-for-money trap when relevant. If the recommended path is "monetise via consulting", the skill explicitly notes that consulting is hourly trade and asks whether owned-asset alternatives (digital product, SaaS, course) fit the project.

## Phase 3 — Execution

Once a path is selected, hand off to the sub-skill:

- **Open Source path** → load `meta/sub/open-sourcing.md`
- **Monetize path** → load `meta/sub/monetization.md`
- **Open Core (both)** → load both; sequence open-source first (the foundation), then monetize the premium layer
- **Hold** → produce a "next milestone before reconsidering" note and stop

The sub-skills handle the actual work: licenses, READMEs, validation interviews, MVPs, distribution, pricing.

## When NOT to apply

- Project is too early — Q3 says months and Q4 says nothing comparable yet; iterate first
- You're already committed to a path — this skill is for the *decision*, not for confirmation
- The project is purely personal (a learning exercise, a one-off script) — releasing has overhead with no return

## Anti-patterns

- Skipping discovery and going straight to a path because it's exciting
- Open-sourcing without sustained maintenance commitment (creates abandonware)
- Monetising before validation (high probability of zero customers)
- Open Core without enough differentiation between the open and paid layers (no one buys the paid version)
- Treating the recommendation as a contract — when conditions change, re-run the discovery

## See also

- `meta/sub/open-sourcing.md` — execution path for OSS release
- `meta/sub/monetization.md` — execution path for revenue
- `business/outcome-framing.md` — for the monetisation pitch language
- `business/digital-products.md` / `business/ai-consulting.md` / `business/automation-workflows.md` — common monetisation forms
- `core/skills/thinking/first-principles.md` — for challenging the "must release" assumption itself

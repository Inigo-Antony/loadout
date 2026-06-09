---
name: client-services
description: Operating instructions for delivering paid client work — discovery, scoping, contracts, execution, handoff. Apply when working with external clients on a paid engagement. Enforces scope discipline, written contracts, and the defaults that prevent the most common failure modes (scope creep, payment disputes, deliverable ambiguity).
---

# Client Services

A real client engagement has five phases. Most failures happen because one of the first three was skipped.

## Phase 1 — Discovery (before any quote)

Goal: understand the actual problem in their numbers. See `business/outcome-framing.md` for the discovery question structure. Outputs of discovery:

- The specific outcome they're paying for (in time, cost, or revenue terms)
- The current process (so you know what you're replacing)
- Who else is involved (decision-maker, end-user, gatekeeper, payer — often four different people)
- The constraints they don't think to mention until you ask (their existing tooling, IT/security restrictions, budget cap, timeline pressure, internal politics)
- A sense of how this relationship would continue past the first project

Do not quote at the end of a first discovery call. Schedule a follow-up; come back with a written proposal.

## Phase 2 — Proposal and contract

The proposal contains, in this order:

1. **The outcome** — one paragraph in their numbers. Not the workflow.
2. **Scope** — what's included, what's not. Itemise both. The "not included" list prevents the scope-creep conversations.
3. **Timeline** — milestones, not just an end date. Each milestone has a deliverable and a payment trigger.
4. **Price** — fixed where possible. If hourly, cap it. If value-based, define how value gets measured.
5. **Assumptions and dependencies** — what you need from them (data access, point of contact response time, existing accounts), and what happens to the timeline if those aren't provided.
6. **Out-of-scope handling** — "additional work beyond this scope is quoted separately at $X/hour or as a change order."

The contract is whatever closes the deal — an email exchange counts if the terms are explicit. For anything over a few thousand, use a real contract: SOW + MSA, or a one-page agreement with payment terms, IP assignment, confidentiality, liability cap, and termination clauses.

**Payment terms:**
- 50% deposit before work starts (smaller engagements: 100% upfront is fine and removes risk)
- Milestone payments tied to deliverables, not time
- Net-7 or net-14 terms; net-30 is borrowing from your business
- Late fees in writing
- For new clients: deposit clears before you open the IDE

## Phase 3 — Execution

The discipline that prevents the most pain:

- **Weekly written status update.** What was done, what's next, what's blocking. Two paragraphs; takes ten minutes; saves hours of "what's the status?" calls.
- **Single point of contact at the client.** All decisions through one person. Group chats with the entire team produce contradictions and slow you down.
- **Document decisions as they're made.** "We decided to skip the Salesforce integration in v1 — confirmed by Sarah on 12/3" — in writing, in a shared doc. Memory is unreliable; the doc isn't.
- **Change orders for anything outside scope.** "That's a great addition. It's not in our current scope — let me put together a quick change order." Keeps the relationship clean and protects your margin.
- **Demo early, demo often.** Don't wait until the end. Show working pieces every week or two. Early misalignment is cheap; late misalignment is expensive.

## Phase 4 — Handoff

Most engagements undervalue handoff. The client's experience of "is this thing actually working" is dominated by the two weeks after delivery, not the work that produced it. Invest in:

- **Written documentation** — what runs where, how to update, how to debug, how to contact you. Markdown, version-controlled if you've shipped code.
- **A walkthrough recording** — 15-minute Loom showing the deliverable in action and addressing the obvious "how do I..." questions.
- **Defined support window** — "30 days of bug fixes included; ongoing support available at $X/month." Don't leave this ambiguous.
- **Explicit "done" sign-off** — written or emailed acknowledgement that the deliverable matches the spec. Without this, "done" is contestable forever.

## Phase 5 — Retention

The cheapest revenue is the next project from a current client. After handoff:

- **30-day check-in** — "How's it working? Anything I should look at?" Catches issues early; signals you care.
- **Quarterly value review** — "Six months in, here's what we measured: [outcome numbers]. Here's where I think the next leverage is." Sets up the next engagement.
- **Retainer offers** — for clients with continuous needs, propose monthly maintenance/optimisation rather than letting them lapse.

## Pricing — practical defaults

- New service offering: under-price the first 2–3 to build case studies, then raise.
- After 5 successful engagements: prices double. (Most freelancers stay too cheap too long.)
- Don't list prices on your website — discovery is what reveals the right number for this buyer.
- For repeat work, lock pricing in a master agreement so each project doesn't re-negotiate.

## Anti-patterns

- Quoting on the discovery call ("for something like that, probably around $5k...") — you don't have the information yet
- Verbal-only agreements
- Doing extra work to be nice without a change order — sets a permanent precedent
- Letting the client run the technical decisions ("we want microservices") — they hired you for the judgement
- Net-30 terms with new clients
- Underestimating handoff and treating it as a chore
- Discounting in negotiation without removing scope; if the price comes down, the deliverables come down too

## See also

- `business/outcome-framing.md` — for discovery and proposal language
- `business/ai-consulting.md` — for implementation-heavy engagements specifically
- `business/automation-workflows.md` — common deliverable category
- `core/skills/operating/plan-then-execute.md` — internally, plan every phase

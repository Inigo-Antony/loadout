---
name: first-principles
description: Apply first-principles thinking (decompose → verify → rebuild) when an existing solution seems too expensive, too slow, or carries assumptions that may no longer hold. Use when entering a new domain or when incremental improvement has stalled. Skip for routine problems where analogy works.
---

# First Principles Thinking

Most reasoning is by analogy: pattern-match to a familiar case, apply what worked. Efficient, often correct, but it imports every assumption embedded in the prior solution. First-principles thinking decomposes the problem to constraints that cannot be violated without breaking reality, then rebuilds without inheriting the old assumptions.

## The three-phase loop

**Phase 1 — Identify and challenge assumptions.** Surface what's being taken for granted. Use the Socratic prompts: *Why is this the case? What evidence supports it? What if the opposite were true?* Distinguish three layers:

- **Fundamental constraints** (laws of physics, mathematics, verified cognitive limits) — cannot be challenged.
- **Probable truths** (evidence-based, revisable with better evidence).
- **Conventions** (historical practice, no strong evidence) — challenge aggressively. This is where leverage lives.

**Phase 2 — Break down to fundamentals.** Strip the problem to: *what is the actual goal*, *what physical/mathematical/logical requirements must be met*, *what is the minimum to satisfy those*? No historical baggage.

**Phase 3 — Rebuild from foundations.** Construct a solution using only verified fundamentals. Ignore "how it's done"; focus on "what must be done". Then test.

## When to apply

- Existing solutions are inadequate or absurdly priced relative to material reality (rocket components, EV batteries, cloud compute — the canonical cases).
- You're entering a new domain — you lack the analogies anyway, so reason from physics.
- Incremental optimisation has plateaued and the next gain feels asymptotic.

## When NOT to apply

- Routine problems where existing solutions work fine. First-principles overhead isn't free.
- Domains with hard-won safety knowledge (building codes, medical protocols, aviation regulation) — these aren't conventions; they're encoded lessons from fatalities. Use first principles to question which conventions are load-bearing, not to ignore them.

## Failure modes

1. **Confusing preferences with principles.** "Users want simple interfaces" is a preference. "Working memory holds ~7 items" is a constraint. The first produces fragile conclusions; the second produces robust ones.
2. **Stopping too early.** If your "principle" can be challenged with "but why is that true?", go deeper. "Cars must be heavy to be safe" → actual principle is "crash forces must be dissipated", which has many solutions.
3. **Arrogance toward domain expertise.** Building codes exist because buildings used to kill people. Use first principles to question conventions, not to ignore the lessons that produced them.
4. **Analysis paralysis.** Decomposition is hypothesis generation, not validation. Stop. Build. Test.
5. **Cherry-picking the starting principles.** Confirmation bias dressed up as rigour. Test which fundamentals actually apply.
6. **Mistaking simplification for first principles.** "Make something people want and charge more than it costs" is true and useless.

## Practical techniques

- **Five Whys** — drives past surface explanations. "We need to hire more support staff." Why? Ticket volume. Why? Customer confusion. Why? UX deprioritised. Why? Assumed features drive growth more than experience. The fundamental issue is an untested growth assumption, not a staffing shortage.
- **Component breakdown** — for cost problems, decompose the price into parts. Often most of the "cost" is one line item that wasn't visible at the aggregated level.

## Combine with second-order thinking

First principles tell you what's possible. Second-order tells you how the system will adapt. "Pay per line of code" follows the first principle that incentives drive behaviour; the second-order effect is that people write verbose, low-quality code. Always pair the two.

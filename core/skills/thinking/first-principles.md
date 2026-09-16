---
name: first-principles
description: Apply first-principles thinking (decompose → verify → rebuild) when an existing solution seems too expensive, too slow, or carries assumptions that may no longer hold. Use when entering a new domain or when incremental improvement has stalled. Skip for routine problems where analogy works.
---

# First Principles Thinking

Most reasoning is by analogy — pattern-match to a familiar case, apply what worked — which imports every assumption embedded in the prior solution. Decompose to constraints that cannot be violated without breaking reality, then rebuild without inheriting the old assumptions: separate fundamental constraints (physics, math, verified limits — not challengeable) from conventions (historical practice, no strong evidence — challenge these, this is where leverage lives), strip to the actual goal and the minimum that satisfies it, then rebuild from only the verified fundamentals.

## When to apply

Existing solutions are absurdly priced or slow relative to material reality; entering a domain where you lack the analogies anyway; incremental optimization has plateaued.

## When NOT to apply

Routine problems where existing solutions work fine — the overhead isn't free. Domains with hard-won safety knowledge (building codes, medical protocols, aviation regs) — those aren't conventions, they're encoded lessons from fatalities; use first principles to question which conventions are load-bearing, not to discard the lessons.

## Failure modes worth naming

- **Confusing preferences with principles.** "Users want simple interfaces" is a preference; "working memory holds ~7 items" is a constraint. Watch for "always"/"everyone"/"obviously."
- **Stopping too early.** If the "principle" survives one more "but why is that true?", go deeper.
- **Arrogance toward domain expertise.** Building codes exist because buildings used to kill people.

**Five Whys** drives past surface explanations when the real fundamental is buried — each "why" should hit a harder constraint than the last, not just restate the symptom.

Pair with `systems-thinking` for anything with feedback: first principles says what's possible, systems thinking says how the parts will behave once assembled.

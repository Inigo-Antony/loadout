---
name: recursive-refinement
description: When an existing skill produces a wrong or incomplete output, do not just retry. Diagnose the failure, fix the immediate run, then update the skill body so the same failure cannot recur. Apply every time a skill misfires.
---

# Recursive Skill Refinement

A skill is never finished after one walkthrough. Edge cases surface only in use. Each failure is a free improvement opportunity if you treat it correctly.

## The loop

1. **Skill fails.** Output is wrong, missing, or low-quality.
2. **Surface the error explicitly.** Ask the agent: *"What error did you encounter? What did you try? Where did it stop?"* The model will describe the failure descriptively if asked — "I got a 503 from the API", "I couldn't find the field because the schema changed", "I assumed X but the data shows Y".
3. **Fix the immediate run.** Pass the error back: *"You failed at [step]. [Specific correction.] Fix this and complete the task."*
4. **Once the run completes correctly, update the skill.** Prompt: *"With the fix applied, update the skill so this failure mode is handled. Add the check / the fallback / the guard. Keep the skill concise."*
5. The next invocation can't fail that way.

## What to update (and what not to)

**Update:**
- Steps that were missing
- Inputs that need validation before use
- API call shapes that actually work (the version that succeeded, not the version the model guessed)
- Decision rules that were too vague ("research the company" → "check Twitter, YouTube, Trustpilot, and funding")
- Fallbacks for the actual failure modes you've seen

**Don't update:**
- Edge cases you imagine but haven't seen — speculative additions bloat the skill and rarely match real failures
- Wording you don't like — if the output was correct but your phrasing preference differs, write that as a one-line preference, don't expand the whole skill
- General best practices — if the model already does the right thing without instruction, instructing it adds tokens for no benefit

## Why this works

Skills are imperfect on first write because you don't know which steps will fail until they do. After 3–5 iterations of this loop, the skill encodes the actual failure surface of the workflow, not your imagination of it. Ross Mak's YouTube report skill went through 5 cycles before becoming reliable; that's typical.

## The mental shift

The first instinct on failure is frustration: *"why didn't it work?"* The right instinct is gratitude: *"good — this would have failed silently in production. Now I can fix it."* Failures during refinement are cheap; failures during deployment are expensive.

## Anti-patterns

- **Retrying without diagnosis.** If you ask the agent to retry without understanding the failure, it'll fail the same way. (Or fail differently and confuse you further.)
- **Updating the skill before the fix is verified.** Confirm the fix produces the right output first, then codify. Don't bake in a guess.
- **Letting the skill grow unboundedly.** Each iteration should ideally net a small addition or a small clarification. If the skill is becoming a long checklist, it's a sign the workflow itself needs decomposition into multiple skills.

## When a skill is irreparable

If you've iterated 3–4 times and the skill keeps failing in different ways, stop refining and re-walkthrough from scratch. The original walkthrough probably wasn't a clean run, so the skill is built on a confused foundation.

## See also

- `core/skills/operating/walkthrough-then-codify.md` — generating skills correctly the first time

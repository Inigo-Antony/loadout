---
name: walkthrough-then-codify
description: Turn a recurring personal workflow into a skill by walking it manually with the agent until one clean run succeeds, then codifying that run. Never pre-write a skill from imagination; automate last.
---

# Walkthrough, then Codify

Step 5 of the `governing-algorithm`, made literal: **automate last**. By the time a workflow reaches this skill it should already have survived steps 1–4 — questioned (someone actually needs it, repeatedly), deleted down to its essential steps, simplified, and fast enough to be worth encoding. Automating anything earlier just scales waste.

A skill is a codification of a successful run, not a hypothesis about how a run should go.

## The problem this solves

The default attempt: identify a recurring workflow → ask the agent to write a skill for it → invoke. This fails reliably. The skill is born without context of what success looks like, so it omits the steps that mattered, includes steps that don't, and produces vague results.

The fix: treat the agent like a junior teammate on day one. You don't hand them an SOP and walk away — you do the task with them once, correct as they go, and only then write the SOP from what actually worked.

## The procedure

1. **Identify the workflow.** What's the input? What's the output? What's "done"? It must be *yours and recurring* — the whole point of a personal skill is that it fires again.
2. **Run it manually with the agent**, step by step. Evaluate each step's output. When it's wrong, say what's wrong and how to do it right — let it fail, then correct, so the correction enters the conversation.
3. **Continue until one complete run produces output you'd accept.**
4. **Then prompt:** *"Based on this conversation, create a skill I can reuse. It should accept [parameter] as input. Walk through the steps we just performed."* If the Anthropic skill-creator plugin is installed, let it do the formatting and packaging — this skill governs the method, not the file format.
5. The result is grounded in the actual successful path, corrections included. That's why it works.

## Why this beats writing the skill yourself

You don't know which steps mattered until they failed. The first time you run a sponsor-research workflow, you might think the skill is "research the company". After running it, you realise it's "check Twitter, YouTube, Trustpilot, and funding history; two weak signals → reject; four strong → draft a yes-response with the rate sheet attached". The structure only emerges from the run.

## Anti-patterns

- **Pre-writing from imagination.** Produces skills that "research the company" without saying what that means.
- **Codifying someone else's workflow.** Downloaded skills lack context of *your* run and are an attack surface besides. Walk your own.
- **Automating before deleting.** If the manual walkthrough felt bloated, the workflow needs governing-algorithm steps 2–3 first, not encoding.
- **Treating the first failure as proof the agent can't do it.** The first failure is data. Use it.

## When NOT to apply

- One-off tasks — codifying only pays if you'll reuse.
- Tasks the model already does well one-shot.
- Engineering execution rhythm — that's Layer 1's job (superpowers/GSD); don't codify a personal duplicate of what they already enforce.

## See also

- `core/skills/operating/governing-algorithm.md` — the five steps this is step 5 of
- `core/skills/operating/recursive-refinement.md` — what to do when the codified skill starts failing at edge cases
- `core/skills/operating/profile-me.md` — batch version: mines sessions for workflows worth codifying

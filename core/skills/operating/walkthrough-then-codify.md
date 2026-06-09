---
name: walkthrough-then-codify
description: When building a new skill or workflow, do not pre-write it. Walk through the workflow with the agent step-by-step until one full successful run is achieved, then ask the agent to convert the conversation into a skill. Use when a workflow is novel, ambiguous, or has failed when one-shot prompted.
---

# Walkthrough, then Codify

A skill is a codification of a successful run, not a hypothesis about how a run should go.

## The problem this solves

The default attempt: identify a recurring workflow → ask the agent to create a skill for it → invoke. This fails reliably. The skill is born without context of what success looks like, so it omits the steps that actually mattered, includes steps that don't, and produces vague results.

The fix: treat the agent like a junior team member on day one. You don't hand them a SOP and walk away — you do the task with them once, correct as they go, and only then write the SOP based on what they did right.

## The procedure

1. **Identify the workflow.** What's the input? What's the output? What's "done"?
2. **Run it manually with the agent**, step by step. After each step, evaluate the output. If it's wrong, tell the agent what's wrong and how to do it right. Do not skip — let it fail, then correct, so the correction enters the conversation.
3. **Continue until one complete run produces the output you'd accept.**
4. **Then prompt:** *"Based on this conversation, create a skill I can reuse. The skill should accept [parameter] as input. Walk through the steps we just performed."*
5. The agent writes the skill grounded in the actual successful path — including the corrections. That's why this works.

## Why this beats writing the skill yourself

You don't know which steps mattered until they failed. The first time you run a sponsor-research workflow, you might think the skill is "research the company". After running it, you realise the skill is "check Twitter, YouTube, Trustpilot, and funding history; if two of those are weak signals, reject; if all four look strong, draft a yes-response with the rate sheet attached". The structure only emerges from the run.

## Anti-patterns

- **Pre-writing the skill from imagination.** Produces vague skills that "research the company" without specifying what that means.
- **Downloading skills from elsewhere.** Skill marketplaces are an attack vector (skill files can include arbitrary instructions) and the skill won't have context of *your* workflow. Build your own.
- **Treating the first failure as proof the agent can't do it.** The first failure is data. Use it.
- **Skipping iterations.** One successful run is the minimum for codification. If the run was bumpy, do another walkthrough first.

## When to apply

- New workflow you'll repeat (research, generation, analysis pipelines)
- Existing skill that fires inconsistently — re-walkthrough and rewrite
- Onboarding a new tool/MCP into your routine
- Anything where the output quality matters and the steps aren't fully obvious

## When NOT to apply

- One-off tasks. Codifying takes time; only worth it if you'll reuse.
- Tasks where the model already does it well one-shot.
- Tasks too sensitive or variable for codification (creative writing where the point is variation).

## See also

- `core/skills/operating/recursive-refinement.md` — what to do after the skill exists and starts to fail at edge cases.
- `core/skills/operating/token-discipline.md` — why skills (progressive disclosure) beat instructions in CLAUDE.md.

# Pitfalls

A reference catalogue of failure modes. Not a skill — point Claude at this file when you want a pre-flight check before designing a new skill, agent, or pipeline. The negation of the rest of the library, concentrated.

## 1. Bloating CLAUDE.md / AGENTS.md

Every line you add costs tokens *every turn*. A 1,000-line file = ~7k tokens × every back-and-forth. Symptoms: sluggish sessions, quality degrades after a dozen turns. Don't put in CLAUDE.md: stack info the codebase reveals, general best practices, long style guides (those are skills), examples (those are skills), anything starting with "Always remember to…". Do put in: proprietary conventions, hard rules with consequences, a one-line pointer to where skills live.

## 2. Pre-writing skills from imagination

Skills built without observing a successful run fail in vague, hard-to-debug ways. Fix: walk through the workflow once with the agent, get a clean run, then convert. See `core/skills/operating/walkthrough-then-codify.md`.

## 3. Downloading random skills

Two failures in one. Security: a skill file is just instructions; a malicious one can tell the agent to exfiltrate secrets, modify other skills, run destructive commands. Treat them like running someone's binary. Context fit: even benign skills lack context of *your* workflow. Build your own; examine others' for ideas.

## 4. Confusing preferences with principles

"Users want simple interfaces" is a preference. "Working memory holds ~7 items" is a principle. Watch for "always", "everyone", "obviously" — usually preferences in disguise.

## 5. Over-engineering before the task is understood

Spinning up 30 skills, 15 sub-agents, three MCPs, and a custom hook system before completing one workflow manually. Common when the tooling is more exciting than the work. Fix: one agent, no skills, do the work. Add structure only when it earns its place.

## 6. Premature parallelisation

Sub-agents or agent teams when default mode would have worked. Costs more tokens, more latency, more failure modes. Default mode unless you have a specific reason. See `core/skills/operating/orchestration-policy.md`.

## 7. Sub-agents that needed to be a team

Two sub-agents producing components that must align (frontend/backend type definitions) without communication will drift. The integration step then *is* the work. If components must agree on a decision, don't isolate them.

## 8. Letting context fill to 90%+

Above 70% utilisation, output quality degrades. Above 85%, it falls off a cliff. Compaction at 90% loses material; at 60% it's clean. Status line on, always.

## 9. MCP overload

Each enabled MCP costs hundreds-to-thousands of tokens baseline. Ten MCPs can shrink usable context from 200k to 70k. Configure many globally; enable few per project (<10). Skip MCPs entirely when you only need 1–2 functions — call the API directly.

## 10. Skipping plan mode

Going straight to execution on non-trivial tasks. The agent forms an interpretation silently; you see misalignment in the output. Plan mode default. Force ask-until-95%-confident before action.

## 11. Retrying without diagnosing

A skill or task fails. You retry. It fails the same way (or differently and confuses the diagnosis). Ask the agent what error it hit. Describe it back. Fix the cause. Then update the skill. See `core/skills/operating/recursive-refinement.md`.

## 12. Fudging numbers in scientific code

Adding "engineering judgment factors" to make output match a target. The model becomes a curve-fit, not a model. If the model disagrees with literature, find the bug or document the difference.

## 13. Style filler in writing tasks

"I am passionate about", "I would love the opportunity", "I'm excited to apply". Noise. They displace specific, defensible claims. Specific verbs, specific outcomes, specific numbers.

## 14. Treating the LLM like it understands

It doesn't think. It predicts tokens. When it produces something that *feels* like understanding, training data was sufficient. When it fails, no amount of "but you understand X, right?" helps. Give it the steps explicitly. Walk through. Codify. Don't argue.

## 15. Arrogance toward domain expertise

First-principles thinking sometimes becomes an excuse to ignore people who actually know the domain. Building codes, medical protocols, aviation regs — those encoded fatalities. Use first principles to question which conventions are load-bearing, not to ignore the lessons.

## 16. The forever-refining skill

A skill that's been "almost ready" for ten iterations. Sign that the original walkthrough wasn't a clean run. Stop refining. Re-walkthrough from scratch.

## 17. Selling the workflow instead of the outcome

Pitching "I'll build you an AI workflow" to a business owner. They don't want a workflow. They want 10 hours back per week, fewer admin errors, faster lead response. See `business/outcome-framing.md`.

## 18. Building digital products without validation

The creation/marketing ratio for digital products is 20/80. Most products sell zero copies because creators don't market. Validate demand (pre-orders, audience interest, paid waitlist) before investing creation time.

## 19. Trade-time-for-money disguised as a business

Freelance + Claude is more efficient hourly trade. Income still stops when you stop. If the goal is freedom, not just better hourly rates, owned assets (digital product, SaaS, course, content) compound over time; service work doesn't. Pick deliberately.

## 20. Not maintaining the library

Skills go stale. APIs change, workflows evolve. A library untouched for six months has dead skills firing on tasks they no longer fit. When a skill misfires once, fix it. When it misfires twice, retire it.

---
name: governing-algorithm
description: The default approach to any task or requirement — question, delete, simplify, accelerate, automate, in that order. Apply before designing, building, or optimising anything non-trivial.
---

# The Governing Algorithm

Five steps, in strict order. Skipping a step or reordering them is how waste gets built, polished, and then automated.

1. **Question every requirement.** Whose requirement is it? Attach a person's name, not a department. A requirement from a smart person is the most dangerous, because you question it less. If nobody can own it, it isn't a requirement.
2. **Delete any part or process you can.** Bias hard to removal. If you're not adding things back ~10% of the time, you're not deleting enough.
3. **Simplify and optimise.** Only *after* deletion. The classic trap is optimising a part that shouldn't exist.
4. **Accelerate cycle time.** Speed up the loop — but only once steps 1–3 are done. A faster wrong loop is just faster waste.
5. **Automate. Last.** Automating a wasteful or wrong process scales the waste. Walk the workflow manually, then codify (`walkthrough-then-codify`), then automate.

## How this plugs into the rest of the stack

This skill is the *order of operations*, not the machinery. The machinery is delegated:

- Steps 1–2 are first-principles thinking applied to scope — pair with `thinking/first-principles`.
- Step 3 is systems-thinking on the workflow — pair with `thinking/systems-thinking`.
- For engineering execution after the scope is settled, hand off to the installed Layer 1 rhythm (superpowers/GSD). Do not re-plan what they plan.
- Step 5's codification path is `walkthrough-then-codify`; pruning afterwards is `recursive-refinement`.

## Applied to this library itself

Every proposed skill, plugin, or process addition passes the same gate: who asked for it (1), can we not have it (2), can it be thinner (3)? Most additions die at step 2. That is the point.

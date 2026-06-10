---
name: scientific-python
description: Operator standards for scientific Python — physics-grounded modelling, numerics, plots. Apply when wrong output could reach a manuscript or portfolio. Depth delegated to scientific-agent-skills.
---

# Scientific Python — adapter

**Depth lives elsewhere.** For library mechanics, method selection, and broad scientific workflows, defer to **K-Dense-AI/scientific-agent-skills** (install per `ecosystem/external-skills.md`) and to Context7 for version-pinned API docs. Do not reimplement that depth here.

What follows is the operator's non-negotiable overlay — the standards external skills won't enforce.

## Operator standards

1. **Validate against literature, not intuition.** Reproduce a published reference case within tolerance before trusting the model. "My RTE is 26% but published values are 45–62%" is a red flag, not a result — find the bug or document the boundary-condition difference. Never add fudge factors to hit a target.
2. **Every constant has a unit and a source.** `T_amb = 298.15  # K, ISO standard ambient` is acceptable; a bare number is not.
3. **Solve the physics; don't curve-fit it.** Energy/mass balances as assertions in the code, not afterthoughts.
4. **One command reproduces everything** from raw inputs. Pinned versions, explicit seeds, notebooks for exploration only — never the source of truth.

## Operator preferences

- NumPy/SciPy for numerics; Pandas only when data is genuinely tabular; **CoolProp** for fluid properties.
- Matplotlib for report figures (300 DPI, units on axes, colour-blind-safe palettes); Plotly only for interactive exploration.
- Economic outputs state discount rate, currency, and base year on every plot.

## See also

- `domains/engineering-simulation.md` — the system layer above the numerics
- `core/skills/operating/grounding-standard.md` — sources before assertions, everywhere

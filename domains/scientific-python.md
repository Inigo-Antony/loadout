---
name: scientific-python
description: Operating instructions for scientific Python work — modelling, numerical analysis, validation, plotting. Apply for any project involving thermodynamics, electrochemistry, energy systems, or other physics-grounded computation. Enforces literature-aligned validation and reproducibility.
---

# Scientific Python

This is for projects where the answer must be *correct*, not just plausible. LAES models, hydrogen infrastructure economics, electrocatalyst analysis, nuclear criticality calculators — code where wrong outputs could end up in a manuscript or a portfolio.

## Non-negotiable principles

1. **Validate against literature, not against intuition.** A model that produces "reasonable-looking" output but disagrees with peer-reviewed performance ranges is wrong, not novel. Cite the validation source explicitly in the code or a README.
2. **No hardcoded constants without a source comment.** Every magic number gets a unit and a citation. `T_amb = 298.15  # K, ISO standard ambient` is acceptable; `T_amb = 298.15` is not.
3. **Solve the physics; don't curve-fit it.** If the task is a thermodynamic cycle, write energy balances and solve iteratively. Hardcoded efficiencies that produce a target round-trip number are not a model — they're a fabrication.
4. **Show units.** Variable names or comments must carry units. Energy in J vs kWh vs kJ confusions are the most common bug.

## Project structure

```
project/
├── README.md           # what this models, key assumptions, validation status
├── pyproject.toml      # or requirements.txt — pin versions
├── src/
│   ├── core.py         # the model
│   ├── validation.py   # comparison against reference cases
│   └── plots.py        # plotting separate from compute
├── data/               # inputs (commit small data; .gitignore large)
├── results/            # outputs (gitignored)
├── tests/              # at minimum, conservation checks (mass, energy)
└── notebooks/          # exploratory work — not the source of truth
```

## Validation patterns

- **Reference case** — pick a published case (paper, textbook example) with known inputs and outputs. Code reproduces it within tolerance.
- **Conservation checks** — mass balance, energy balance, charge balance. These should be assertions in the code, not afterthoughts.
- **Limit cases** — what happens at extreme inputs the model should still handle? (Zero load, infinite capacity, T → 0K, etc.) Document expected behaviour.
- **Sensitivity analysis** — vary one input at a time across its plausible range. If the output is wildly sensitive to a parameter you can't measure, the model is fragile.

## Numerical hygiene

- Use `scipy.optimize` for iterative solvers, not hand-written Newton loops, unless you have a reason.
- Integer/float bugs and unit mismatches kill more results than algorithmic errors. Type-hint where it helps.
- For NPV/IRR, sensitivity heatmaps, or any economic analysis: state the discount rate, currency, and base year on every plot.
- Plots: minimum 300 DPI, axis labels with units, no chart-junk. `matplotlib` defaults are publication-grade if you label properly.

## Library defaults

- **NumPy** for arrays, vectorisation
- **SciPy** for optimisation, integration, special functions
- **Pandas** only when the data is genuinely tabular — don't reach for it as a default
- **CoolProp** for fluid properties (steam, refrigerants, hydrogen, air)
- **Matplotlib** for plots that go in reports/manuscripts; **Plotly** only for interactive exploration

## Reproducibility

- Pin Python version. Pin all package versions.
- One command should reproduce all results from raw inputs: `python src/main.py` or `make reproduce`.
- Random seeds set explicitly when stochastic.
- Keep data inputs and computed outputs in separate folders so a `rm -rf results/ && python …` doesn't lose anything irreplaceable.

## When the model disagrees with literature

Don't paper over it. Either:
1. The model has a bug → find it
2. The literature is doing something the model isn't (different boundary conditions, different assumptions) → document the difference
3. The literature is wrong or context-specific → state this with evidence

"My RTE is 26% but published values are 45–62%" is a red flag, not an interesting result. Investigate before publishing.

## Plotting principles

- Each plot answers one question. If a plot answers two, make it two plots.
- Comparison overlay > side-by-side panels when the comparison is the point.
- Axes start at zero unless there's a reason — and state the reason if not.
- Colour-blind safe palettes (viridis, cividis); avoid red/green binary distinctions.

## Anti-patterns

- Adding "engineering judgment factors" or fudge multipliers to make output match a target
- Plotting before validating
- Using Jupyter as the source of truth (notebooks rot; modules don't)
- Skipping the conservation check because "it's obvious it's conserved"

## See also

- `core/skills/thinking/first-principles.md` — for choosing assumptions to keep vs question
- `core/skills/thinking/systems-thinking.md` — for problems with feedback (energy systems, controls)
- `core/skills/operating/plan-then-execute.md` — model architecture decisions deserve plan mode

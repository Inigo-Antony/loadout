---
name: engineering-simulation
description: Build, validate, and sweep models of physical systems — power, thermal, fluid, electrochemical. Apply when sizing a microgrid, designing a tugboat power plant, modelling a refrigeration cycle, or any task where components, balances, and a duty cycle determine whether the design works. Enforces component-level modelling, conservation checks, and scenario sweeps over single-point answers.
---

# Engineering Simulation

For projects where the deliverable is a defensible answer about a *physical system* — what battery does the house need, what does the ammonia tugboat's auxiliary load look like at 60% MCR, does the heat pump COP hold at -7 °C. Different from a generic Python model because the system is the unit of analysis: components, the connections between them, the duty they're asked to do, and the operating envelope.

Pair with `scientific-python` for the numerics layer. This skill governs the *system* layer that sits above it.

## Non-negotiable principles

1. **Decompose into components before writing code.** Draw the block diagram. Each block has inputs, outputs, parameters, and an internal model — even if the internal model is one equation. No simulation should be written before the block diagram exists, on paper or in a docstring.
2. **Solve balances, not vibes.** Energy in = energy out + storage change + losses. Mass in = mass out + accumulation. Charge conservation if there are batteries. If a balance isn't enforced as an assertion, the model is unverified.
3. **Validate every component against its datasheet or a published map.** A battery model with no efficiency curve, an inverter at 100% always, a heat pump with constant COP — these are not models, they are placeholders. Note the source on every parameter.
4. **Single-point answers are wrong.** Real systems operate across a duty cycle and an envelope. The deliverable is a sweep — duty hours, ambient temperature range, load profile — not one number.
5. **State the boundary.** What's inside the model and what's exogenous (grid tariff, weather, demand profile)? Anything exogenous needs a stated source and stated assumption.

## Phase 1 — Frame the system

Before any code:

- **What is the system delivering?** Power, heat, propulsion, cooling, hydrogen at a pressure. Quantify: peak, average, profile over time.
- **What are the components?** Generation, conversion, storage, loads. List them with rated capacity and the parameter that matters most (η, COP, C-rate, etc.).
- **What's the duty cycle?** Hourly load profile for a day / season / year. Real data if available; if synthetic, state the synthesis method.
- **What's the envelope?** Ambient temperature, solar irradiance, sea state, grid availability — whatever the system has to keep working across.
- **What is success?** RTE > X%, LCOE < Y, autonomy ≥ Z hours, peak shaving by W kW. Numeric, with units.

Push back on "model the power system" — that's not a brief. The brief is "size the battery so the house runs autonomously through a 3-day winter outage at design ambient -5 °C, given the existing 6 kWp PV and the metered 2024 load profile."

## Phase 2 — Build the component models

Each component is a function or a class with:

- A docstring stating the source (paper, datasheet, manufacturer curve)
- Parameters with units in the variable name or comment
- A `validate()` method or test that reproduces a known operating point

Examples:

```python
def battery_efficiency(soc: float, c_rate: float, T_C: float) -> float:
    """Round-trip efficiency for a Li-ion pack.
    Curve fit to Tesla Powerwall 2 spec sheet (rev 2024-03) over
    SOC ∈ [0.1, 0.95], C ∈ [0.1, 0.5], T ∈ [0, 40] °C.
    Outside this envelope: extrapolation; flag rather than silently use."""
    ...
```

If you can't write the source comment, you don't have a model. Stop and find the source.

## Phase 3 — Connect them

A solver, an ODE, a discrete-time loop, or a static balance. The connection layer enforces conservation:

- Energy balance at every time step
- Mass balance for working fluids
- State-of-charge bounded [0, 1]
- Power flows respect the sign convention you defined

Every conservation check is an `assert` in the code, not a comment. If the solver violates conservation, the simulation is wrong and the run aborts loud.

## Phase 4 — Sweep the envelope

Single runs are for debugging. Deliverables are sweeps:

- **Duty sweep** — annual hourly simulation; report by day, month, season
- **Sizing sweep** — battery from 5 to 50 kWh, PV from 4 to 12 kWp; surface the Pareto
- **Sensitivity** — vary each uncertain parameter ±20%; rank by effect on the success metric
- **Stress cases** — design ambient, design load, 3-σ irradiance, worst-case duty

The plot that decides the design is a **contour or heatmap over the two key sizing dimensions** with the success metric as colour. Single number deliverables (`"the battery should be 20 kWh"`) are almost always lying about the underlying tradeoff.

## Phase 5 — Validation

- **Reference case** — pick a published system (a literature microgrid, a textbook cycle) and reproduce its numbers within tolerance. Cite it.
- **Limit cases** — zero load, infinite storage, T → 0, infinite duty. The model should degrade sensibly or refuse cleanly, never silently lie.
- **Independent sanity** — back-of-envelope each top-line number a different way. If the model says the system produces 12 MWh/yr and your 5-minute mental check says 4 MWh/yr, one of them is wrong; investigate before defending either.

## Reporting the result

The output is not just a number; it's a defensible recommendation. Minimum artefacts:

1. **Block diagram** of the system
2. **Component table** — parameter, value, source, uncertainty
3. **Duty cycle plot** — what the system was asked to do
4. **Sweep plot(s)** — the design space, with the chosen point marked
5. **Validation note** — what was checked against what
6. **Key risks** — exogenous assumptions that, if wrong, kill the design

For long-form delivery, hand off to `report-generation`.

## Library defaults

- **NumPy + SciPy** for solvers
- **CoolProp** for working fluids (ammonia, H₂, refrigerants, steam, air)
- **PVLib** for solar
- **pandapower / PyPSA** for grid-side power flow
- **Pyomo** for optimisation-formulated sizing problems
- **Matplotlib** for the report figures; **Plotly** only for exploratory dashboards

## When NOT to apply

- The task is pure curve-fitting or pure data analysis with no physical model → use `data-analysis` instead
- The task is a control law, not a sizing or feasibility question → that's controls work, different shape
- The deliverable is a one-line "is this physically plausible" sanity check → don't build a simulator for it
- Component models don't exist and can't be sourced → flag and stop; faking the components produces fake answers faster

## Anti-patterns

- "Engineering judgment factors" or fudge multipliers that make the output match a target
- Constant-efficiency components ("assume 95% inverter") used as load-bearing — anywhere a curve matters, use a curve
- One-shot simulations presented as "the answer" with no sensitivity
- Mixing units silently (kW vs kWh; MWh/yr vs MWh/day) — the most common bug
- Plotting before validating against a known case
- Treating Excel as the source of truth — version-controlled Python with tests, or it doesn't exist

## See also

- `domains/scientific-python.md` — for the numerics layer (solvers, validation patterns, plotting)
- `core/skills/thinking/systems-thinking.md` — for systems with feedback (controls, market interaction, dispatch)
- `core/skills/thinking/first-principles.md` — for choosing which assumptions to keep vs question
- The installed planning rhythm (superpowers/GSD) — the system frame deserves plan mode before any code
- `domains/report-generation.md` — for delivering the result as a defensible PDF

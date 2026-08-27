---
name: frontend
description: Operator standards for UI and web design — taste discovery before generation, accessibility baseline. Depth delegated to the frontend-design plugin.
---

# Frontend — adapter

**Depth lives elsewhere.** Design tokens, component patterns, and styling conventions come from Anthropic's **frontend-design** plugin (installed by the layered setup); TypeScript engineering depth from **mattpocock/skills** if needed. This overlay is the operator's taste-and-process layer.

## Operator standards

1. **Discover taste before generating.** Ask for 2–3 reference sites, mood (editorial/utilitarian/brutalist/minimal), density, and brand constraints. If the request is "make a landing page" with none of this, ask first — one round of clarification beats three rounds of generation.
2. **Accessibility is the baseline, not a pass.** Contrast ≥ 4.5:1 body text, keyboard-reachable interactive elements with visible focus, semantic HTML, labelled inputs, meaning never carried by colour alone.
3. **Wireframe before pixels.** Low-fidelity structure → one high-fidelity core page → build out only after the aesthetic is approved. Never five pages before one is confirmed.

## Operator preferences

- One display face + one body face, sizes on a scale; a 4/8px spacing scale; one neutral ramp + one accent; one corner radius used consistently.
- Reserve motion for elements that benefit; no autoplaying video, no scroll-jacking, no first-visit modals.
- Lighthouse ≥ 90 mobile for marketing pages.

## See also

- `domains/backend-saas.md` — the application behind the UI

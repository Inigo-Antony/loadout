---
name: data-analysis
description: Operator standards for data analysis and document extraction — validate before interpreting, statistical honesty, provenance. Depth delegated to scientific-agent-skills.
---

# Data Analysis — adapter

**Depth lives elsewhere.** For statistical methods, EDA mechanics, and modelling workflows, defer to **K-Dense-AI/scientific-agent-skills** (see `ecosystem/external-skills.md`). This overlay is the operator's standards layer.

## Operator standards

1. **Validate before interpreting.** Inspect raw data first (`df.info()`, missingness, duplicates, units). Most analytical errors are upstream of the analysis.
2. **Statistical honesty over narrative.** "No significant difference" is a result; don't fish for the framing that produces a story. Effect sizes with p-values; correction for multiple comparisons; no causal claims from correlational data.
3. **Show uncertainty.** Point estimates without intervals or error bars mislead by omission.
4. **Reproducible from raw inputs.** Cleaning is code, never manual edits; one command rebuilds every figure and number.
5. **Provenance on extractions.** For document/unstructured work: define the schema first, spot-check 10% against source, keep a pointer from every value back to its document.

## Reporting preference

Lead with the headline finding in one sentence; methods, figures, limitations after. Executives read the headline layer; peers scrutinise the methods layer — write both, in that order.

## See also

- `domains/report-generation.md` — when the analysis becomes a deliverable document
- `core/skills/operating/grounding-standard.md` — the same rule, generalised

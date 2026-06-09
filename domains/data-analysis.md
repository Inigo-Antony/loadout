---
name: data-analysis
description: Operating instructions for data analysis, BI, document extraction, and report generation. Apply when the deliverable is insight from data rather than a model or application. Enforces validation before interpretation and statistical honesty over narrative.
---

# Data Analysis

## Non-negotiable principles

1. **Validate before interpreting.** Look at the data. Histogram every variable. Plot pairwise relationships for the key ones. Most analytical errors are upstream of the analysis — wrong column, missing data treated as zero, units mismatched, duplicates not deduplicated.
2. **Statistical honesty over narrative.** If the result is "no significant difference", that's the result. Don't fish for the framing that produces a story.
3. **Reproducibility from raw inputs.** One command (or one notebook executed top-to-bottom) reproduces every figure and number in the report.
4. **Show uncertainty.** Point estimates without confidence intervals or error bars are misleading by omission.

## Project structure

```
analysis/
├── README.md           # question, data sources, key findings
├── data/
│   ├── raw/            # never edited, gitignored if large
│   └── processed/      # outputs of cleaning steps
├── notebooks/          # exploratory; not the source of truth
├── src/
│   ├── clean.py        # raw → processed
│   ├── analyse.py      # processed → results
│   └── plots.py        # plotting separate from analysis
├── results/            # tables, figures, gitignored
└── report/             # the deliverable
```

## The pipeline

1. **Define the question precisely.** "Are conversion rates different between cohorts?" is well-defined; "How is the marketing performing?" is not. If you can't write the null hypothesis or the comparison structure, refine the question first.
2. **Identify the data needed.** What columns? What time range? What filters? What's the population? Write this *before* opening the data.
3. **Inspect raw data.** `df.info()`, `df.describe()`, `df.isna().sum()`, value counts on categoricals. Look for duplicates, outliers, dates that aren't dates, encoding issues.
4. **Clean deterministically.** Cleaning is code, not manual edits. Each cleaning step justified in a comment.
5. **Analyse.** Apply the chosen method — descriptive stats, hypothesis test, regression, segmentation, time-series decomposition. Document assumptions; check them.
6. **Visualise.** One plot per claim. Tables for exact numbers; plots for shapes and trends.
7. **Report.** Lead with the answer. Methods and caveats follow. Limitations explicit.

## Statistical hygiene

- **Sample size before significance.** A p-value with n=8 means almost nothing.
- **Effect size always.** Statistical significance ≠ practical significance.
- **Multiple comparisons get correction** (Bonferroni, FDR) when relevant. Don't run twenty t-tests and report the "significant" ones.
- **Confounders identified explicitly.** Especially for observational data — A correlates with B, what else moves with A?
- **Time-series respects autocorrelation.** Standard regressions over time often understate uncertainty by orders of magnitude.

## Document and unstructured-data work

When the source is contracts, reports, transcripts, or other long-form documents, Claude's long context window is your tool — but:

- **Define the extraction schema first.** What fields? What types? What's the answer when the field is absent? Write the schema, *then* extract.
- **Spot-check 10% of outputs against the source.** Extraction quality drops silently as documents get heterogeneous.
- **Preserve provenance.** Every extracted value has a pointer back to the source document and ideally the page/paragraph.
- **Aggregate carefully.** Sums across documents with different definitions of the same field produce nonsense.

## Plotting standards (publication-grade by default)

- One question per plot
- Axes labelled with units
- Reference lines (zero, baseline, target) where they aid reading
- Annotations for the key points the reader should see
- Avoid: dual y-axes, 3D charts, exploded pies, rainbow colormaps, charts with more than ~7 categories

## Reporting

Lead with the headline finding in one sentence. Then methods (what data, what cleaning, what analysis). Then results with figures. Then limitations and caveats. Then technical appendix for reproducibility detail.

For executive audiences, the headline-and-figures version is usually all that gets read. For peer audiences, methods and limitations get scrutinised. Write both layers; place them in the order the reader will encounter them.

## Anti-patterns

- Cleaning data manually in Excel and never being able to reproduce
- Running the same analysis twenty different ways and reporting the prettiest result
- Treating missing values as zero without checking what they mean
- Plotting without axis labels or units
- Drawing causal conclusions from correlational data
- Over-fitted predictive models with cherry-picked train/test splits
- Reporting without limitations

## See also

- `domains/scientific-python.md` — for the modelling/computational side
- `domains/academic-writing.md` — when the analysis goes into a manuscript
- `business/seo-and-marketing.md` — when the analysis is for marketing/growth questions

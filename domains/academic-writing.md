---
name: academic-writing
description: Operating instructions for academic writing — manuscripts, coursework reports, theses, conference papers. Apply when the deliverable is structured for peer or examiner review. Enforces citation discipline, IMRaD structure where appropriate, and converts coursework drafts into publication-ready form.
---

# Academic Writing

## Non-negotiable principles

1. **Every claim is either common knowledge, derived in the text, or cited.** No middle category. If you're stating a fact about the world that the reader could disagree with, cite it.
2. **Citations match references match a real, accessible source.** No phantom papers. The model hallucinates DOIs more often than you'd think; verify each one.
3. **Methods reproducible from the text alone.** If a competent reader can't replicate your work from what you wrote, methods is incomplete.
4. **Results section is descriptive, not interpretive.** Discussion is interpretive. Don't blur them.

## Structure (IMRaD by default; deviate with reason)

- **Introduction** — what's the question, why does it matter, what gap does this work fill, what did I do? End the intro with a one-paragraph summary of the contribution.
- **Methods** — enough detail for replication. Cite standards or prior work for any procedure not novel.
- **Results** — what was observed/measured. Figures and tables carry the load; text points to them. Statistics with effect sizes, not just p-values. No interpretation here.
- **Discussion** — what the results mean, comparison to prior work, limitations, implications. Limitations section is mandatory; absence reads as oversight.
- **Conclusion** — single short paragraph. What this work added; what's next.

For coursework reports without IMRaD framing, use: context → approach → findings → reflection. Same discipline, lighter structure.

## Citation discipline

- Cite original sources, not aggregators. Wikipedia is not a citation; the source Wikipedia cites might be.
- Recent reviews are useful for grounding but cite the primary work for specific claims.
- Self-citations only when relevant and not gratuitous; reviewers notice.
- Format consistently — pick one style (IEEE, Harvard, APA, ACS — match the venue) and stay there.
- DOIs verified, not invented. If a reference can't be found via DOI/Google Scholar/Crossref, replace it with a real source making the same claim.

## Writing rules

- **Active voice when feasible.** "We measured X" beats "X was measured" — though some venues still expect passive in methods.
- **One claim per sentence.** Dense academic prose is dense because of evidence, not subordinate clauses.
- **Hedge claims at their actual confidence level.** "Suggests" for early-stage results, "demonstrates" only when the evidence supports it. Reviewers downgrade overclaims more reliably than they upgrade underclaims.
- **Define abbreviations on first use.** Even ones that feel universal in your subfield.
- **Numbers with units, decimals consistent across tables and figures.**

## Figures and tables

- Each one stands alone — caption tells the story without requiring the body text.
- Axes labelled with units. Legend present if more than one series. Colour-blind safe palette (viridis, cividis).
- Resolution: 300 DPI minimum for print, vector preferred. PDF or SVG, not PNG of a screenshot.
- Tables: only when the data isn't better as a figure. Right-align numbers, decimal points aligned within columns.

## Coursework-to-manuscript conversion

When converting a coursework report into a paper:

1. **Identify the contribution.** What does this paper add to literature that wasn't there before? If you can't answer in one sentence, the paper isn't ready — refine the contribution before writing.
2. **Cut the parts that exist for the marker, not the reader.** Coursework contains "show your understanding" sections (definitions of well-known concepts, demonstration of methodology choice). Strip them; the reader either knows or has read your cited prior work.
3. **Tighten methods.** Coursework methods often over-explain rationale. Keep what's needed for replication; remove rationale that belongs in the introduction.
4. **Strengthen results.** Coursework results often present and interpret in one breath. Split them. Numbers and figures in results; meaning and comparison in discussion.
5. **Add literature comparison.** Coursework can get away with citing methodology sources only. Manuscripts need to position findings against prior results.
6. **Honest limitations.** Coursework rarely has a real limitations section; manuscripts always do.

## Writing pace

A first draft is supposed to be bad. Get it down, then revise. Common failure: revising the first paragraph for an hour before writing the rest. Skip the introduction in the first pass; write it last when you know what the paper actually says.

## Anti-patterns

- Padding word count to hit a coursework requirement; markers and reviewers both detect it
- Restating the abstract in the conclusion
- Using "novel" without specifying what's novel
- Burying the contribution in paragraph three of the introduction
- Hedging vocabulary that doesn't match the strength of evidence ("might suggest a possible indication")
- Methods written from memory rather than from notes — you'll forget the parameter you tweaked
- Reusing figure styling from coursework templates that look obviously academic-default

## See also

- `domains/scientific-python.md` — for code/figures generated alongside the paper
- `domains/data-analysis.md` — for statistical and analytical methods
- `core/skills/thinking/first-principles.md` — for choosing what to cite vs derive

---
name: skill-creator
description: Author a new skill from a successful walkthrough. Invoke after completing a workflow you want to reuse. The skill produces frontmatter + body grounded in the actual successful run, not in imagination. Hands off to Anthropic's official skill-creator plugin if installed; otherwise produces the file directly.
---

# Skill Creator

Two modes — pick by what's installed.

## Mode A: Anthropic's skill-creator plugin (recommended if installed)

If `skill-creator` plugin is available (`/plugin list` shows it), delegate to it directly:

```
> Use skill-creator. The workflow we just completed was: [one-line description].
  Convert this conversation into a reusable skill.
```

The plugin handles frontmatter, structure, validation, and packaging. It will iterate with you on the description until the trigger conditions match the use case.

Install once globally: `/plugin install skill-creator@anthropics`

## Mode B: Manual authoring (no plugin available)

If you don't have the plugin, drive the conversion manually using this template.

### Step 1 — Confirm the run was successful

Don't codify a bumpy run. Ask: did this conversation produce the output you'd accept as the canonical "good" output for this workflow? If not, do another walkthrough first.

### Step 2 — Identify the inputs and outputs

What did the workflow start with? (a job posting, a CSV, a research question, a bug report) What did it end with? (a CV, a chart, a literature summary, a fixed PR)

### Step 3 — Extract the steps that mattered

Re-read the conversation and pull out:
- Steps that worked first try → copy verbatim
- Steps that failed and were corrected → keep the *correction*, not the wrong attempt
- Steps that were redundant or backtracked → drop entirely

### Step 4 — Generate the skill file

Use this shape:

```yaml
---
name: kebab-case-name
description: One sentence stating when to invoke this skill. This goes into context every turn — keep it tight and specific. Bad: "helps with documents". Good: "draft cover letters from a job posting; apply when the user provides a posting URL or full text".
---

# Title

## When to invoke
[1–3 specific triggers]

## Inputs
[what you need from the user]

## Steps
[ordered, the corrections-included version]

## Outputs
[what you produce; format spec if relevant]

## When NOT to invoke
[edge cases where this skill would be wrong]

## See also
[cross-references to other skills]
```

### Step 5 — Save and test

Save to `.claude/skills/<name>.md` for project scope, or `~/.claude/skills/<name>.md` for global. Open a new session and trigger the skill on a new instance of the workflow. If it fires correctly and produces acceptable output, done. If not, apply `recursive-refinement.md`.

## Anti-patterns

- **Codifying from imagination.** The skill must be born from a successful run, not a hypothesis about what the run *should* look like.
- **Over-specifying.** Every additional rule narrows the trigger. If the description is "draft cover letters when the user provides a job posting", don't add "and the posting must be in English and the user must specify the company" — those are inputs the agent can ask for.
- **Under-specifying.** "Help with applications" is so vague the skill never fires. Match the description to the actual triggers.
- **Leaving in the failures.** If step 3 of the original conversation was wrong and step 4 fixed it, the skill should encode step 4. Don't include the failed step "for context".

## See also

- `core/skills/operating/walkthrough-then-codify.md` — the methodology this skill operationalises
- `core/skills/operating/recursive-refinement.md` — what to do when the new skill misfires
- `ecosystem/plugins-to-install.md` — install instructions for Anthropic's skill-creator

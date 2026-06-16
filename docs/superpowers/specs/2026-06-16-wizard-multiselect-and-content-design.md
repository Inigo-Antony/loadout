# Wizard multi-select UX + README/LinkedIn content — design

## 1. Wizard multi-select (wizard.sh)

### Problem
`wizard.sh` Q3 (domains) and the derived business/meta selection require the user to
type comma-separated skill names from a printed list, with no autocomplete and a
re-prompt-on-typo loop. Q6 (reference files) is always asked, even when the user has
nothing to reference. Q8 (outcome) is free text fed through a brittle keyword `case`
heuristic.

### Design

**`toggle_menu` helper** (replaces `pick_one` for domains/business/meta/outcome):
- Renders a numbered list with `[ ]`/`[x]` checkboxes.
- User types one number per line to flip that item; redraws after each input.
- Blank line + Enter confirms the current selection and returns.
- Pure bash — no new dependency, no change to the `--standalone` zero-deps promise.

**Domains menu** (the only menu where skills are picked by name) gets one trailing
toggle item: `+ create a new skill from reference files`. **Business and meta skills
are NOT given their own selection menu** — they stay derived from the outcome answer
(Q8), as today; only the derivation mechanism changes (see below). If the
domains-menu trailing item is checked:
- Immediately prompt for comma-separated reference file paths, scoped to domains.
- Copy the given files into `<target>/.claude/skill-drafts/domains/`.
- Write/append a short note (printed in the final summary, and into
  `<target>/.claude/skill-drafts/README.md`) instructing the user to run
  `walkthrough-then-codify` on that folder in a live Claude Code session — bash cannot
  author a skill body itself, only stage the raw material.
- This replaces the old always-on Q6; reference files are now opt-in and scoped.

**Q8 (outcome) becomes a multi-select toggle_menu** with options:
`ship/launch a SaaS or product`, `land consulting/freelance clients`,
`grow content/audience`, `land a job or publish research`, `not sure yet`,
`other (type your own)`, and a trailing
`+ create a new skill from reference files` item (same staging behavior as the
domains menu, but copying into `<target>/.claude/skill-drafts/outcome/`).
- Each checked outcome option (except "not sure") contributes its mapped
  business/meta skills (union across checked options) and a clause to `SHIP_GOAL`.
  This replaces the old keyword-`case` heuristic with a direct option→skill mapping
  table (no more guessing from free text).
- "other" prompts one line of free text, run through the existing keyword heuristic
  (kept only as the fallback for this one option), and appended to `SHIP_GOAL`.
- If "not sure" is the only thing checked: `SHIP_GOAL` stays empty (GOALS block
  stripped from CLAUDE.md as today), business defaults to `outcome-framing` only, no
  meta skill.

**Adding business/meta skills later:** the wizard's final summary prints a reminder
that `install.sh --custom --business <list> --meta <list> --no-claude-overwrite` can
be re-run anytime to layer in more business/meta skills without touching domains or
CLAUDE.md. No new flag needed — `--custom` already supports this today.

**`install.sh --custom` is unchanged.** It remains the non-interactive, scriptable
path with comma-separated `--domains/--business/--meta` flags exactly as today. The
toggle UI is a `wizard.sh`-only improvement; `--custom` users already know what they
want.

### Out of scope
- No `fzf`/`gum` integration — pure bash only, per decision.
- No change to preset definitions or `install.sh` preset/custom logic.

## 2. README + LinkedIn content

### README
- Keep as-is: stack diagram, repo tree, install options (wizard/preset/custom/
  standalone), licensing, sources.
- Rewrite: opening section — hook on the "loadout" analogy, origin story (rebuilding
  voice/reasoning/governance rules per project; plugins solve engineering execution
  but not personalization), problem statement, then a "compounding loop" tie-in to
  what already exists in the doc.
- Add: a "Comments & Contributions" section near the end with a concrete CTA —
  open an issue/PR for a new domain or business skill adapter, link to
  `ecosystem/external-skills.md` for what's already covered.
- Correction applied: do NOT claim personalization is "token-free." CLAUDE.md
  (~400 tokens) and each skill's description (~50 tokens) are always-on costs; only
  skill *bodies* are free until matched. Framing: a small flat token cost that doesn't
  grow with how deep each skill goes — not zero cost.

### LinkedIn post
- Audience: broad hook, insider depth — understandable to a casual AI-tool user,
  but specific enough (Layer 1 / Layer 2, named plugins) that Claude Code power users
  recognize and want to share it.
- Origin story: same as README (rebuild tax + plugins-solve-engineering-not-you gap).
- Ends on a discussion question (comment-bait): what do you keep rebuilding across
  projects / what would be in your loadout — then point to the repo.
- Repo link: `github.com/Inigo-Antony/loadout`.

### Out of scope
- No paid promotion / scheduling guidance — just the two pieces of written content.

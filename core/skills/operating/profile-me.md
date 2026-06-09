---
name: profile-me
description: Deepen the operator's CLAUDE.md and generate personal skill files from an interview. Invoke when the user says "profile me", "personalize this setup", "build me a skill for X", or just after install.sh --wizard has done the basic pass. The skill conducts a Phase-1 interview (including asking for paths to reference markdown), synthesises a refined identity + voice in Phase 2, and in Phase 3 writes new .claude/skills/*.md files and updates CLAUDE.md without clobbering user edits.
---

# Profile Me

A meta-workflow that turns a conversation about *how the user actually works* into:

1. A refined `CLAUDE.md` (identity, voice, tooling, standing rules).
2. One or more domain-specific skill files written into `.claude/skills/`.
3. A short "what changed and why" report so the user can audit the writes.

This skill assumes `install.sh --wizard` has already produced a baseline
`CLAUDE.md`. If it hasn't, run the wizard first or ask the user to confirm
they want to start from a blank slate.

## When to invoke

- User says "profile me", "personalize Claude for me", "set up my CLAUDE.md properly".
- User describes a recurring workflow and says "make this a skill" or "I want Claude to help me do this every time".
- After `install.sh --wizard` completes, the install message points the user here.
- User wants to add new skills to an existing personalized setup (re-invocation).

## When NOT to invoke

- The user wants a single one-off task done — just do it; don't codify yet.
- The user is asking general questions about Claude Code — point them at docs.
- No `CLAUDE.md` exists yet and the user wants to start from zero — run the
  install wizard first.

## Inputs

- A short conversation (this one).
- Optionally: paths to reference markdown files (notes, blog posts, CV, a
  prior CLAUDE.md, READMEs of past projects). One interview question
  explicitly asks for these.
- Write access to `<project>/CLAUDE.md` and `<project>/.claude/skills/`.

## Outputs

- An updated `<project>/CLAUDE.md` (a NEW commit / new file, not an in-place
  edit that destroys user changes — see "Idempotency" below).
- Zero or more new files under `<project>/.claude/skills/`, one per
  codified workflow.
- A "delta report" printed back to the user.

---

## Phase 1 — Discovery

Ask each question in order. Don't propose skills or rewrite CLAUDE.md until
all are answered. Keep the user's answers verbatim in working memory — the
voice you adopt in the skill files should mirror the voice they used in the
interview.

### Q1. What does a typical "good day at the keyboard" look like for you?

Open-ended on purpose. Listen for:
- Time horizon (one big push vs. many small tasks)
- Tools mentioned by name (editors, CLIs, MCPs)
- Implicit voice — short blunt sentences vs. long expository ones

### Q2. What three workflows do you repeat most often, in order of frequency?

Each one is a candidate skill. Examples of what to fish out:
- "I research a stock before investing" → `investment-research.md`
- "I journal trades I made" → `options-trading-journal.md`
- "I write weekly client status updates" → `client-status-update.md`
- "I triage GitHub issues on Monday morning" → `monday-issue-triage.md`

For each, ask:
- What's the input? (a ticker, a trade, a meeting transcript, a repo)
- What's the output? (a memo, a markdown journal entry, an email, a PR)
- What's the step that's most annoying when you do it manually?

The "most annoying step" is usually the highest-value thing for Claude to
own. The skill should encode the *correction* for that step.

### Q3. Who reads what you produce?

- Just you (private notes, journals)
- A small audience you know (clients, teammates)
- A public audience (blog readers, paper reviewers)
- A mix — name the mix

Audience drives default verbosity, formality, and whether the skill includes
a "publish" step.

### Q4. What voice do you NOT want?

Easier than asking the positive form. Common answers worth probing:
- "no corporate-speak"
- "no LLM throat-clearing" (great question, I hope this helps, as an AI…)
- "no bullet-point soup when a paragraph would do"
- "no over-hedging"

Record the negatives verbatim — they become explicit don't-do rules in
CLAUDE.md.

### Q5. What are your tooling non-negotiables?

- OS, shell, package manager
- Default language(s) and any allergies (e.g. "don't suggest Java", "no
  bash for anything over 50 lines — use Python")
- Containers / runtime (Docker, Podman, native, devcontainer)
- MCP servers you use regularly
- File / repo conventions (monorepo? naming? branch model?)

### Q6. Paths to reference markdown files.

**This question is mandatory.** Phrase it like:

> "Paste paths to any markdown files that describe how you work — notes, a
> blog post, your CV, a prior CLAUDE.md, the README of a project you're
> proud of. I'll read them and pull voice + identity signals. Comma-separated
> absolute paths, or 'skip' if you'd rather not."

For each path provided:
1. Read the file with the `Read` tool.
2. Extract: candidate name, role lines, voice style (short vs. long
   sentences, presence of headings, use of first person), topical
   keywords, recurring phrasings.
3. **Show the user what you extracted.** Format:

   ```
   From /home/maya/blog/2026-04-shipping-fast.md:
     - Voice tilt: concise; you average ~9 words per sentence.
     - Identity signal: "I ship one product per quarter, mostly to small B2B niches."
     - Vocabulary: "ship", "niche", "unit economics", "moat" appear repeatedly.
     - Recommendation: lift "ship one product per quarter" into CLAUDE.md's "Who I am" line.
   ```

4. Ask: "accept these signals into your profile? (y / n / edit)"

Do not silently overwrite anything based on extracted signals — surface them,
get a confirmation, then apply.

### Q7. Anything I should know about how this profile should evolve?

- Will the user re-run this skill quarterly? Annually? Never?
- Are there other people in the household / team who will use this CLAUDE.md?
- Is there a "draft / final" distinction (e.g. "treat this as a draft I'll
  edit", vs. "treat my answers as canonical")?

---

## Phase 2 — Synthesis

Once all questions are answered, do NOT immediately write files. First,
produce a synthesis document inline for the user to review:

```
PROPOSED CHANGES

CLAUDE.md changes:
  - "Who I am" line: <before> → <after>
  - Voice paragraph: add "no LLM throat-clearing"; drop "balanced — let me
    show working" because user said "I want shorter".
  - Tooling: change "Python" → "TypeScript + Bun"; add "Podman, not Docker".

New skill files:
  1. .claude/skills/options-trading-journal.md
     Trigger: "I made a trade", "journal this trade", a paste of a fill notification.
     Output: a markdown journal entry with thesis, entry, planned exit, post-mortem template.

  2. .claude/skills/weekly-client-status.md
     Trigger: "draft my client status update", "Friday status".
     Output: a markdown report keyed by project, with shipped / in-flight / blockers.

  3. .claude/skills/stock-research.md
     Trigger: a ticker symbol, "research $TICKER".
     Output: a 1-page memo with thesis, base rate, key risk, decision.

DELTA REPORT will also include:
  - which signals from reference markdown were accepted
  - which fields were left at wizard defaults
  - what is intentionally NOT being changed
```

Ask: "approve all / approve some / iterate". Only proceed to Phase 3 on an
explicit approval.

---

## Phase 3 — Execution

### 3a. Update CLAUDE.md (idempotent)

**Never blindly overwrite.** The wizard or a prior run may have produced
content the user has hand-edited. Strategy:

1. Read existing `CLAUDE.md`.
2. Locate the section headers (`## Who I am`, `## Voice`, `## Tooling`,
   `## Standing rules`, `## Operator-specific notes`).
3. For each section the interview produced new content for, ASK the user:
   "your current section says X. proposed update says Y. (replace / merge /
   skip)?"
4. Apply only the changes the user approved, using `Edit` with the exact
   old_string → new_string. Don't use `Write` (which clobbers).
5. If `CLAUDE.md.bak` doesn't exist, create one before writing.

### 3b. Generate skill files

For each approved workflow:

1. Compose the frontmatter:
   ```yaml
   ---
   name: <kebab-case-name>
   description: <one sentence on when to invoke — keep ~50 tokens; specific>
   ---
   ```
2. Compose the body using this template:

   ```markdown
   # <Title>

   ## When to invoke
   <2–3 specific triggers in the user's own words from Q2>

   ## Inputs
   <what the user provides — paste, path, URL, ticker, etc.>

   ## Steps
   1. <step that worked first try in their description>
   2. <the "annoying step" with the correction encoded>
   3. <output formatting step>

   ## Output format
   <markdown structure spec — be exact about headings/fields>

   ## When NOT to invoke
   <edge cases the user mentioned or that are obvious from the workflow>

   ## See also
   <cross-refs to other skills the user already has>
   ```

3. **Check for collisions.** Before writing
   `.claude/skills/<name>.md`, check if a file with that name already
   exists. If yes:
   - If file content is identical → no-op, report "already present".
   - If different → write to `.claude/skills/<name>.v2.md` and tell the
     user; let them merge manually. Never silently overwrite.

4. Use the `Write` tool (new files) or `Edit` (existing). Save under
   `<project>/.claude/skills/<name>.md`.

### 3c. Print the delta report

```
Profile updated.

CLAUDE.md:
  ✓ Voice paragraph replaced (user-approved)
  ✓ Tooling section: Python → TypeScript + Bun
  • "Who I am" line left untouched (user chose "skip")

New skills written:
  + .claude/skills/options-trading-journal.md
  + .claude/skills/weekly-client-status.md
  ! .claude/skills/stock-research.md — name collision with existing file;
    wrote to stock-research.v2.md for manual merge

Reference signals applied:
  ✓ /home/maya/blog/2026-04-shipping-fast.md → voice + "ship/niche" vocab
  • /home/maya/cv.md → skipped on user's request

Re-run me anytime you want to add more skills. Existing files won't be
overwritten — collisions go to *.v2.md and you merge.
```

---

## Idempotency strategy

This skill MUST be safely re-runnable. Rules:

1. **CLAUDE.md** is edited section-by-section with user approval per section.
   A `.bak` is written before any change. The skill never uses `Write` on
   CLAUDE.md after the initial wizard pass.
2. **Skill files** use collision-then-version naming
   (`foo.md` exists → write `foo.v2.md`, tell the user). Never silent
   overwrite.
3. **The skill keeps no state between runs.** If the user re-invokes 3
   months later with new workflows, treat it as a fresh interview — but
   read the existing CLAUDE.md and skill list first so you don't re-ask
   things that are already settled. Ask: "you already have skills for
   trading-journal, client-status, and stock-research. add to the list, or
   refine one of them?"

---

## Anti-patterns

- **Codifying a workflow the user only mentioned once in passing.** Q2
  asks for the *three most frequent*. Stick to those.
- **Writing a "general" skill instead of a specific one.** "Help with
  finances" is unfireable. "Journal a stock or options trade given a fill
  paste" is.
- **Filling in defaults from the wizard without flagging.** If the user
  said nothing about, say, file naming conventions, the new skill must NOT
  invent one. Leave that section out, or ask.
- **Rewriting voice based on reference markdown without confirming.** The
  reference files might be old, written for a different audience, or not
  representative. Always surface signals, never apply silently.
- **Codifying from a hypothetical run.** If the user describes a workflow
  but has never actually completed it the way they're describing, hand off
  to `walkthrough-then-codify` first — do one real run together, then
  codify.

---

## See also

- `core/skills/operating/skill-creator.md` — single-skill authoring; this
  meta-skill effectively batch-runs skill-creator for several workflows at
  once.
- `core/skills/operating/walkthrough-then-codify.md` — the methodology this
  skill operationalises for the codification step.
- `core/skills/operating/recursive-refinement.md` — what to do when a
  generated skill misfires on its first real run.
- `.brainstorm/wizard.sh` — the install-time wizard that produces the
  baseline CLAUDE.md this skill refines.

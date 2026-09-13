# Changelog

## 2026-09-14 — Audit, cut, and publish

Full run of `loadout-work-order.md` (Phases 1–8). Net `.md` file count under
`core/`, `domains/`, `business/`, `meta/`: **33 → 33 (zero delta)**. Repo-wide
tracked `.md` count excluding this file: **37 → 37 (zero delta)**. This file
itself is a +1 outside that accounting — it's a report artifact Claude never
loads, not a skill competing for always-on token budget, which is what the
net-count rule exists to police.

### Deleted

- `business/content-creation.md`, `business/seo-and-marketing.md` — both 17
  lines, both delegating execution depth to the same external
  (coreyhaines31/marketingskills), both a "See also" pair already pointing at
  each other. Per Phase 1's `AUDIT.md` (gitignored working note), both pass
  the "survives without the plugin" test on content alone, so a straight
  delete wasn't warranted — merged instead. See "Added."

### Merged

- `business/content-creation.md` + `business/seo-and-marketing.md` →
  `business/marketing.md`. Same operator policy (content: point-of-view,
  AI-drafts-as-raw-material, repurposing, cadence; distribution: own-the-
  audience, one-channel-90-days, GEO, real metrics, ads-amplify), one file,
  half the always-on description cost. All cross-file "See also" pointers
  updated (`outreach-applications.md`, `digital-products.md`,
  `product-launch.md`, `meta/sub/monetization.md`, `meta/sub/open-sourcing.md`).

### Added

- `business/marketing.md` — the merge above.
- `core/skills/operating/filing-protocol.md` — stage-based project layout
  (`1-problem → 2-design → 3-validation → 4-test`), a five-field "card"
  format for artefacts that can't be read as text, and a conflict rule
  (stronger evidence wins, weaker marked `status: superseded`). Basis changed
  mid-task from an energy-domain draft to `project-filing-convention.md`,
  which was already domain-generic.
- `core/CLAUDE.md.template` — a `## Filing` block below the Layer Contract,
  wrapped in `{{#FILING}}...{{/FILING}}` so it's optional per project.
- `wizard.sh` Q9 — "use the stage-based filing structure?", default yes/all
  four stages, one no-op-out. Ninth question, at the work order's stated limit.
- `install.sh` now writes `reference/**` and `log/**` into the installed
  project's `.gitignore` unconditionally (every mode, every wizard answer) —
  the filing-protocol skill ships regardless of the Q9 answer, so the privacy
  boundary is structural rather than tied to one opt-in question. No
  tracked-exception file (the work order's original `ground/INDEX.md` carve-
  out has no analog in the convention actually shipped).
- `AUDIT.md` (repo root, gitignored) — Phase 1's per-file inventory: 32 skill
  files, a verdict and stated reason for each. Working note, not published.
- This file.

### Changed

- `install.sh` presets: 7 → 3 (`academic-research`, `job-pipeline`,
  `engineering`). Dropped `saas-launch`, `freelance-services`,
  `content-creator`, `consultant` — seven presets was seven maintenance
  obligations against zero users. Nothing dropped from a preset went orphaned:
  cross-checked against `wizard.sh`'s independent domain toggle (Q3, lists
  every file in `domains/` dynamically) and outcome-driven business selection
  (Q7, pattern-matched independent of presets) — everything a deleted preset
  named is still reachable through the wizard's default path or `--custom`,
  except `product-launch.md`, which is real content (126 lines) kept via
  `--custom`.
- `core/pitfalls.md` moved out of the always-copied set. It's documented
  reference for skill authors, not an auto-loaded skill — dead weight in
  every install. Stays in this repo; `install.sh` stops copying it into
  installed projects. Fixed two references left dangling by that change
  (`core/CLAUDE.md.template`, `core/skills/operating/ship-readiness.md`).
- README: sources split into **Primary** (Anthropic docs + official skills
  repo — the only citations used for Claude Code behavior claims) and
  **Secondary — community, unverified** (design inspiration and curation
  choices). Platform-capability claims (native auto memory, `.claude/rules/`
  path-scoped rules, `/doctor` CLAUDE.md trimming, `/compact` survival,
  `@path` imports) verified directly against `code.claude.com/docs` rather
  than carried over from the README's prior description of Layer 1.
  `handoff-log.md` re-tested against auto memory's four note types
  (`user`/`feedback`/`project`/`reference`) — none of them carries rejected
  alternatives + unverified state + next action in one place, so the skill
  survives; its storage line now names native auto memory as the default
  backend. Removed two stale references to `TRADEMARK.md` (deleted from this
  repo at `1d80c8a`, before this document's current form).
- README Maintenance: added the `OTEL_LOG_TOOL_DETAILS=1` /
  `skill_activated` tip for finding unused skills, verified against Claude
  Code's monorepo-setup docs.

### Not done

- Did not hit Phase 3's "-6 file" acceptance number for `domains/`/`business/`
  content specifically — applying the deletion test consistently (per Phase 1
  rule 4: "if a file fails the test, keep it and say why") found every
  explicitly-named candidate contains real, load-bearing operator content
  once actually read, not just orientation. Resolved with the user as
  "tighten the test": the two thinnest, same-delegate files were merged
  instead (see "Merged"), which nets exactly enough to pay for Phase 6's
  addition without deleting content that survives its own test.
- Deferred items from the work order (repo split, `profile-me` /
  `recursive-refinement` deletion, `reasoning-education` /
  `walkthrough-then-codify` merges, `ecosystem/*.md` dating) intentionally
  untouched — the work order marks these "do not do now."

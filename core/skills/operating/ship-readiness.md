---
name: ship-readiness
description: Pre-ship gate. Before deploying, publishing, releasing, opening a PR, or sending any artifact outward, verify code/app security and that every claim in code, docs, or marketing is substantiated. Delegates scanning to Layer 1 and real tools; never reimplements them.
---

# Ship Readiness

A gate, not a scanner. It fires at the boundary where work leaves your hands — a deploy, a release, a published README, a client report, a posted thread — and runs two checks before it crosses: is it *safe*, and is every claim in it *true*. Execution is delegated; this skill decides what to run and refuses to let unresolved high-severity findings ship.

## When this fires

Any outbound artifact: deploying to prod, opening a PR, cutting a release, publishing docs or marketing, sending a report, going live. "Is this ready to ship?" is the trigger. Run it *before* the artifact leaves, not after — a gate run after shipping is a postmortem.

Match depth to blast radius. A public production deploy or a published claim earns the full pass; a throwaway internal script does not. Don't apply release-grade rigor to a scratch file, and don't wave a public ship through on vibes.

## Check 1 — Security

Delegate the scan; own the decision to run it and the triage of what comes back.

- **Invoke Layer 1 first.** superpowers `/security-review` (reviews pending changes on the branch), `gsd:secure-phase` / the `gsd-security-auditor` (verifies threat-model mitigations exist in code, produces `SECURITY.md`). Don't hand-roll what they already do.
- **Standard scanner categories** (run the tools, don't emulate them): SCA for dependencies and supply-chain risk, SAST for source flaws (injection, unsafe deserialization), DAST for the running app, and a secrets scan (e.g. `gitleaks`) over the diff *and* history. No single category is sufficient — layer them.
- **AI-generated code earns extra scrutiny**, because its dominant failure mode is that nobody read it before it ran:
  - **Package hallucination / slopsquatting** — confirm every imported dependency actually exists, is the package you intended (not a look-alike name), and is pulled from the right registry. A hallucinated name an attacker has since registered is a live supply-chain exploit, not a typo.
  - **Missing input validation** → injection. AI lacks the business context to know what input is legitimate.
  - **Hardcoded secrets** — keys, tokens, passwords in source or image layers.
  - **Insecure or outdated dependencies**, and memory-safety issues in low-level languages.
- **Frameworks to map against:** OWASP Top 10 for web/app surface, OWASP LLM / GenAI Top 10 if the thing being shipped *is* or *uses* an LLM feature.

Block on unresolved HIGH findings. For risks you consciously accept, write them down with the reasoning (see `handoff-log`) — "accepted: installer runs against the user's own project, no privilege escalation" is a decision; silence is a gap.

## Check 2 — Claims integrity

This is `grounding-standard` pointed *outward*. Every assertion in a shipped artifact — README, docs, landing copy, a LinkedIn post, code comments, commit messages, benchmark figures — is a claim someone can check. Ship only claims that survive checking.

For each claim, it must be one of: **verifiable** (a number you measured, a behavior with a test, a fact with a source) or **cut**. There is no third bucket where a flattering, unmeasured assertion gets to stay.

High-risk words that should stop you: *secure, production-ready, fully tested, zero dependencies, 10x faster, fastest, guaranteed, never fails, 100%, bank-grade, unbreakable, instant.* Each is a promise. For each, ask: can a skeptical reader confirm this in five minutes? If not, soften it to what's actually true or remove it.

The test caught a real one in this repo: the README originally said "**Token-light**," which overstated a layer that does carry an always-on cost — corrected to "a flat token fee, not a growing tax," which is true and checkable. By contrast `--standalone`'s "zero dependencies" survived the gate, because it was verified (pure bash, no network, no plugins). Substantiated claims ship; flattering ones get cut or qualified.

## Anti-patterns

- Running the gate *after* the artifact shipped — it's a gate, not a retrospective.
- Trusting AI-written code because "it runs." Running is not reviewed (this is the #1 AI-codegen security gap).
- Reimplementing a scanner that Layer 1 or a real SCA/SAST/secrets tool already runs.
- Shipping a claim you'd have to re-derive from scratch to defend in a comment thread.
- Grounding the easy claim and waving the load-bearing one through.
- Release-grade ceremony on a throwaway script; vibes-grade review on a public deploy. Match depth to blast radius.

## See also

- `grounding-standard` — Check 2 is this rule applied to outbound artifacts.
- `governing-algorithm` — question and delete claims/features before substantiating them; the cut claim needs no defense.
- `handoff-log` — where accepted risks and their reasoning get recorded.
- Layer 1: superpowers `/security-review`, `gsd:secure-phase`, `gsd-security-auditor`, `/code-review`.

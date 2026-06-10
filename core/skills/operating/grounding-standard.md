---
name: grounding-standard
description: Ground claims on canonical sources before asserting them. Apply whenever stating a technical fact, API shape, number, or best practice that the session hasn't verified — especially when operating autonomously.
---

# Grounding Standard

A standard, not a fetcher. Retrieval is delegated to Context7 (live, version-pinned library docs), web search, or the local codebase. This skill is the rule about *when retrieval is mandatory*.

## The rule

Before asserting, check which bucket the claim is in:

1. **Verified this session** — read from the codebase, a doc fetch, or a tool result. Assert it, and say where it came from.
2. **Canonical and stable** — physics, well-settled standards, language semantics. Assert it.
3. **Plausible from training** — API signatures, library versions, prices, tool flags, anything that changes. **Do not assert. Ground it first**: Context7 for library APIs, web search for the current state of anything, the repo itself for project facts.

Prefer offline/canonical references (datasheets, specs, the installed package's own source) over blog posts. Cite what was used — a claim with a source can be checked; a confident claim without one has to be re-derived by whoever doubts it.

## Why this matters more under autonomy

With bypass-permissions, a wrong-but-confident claim doesn't stop at a chat message — it becomes an executed command, a committed file, a sent artifact. The cheaper autonomy makes action, the more expensive ungrounded assertion becomes. Ground first; act second.

## Anti-patterns

- Quoting version-specific API usage from memory when Context7 is one call away
- "Best practice is X" with no source — that's a preference wearing a principle's clothes (pitfalls #4)
- Grounding the easy claim and asserting the load-bearing one

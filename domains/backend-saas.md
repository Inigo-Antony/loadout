---
name: backend-saas
description: Operator standards for SaaS and web-app work — stack discovery before assumption, small reviewable changes. Execution rhythm delegated to superpowers/GSD.
---

# SaaS / App Development — adapter

**Execution lives elsewhere.** Spec-first planning, TDD, review, and subagent orchestration are the installed Layer 1 rhythm (superpowers/GSD) — don't re-plan it here. Engineering depth: **mattpocock/skills** (TypeScript) and **vercel-labs/agent-skills** (see `ecosystem/external-skills.md`). This overlay is the operator's project-conduct layer.

## Operator standards

1. **Stack discovery before assumption.** Read `package.json`/`pyproject.toml`, README, `.env.example`, existing tests and folder shape before generating anything. Absent or ambiguous → ask.
2. **Smallest viable change.** A 200-line PR is reviewable; a 2,000-line one is not. Don't refactor while fixing a bug — two PRs.
3. **Existing patterns win.** If three modules use a shape, the fourth does too unless there's a stated reason. Style follows the linter, not preference.
4. **Secrets hygiene.** `.env` gitignored with a committed `.env.example`; production secrets in a manager, never in image layers or commits.

## Operator defaults (replace as the stack stabilises)

- Postgres for relational, SQLite for local; auth is never hand-rolled (Auth.js/Clerk/Supabase).
- API: versioned routes from day one, pagination on every list, errors as `{error: {code, message, details}}`.
- Migrations under version control; `EXPLAIN` before adding indexes; UUIDs for user-facing IDs.

## See also

- `domains/infra-containers.md` — deployment and dev environment
- `domains/frontend.md` — the UI slice

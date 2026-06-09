---
name: backend-saas
description: Operating instructions for SaaS or web application development. Apply when building product code with users, persistence, and deployment. Enforces stack-discovery before assumption, plan mode by default, and tests-as-verification rather than tests-as-afterthought.
---

# SaaS / App Development

> Skeleton module. Customise stack-specific conventions as projects materialise.

## Stack discovery before assumption

Don't assume what the project uses. Read first:

- `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` — language and framework
- `README.md` — intended purpose
- `.env.example` — required external services
- Existing tests and CI config — testing convention
- Top-level folder structure — code organisation pattern

If any of these is absent or ambiguous, ask before generating.

## Default workflow

1. **Plan mode by default.** State the change in plain English; identify the files affected; note the riskiest part.
2. **Smallest viable change.** A 200-line PR is reviewable; a 2,000-line one is not. Decompose.
3. **Tests next to code.** New behaviour needs a test that fails before the change and passes after. No exceptions for "obvious" code.
4. **Run before declaring done.** Linter clean, type-checker clean, tests pass. Use the project's actual commands, not assumed defaults.

## Common stack defaults (replace as your stack stabilises)

- **Backend**: Python (FastAPI / Flask) or Node (Express / Hono). Pick one and stay consistent.
- **Database**: Postgres for relational; SQLite for dev/local; Redis only if a real cache need exists.
- **Auth**: Don't roll your own. Use Auth.js, Clerk, or Supabase Auth.
- **Frontend**: React + Vite or Next.js. Tailwind for styling.
- **Deployment**: Containerise (see `02-domain/networking-infra`).

## API design

- Resource-shaped routes (`/users`, `/users/:id/posts`); verbs as methods.
- Versioning from the start (`/v1/...`) — cheap to add, expensive to retrofit.
- Pagination on every list endpoint.
- Errors are JSON with a stable shape: `{error: {code, message, details}}`.
- Idempotency keys on any state-changing endpoint that might be retried.

## Database

- Migrations under version control (Alembic, Prisma, Knex).
- Never destructive migrations on production data without a backup-verified snapshot.
- Indexes match query patterns, not vibes. `EXPLAIN` before adding.
- UUIDs over auto-increment IDs for anything user-facing.

## Auth and secrets

- Secrets via environment variables, never committed.
- `.env` gitignored; `.env.example` committed with placeholder values.
- Production secrets in a secret manager (AWS Secrets Manager, Vault, Doppler), not env files.
- Rotate compromised secrets immediately; assume any leaked secret is exploited within minutes.

## Testing

- **Unit**: pure functions, model logic
- **Integration**: API endpoints with a test database
- **E2E**: critical user journeys only (sign-up → first action → core workflow). Don't try to E2E everything.
- Coverage is a smell metric, not a goal — 100% coverage with weak assertions is worse than 60% with strong ones.

## When working with this codebase

- Read the existing patterns before introducing new ones. If three modules use a particular shape, the fourth should too unless there's a reason.
- Style follows the linter, not the agent's preferences. If the linter passes, the style is correct.
- Don't refactor while fixing a bug. Two PRs.

## Anti-patterns

- Generating large feature commits without plan-mode review
- Adding a new framework or library when an existing one would do (npm bloat = future pain)
- Disabling tests instead of fixing them
- Committing `.env` or any file with real secrets
- Catching exceptions to silence them instead of handling them

## See also

- `core/skills/operating/plan-then-execute.md` — default mode for any feature work
- `core/skills/operating/subagents-and-teams.md` — when work splits into independent components
- `domains/infra-containers.md` — for deployment, container builds, dev environment
- `domains/frontend.md` — for the frontend slice

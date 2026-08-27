---
name: open-sourcing
description: Execution path for releasing a project as open source. Invoked from monetize-or-opensource after the OSS path is selected. Handles license selection, repository structure, README and docs, CI, release process, and community plan.
---

# Open Sourcing

Releasing a project as OSS is a real commitment, not a checkbox. Done well, it builds reputation and community. Done poorly, it creates abandonware that hurts your reputation more than not releasing would.

## Pre-release checklist

Before any of the steps below, verify:

- **You're allowed to release it.** Code written for an employer is usually theirs. Code derived from research has IP holders. Code containing third-party material may have license constraints. Get this right before publishing — pulling something down doesn't unpublish it.
- **No secrets, no PII, no embedded credentials.** Run a secret scanner (`trufflehog`, `gitleaks`) over the repo and the entire history before public push. Rebase or recreate the repo if anything is found.
- **Dependencies are clean** — no GPL deps in an MIT codebase if license compatibility matters to you, no unmaintained packages with known vulnerabilities.

## License selection

Pick deliberately. The choice affects what others can do and what they can take from you.

| License | Use when |
| --- | --- |
| **MIT** / **BSD-3** | You want maximum adoption; comfortable with people building proprietary products on top |
| **Apache 2.0** | Same as MIT but with explicit patent grant; preferred for anything you might patent |
| **GPL v3** | You want derivative works to also be open; willing to trade adoption for that protection |
| **AGPL v3** | GPL + closes the SaaS loophole (companies running it as a service must release modifications); most restrictive practically |
| **MPL 2.0** | File-level copyleft — middle ground between MIT and GPL |
| **CC-BY-4.0** | For documentation, datasets, content (not code) |

If unsure, MIT or Apache 2.0 are the safe defaults for code; CC-BY-4.0 for non-code. Use [choosealicense.com](https://choosealicense.com) for a clear comparison.

For research code: the convention is permissive (MIT/Apache); copyleft can hurt citation rates because companies avoid it.

## Repository structure

Minimum viable structure that doesn't look amateur:

```
project/
├── README.md           # the most important file
├── LICENSE             # exact text from the license
├── CONTRIBUTING.md     # how to contribute (if you'll accept contributions)
├── CODE_OF_CONDUCT.md  # standard one is fine
├── CHANGELOG.md        # versioned releases
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/      # CI
├── docs/               # if more than README needed
├── examples/           # runnable examples
├── src/                # the code (or however your language conventions go)
├── tests/
└── pyproject.toml / package.json / Cargo.toml / go.mod
```

## README — the most important file

Most people who land on the repo read only the README. The first three paragraphs determine whether they install it.

Required structure:

1. **One-sentence pitch** — what this is and who it's for. Plain English.
2. **Visual or example** — a screenshot, a GIF, or a 5-line code example showing it in use. Words alone lose readers.
3. **Why it exists** — what problem this solves that wasn't solved well already. Brief honest comparison to existing alternatives.
4. **Quick start** — copy-paste install + minimum example. If this section requires more than 60 seconds, you've lost most of the audience.
5. **Documentation** — link to fuller docs (in `docs/`, on a docs site, or in the README itself if short)
6. **Contributing / license / acknowledgements** — short sections at the end

Common README failures: opening with badge soup, burying what the project does under a wall of context, no example, no install path, walls of text instead of structure.

## Documentation

For small projects, README + inline code comments is sufficient. For anything substantial:

- Quickstart — installation through first working result
- Concepts — the mental model needed to use the project
- Reference — every public API/CLI surface
- Recipes — how to do specific things (one recipe per common use case)
- Troubleshooting — common errors and fixes

Tools: MkDocs (Python projects), Docusaurus (JS), GitHub Wiki for the simplest cases, plain markdown in `docs/` for everything else.

## CI / quality gates

Without CI, contributors don't know if their changes work; you don't know if you broke anything between releases. Minimum:

- Tests run on every push and PR
- Linter runs on every push and PR
- Build succeeds on every push and PR
- Multiple OS / language version matrices if relevant

GitHub Actions is the default; the YAML for a basic Python or Node project is well-templated. Don't over-engineer this.

## Versioning and releases

- **Semantic versioning** — `MAJOR.MINOR.PATCH`. Breaking changes bump major; new features bump minor; fixes bump patch.
- **Git tags** for each release.
- **CHANGELOG.md** updated with each release, human-readable.
- **GitHub Releases** with release notes (auto-generated then edited).
- **Published to language ecosystem** if relevant (PyPI, npm, crates.io, Go modules) — adds discoverability and easy installation.

For early-stage projects, `0.x.y` versioning. Hit `1.0.0` only when the API is stable enough you'd commit to backward compatibility.

## Distribution and discoverability

Releasing to GitHub isn't distribution. It needs to be findable.

- **Topics on the repo** — GitHub search uses these
- **Submission to relevant lists** — awesome-X lists in your domain on GitHub
- **Hacker News / Lobsters** if it's broadly interesting (timing matters; weekday mornings best)
- **Reddit communities** specific to the domain
- **Show HN / Show /r/programming** etc. for genuine product launches
- **Newsletter / blog post** — write the announcement; share where your audience is
- **Tag relevant people** — if your project depends on or extends someone's work, tag them; many will boost it

## Community plan

Before launching, decide:

- **Who triages issues?** — you, until you have help
- **What's the response-time target?** — even "I respond within a week" is better than silence
- **What's contribution acceptance criteria?** — small fixes auto-merge after CI; features need an issue and discussion first
- **Where do users get help?** — GitHub Discussions, Discord, issue tracker, or "no public support, paid only"

If you can't commit to weekly maintenance touches in the first 6 months, set expectations explicitly in the README ("This project is maintained on a best-effort basis").

## Sustainability and getting paid

OSS doesn't preclude income. Common patterns:

- **Sponsorship** — GitHub Sponsors, Open Collective. Modest but real.
- **Consulting on top** — you become the expert on your library; companies pay for integration/customisation help.
- **Open-core** — premium hosted version, enterprise features behind a paid tier (see `meta/sub/monetization.md`).
- **Bounties / commercial support** — paid feature requests, paid SLA support.

For research-adjacent projects, citations themselves are a kind of "payment" in academic currency.

## Anti-patterns

- Releasing without a README that lets a stranger install in 5 minutes
- "Coming soon" sections in the README
- Accepting a PR you wouldn't have written, then maintaining it forever
- Public-facing roadmaps you don't keep updated
- Burnout from feeling obligated to respond to every issue immediately
- Re-licensing without consent of contributors (legal and ethical issue)
- Abandoning without a "maintenance status: archived" notice

## See also

- `meta/monetize-or-opensource.md` — the parent decision skill
- `meta/sub/monetization.md` — for the open-core route
- `business/seo-and-marketing.md` — distribution beyond the technical communities
- `business/content-creation.md` — the announcement post and ongoing posts

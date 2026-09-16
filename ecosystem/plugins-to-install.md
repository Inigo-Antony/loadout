# Plugins to Install

Curated set of Claude Code plugins worth installing — this is Loadout's Layer 1. Sources: Nate Herk's "I tried 100+ Claude Code skills, these 6 are the best" and broader community consensus from ScriptByAI's 2026 list (items 1–6); a 2026-09 review of a third-party "10 best Claude Code plugins" roundup, cross-checked against the actual `anthropics/claude-plugins-official` marketplace manifest rather than trusted at face value — the roundup's specific install-count and star claims aren't something the marketplace publishes, so treat those numbers as unverified marketing copy even though the plugins themselves check out real (items 7–8, plus the situational tier below). The default (layered) `install.sh` run provisions items 1–8 automatically; `--standalone` skips it.

> Plugins differ from skills: a skill is a markdown file teaching Claude how to do a job better. A plugin is a larger package that may include multiple skills, hooks, MCP servers, and behavioural changes.

## Recommended baseline (install globally)

These pay back across every project. Install once with global scope; they auto-invoke when relevant.

### 1. skill-creator (Anthropic official)

**What it does:** Builds new skills from natural language. Describe the workflow; the plugin drafts, tests, iterates, and packages it. Removes the manual `SKILL.md` formatting work.

**Install:**
```bash
/plugin install skill-creator
```
(ships in the default `claude-plugins-official` marketplace — no `@anthropics` marketplace exists, that suffix will fail)

**When it triggers:** Any time you describe a workflow you want reusable. The plugin recognises the intent and offers to build the skill.

**Why install globally:** You'll create skills across projects; baking it into every project is wasteful.

---

### 2. superpowers (community, ~170k★)

**What it does:** Forces senior-developer rhythm on Claude. Instead of jumping to code, Claude plans first, works in an isolated environment, writes tests before implementation, and reviews its own output in two stages (spec match + code quality).

**Install:**
```bash
/plugin install superpowers
```
(ships in the default `claude-plugins-official` marketplace — no `@obra` marketplace exists, that suffix will fail)

**When it triggers:** Any production code work. Most beneficial on features the client will actually run; less useful for one-off scripts.

**Cost:** uses more tokens than default rhythm — but reduces debug cycles and the rate of broken-in-production. Net positive on real work.

---

### 3. context-mode (community)

**What it does:** Sandboxes tool calls — a Playwright snapshot or a 50-page log doesn't dump raw into context. The sandbox extracts only what Claude actually needs (a 56KB snapshot becomes ~300 bytes; benchmark shows ~98% reduction over a working session). Tracks events in local SQLite and rebuilds session state when `/compact` runs.

**Install:**
```bash
claude plugin marketplace add mksglu/context-mode
claude plugin install context-mode@context-mode
```
(the marketplace isn't pre-registered — add it first, or the bare `install context-mode` fails)

**When it triggers:** Any session that touches tool output (browser automation, log files, large API responses, web fetches). The plugin auto-installs an MCP server, hooks, and routing instructions.

**Effect:** sessions that used to fall apart at 30 minutes can run for hours.

---

### 4. claude-mem (community)

**What it does:** Cross-session memory. Hooks into Claude's session lifecycle, captures file edits, decisions, bug fixes, commands. Compresses to semantic summaries via Claude's agent SDK. Stores in local SQLite with vector search. Three-layer retrieval (compact index → timeline → details) — reports ~10× token savings vs naive context dumping.

Auto-generates and updates folder-level CLAUDE.md as you work.

**Install:**
```bash
claude plugin marketplace add thedotmack/claude-mem
/plugin install claude-mem@thedotmack
```
(the marketplace isn't pre-registered — add it first)

**When it triggers:** Every new session — automatically pulls in relevant prior context. No manual invocation.

**Important:** Don't run the npm install line that some guides mention; it installs the SDK only and the hooks never register. Use the plugin install command above.

---

### 5. GSD (Get Shit Done)

**What it does:** Context engineering via fresh sub-agents per task. Each sub-agent has a clean window; the main session stays clean. Quality gates: scope-reduction detection (catches the planner silently dropping requirements), security enforcement anchored to your threat model. Has an autonomous mode for spec-and-walk-away workflows.

**Install:**
```bash
claude plugin marketplace add jnuyens/gsd-plugin
/plugin install gsd@gsd-plugin
```
(the marketplace isn't pre-registered — add it first, or the bare `install gsd` fails)

**When it triggers:** Multi-step tasks where one context would degrade. Type `/gsd-help` to see commands.

**Cost:** sub-agents use tokens; saves the time you'd otherwise spend redoing work Claude broke because it forgot the spec. Net positive on substantial tasks.

---

### 6. frontend-design (Anthropic official)

**What it does:** Provides design tokens, component patterns, and styling conventions for frontend work. Reduces the "looks AI-generated" output common in default frontend code.

**Install:**
```bash
/plugin install frontend-design
```
(ships in the default `claude-plugins-official` marketplace — no `@anthropics` marketplace exists, that suffix will fail)

**When it triggers:** Any UI / web / component work.

**Why install globally:** Frontend work crosses projects; install once.

---

### 7. context7 (Anthropic-marketplace, by Upstash)

**What it does:** Pulls live, version-pinned documentation for a library straight from its source repo into context, instead of Claude answering from training-data memory of whatever API shape was current at cutoff. No overlap with anything else in this stack — none of superpowers, GSD, context-mode, or claude-mem touch external-library currency at all.

**Install:**
```bash
/plugin install context7
```
(ships in the default `claude-plugins-official` marketplace — confirmed directly against its `marketplace.json`, not the vendor's own docs, which also mention a separate `upstash/context7` marketplace path; the bare form is simpler and is what `install.sh` uses)

**When it triggers:** Any task naming a library or framework by name, especially fast-moving ones (Next.js, Tailwind, LangChain, the Vercel AI SDK, Supabase).

**Cost:** anonymous rate limits apply without an API key (`CONTEXT7_API_KEY` env var); each doc lookup adds tokens and a round-trip. Worth it against the alternative — a fabricated method signature is more expensive to debug than the lookup.

---

### 8. semgrep (Anthropic-marketplace, by Semgrep)

**What it does:** Deterministic SAST/SCA/secrets scanning via Semgrep's real rule engine — a different, complementary layer from superpowers'/GSD's Claude-reasoning-based review, not a duplicate of it. Bundles an MCP server plus a post-tool-use hook that scans changed code automatically after every file write or edit. This is the concrete instantiation `ship-readiness.md`'s Check 1 already asks for generically ("standard SCA/SAST/DAST/secrets scanners") — it names the actual tool instead of leaving the delegation vague.

**Install:**
```bash
/plugin install semgrep
```
(ships in the default `claude-plugins-official` marketplace — same verification as context7 above)

**When it triggers:** Automatically, on every file write/edit once installed (via its own hook) — not something you invoke manually. `ship-readiness`'s pre-ship gate can point at it explicitly rather than a generic scanner reference.

**Cost:** free OSS rule set covers most cases; Semgrep's paid AppSec platform is a separate, optional upgrade this plugin doesn't require.

---

## Situational — official, but install only if it matches your stack

These are real, officially-listed plugins (verified against `claude-plugins-official`'s manifest directly), not community forks — but each is narrow enough (one platform, one language, one team tool) that making it a default for every install would tax projects that don't use it. Install per-project via `--custom`, or globally if every project you touch fits the same stack.

- **chrome-devtools-mcp** (Google, official partner) — live browser inspection: network, console, DOM, screenshots, Lighthouse audits. Pairs with `frontend-design`: it ships UI, this verifies the rendered result in a real browser. `/plugin install chrome-devtools-mcp@chrome-devtools-plugins` (its own marketplace, not the default one — register first).
- **playwright** (Microsoft, official) — E2E test authoring and execution. Complementary to chrome-devtools-mcp, not redundant with it: that's live debugging, this is persistent regression coverage. `/plugin install playwright`.
- **Anthropic LSP pack** — one plugin per language (`typescript-lsp`, `pyright-lsp`, `gopls-lsp`, `rust-analyzer-lsp`, `clangd-lsp`, `csharp-lsp`, `jdtls-lsp`, `kotlin-lsp`, `ruby-lsp`, `swift-lsp`, `php-lsp`, `lua-lsp`, `liquid-lsp` — 13 as of this writing, not the 12 some roundups cite). Real code intelligence (go-to-definition, find-references, diagnostics), not workflow scaffolding — no overlap with anything else here. Install the one matching your `DEFAULT_LANGUAGE` wizard answer: `/plugin install <lang>-lsp`.
- **pr-review-toolkit** (Anthropic official) — reads and posts to live GitHub PRs/issues directly (pr-test-analyzer, silent-failure-hunter, comment-analyzer agents). Distinct from the built-in `/review`/`/ultra-review` (local diff, no GitHub API) and GSD's code-review (planning-phase-oriented) — this is the one that actually touches GitHub. Worth it only if you live in PRs. `/plugin install pr-review-toolkit`.
- **linear** (official) — backlog/ticket read-write. Only useful if Linear is your actual system of record. `/plugin install linear`.
- **vercel** (official) — deploy logs, preview inspection, rollback, env vars. Locked to the Vercel platform; no value on AWS/Cloudflare/self-hosted. `/plugin install vercel`.

---

## Built-in commands (no install needed)

`/review` and `/ultra-review` ship with Claude Code 2.1.86+. Don't install them; just use them.

- `/review` — local structured code review. Fast, cheap, runs every time.
- `/ultra-review` — uploads to cloud sandbox, runs parallel reviewer agents, requires reproduction before flagging bugs. Use before merges that matter (refactors, payments, auth, DB migrations). 10–20 minutes; runs in background. Pro/Max plans get 3 free runs; otherwise $5–20 per run depending on size.

Requires being signed in with a Claude account (API key alone doesn't work).

## Community alternatives worth knowing

For specific scenarios, the broader ecosystem has high-quality alternatives:

- **caveman** (~28k★) — cuts ~75% output tokens by forcing terse phrasing. Useful when token cost dominates and prose quality is secondary.
- **mattpocock skills** (~47k★) — TypeScript-heavy, "skills for real engineers". Pairs well with backend-saas domain.
- **andrej-karpathy CLAUDE.md** (~100k★) — single CLAUDE.md derived from observations on LLM coding pitfalls. Reference, not necessarily install.
- **scientific-agent-skills** (~18k★) — research/science/engineering/finance/writing skills. Overlaps with our `domains/scientific-python.md` and `domains/data-analysis.md`; treat as a reference for ideas to incorporate.
- **academic-research-skills** (~3k★) — research → write → review → revise → finalize. Overlaps with `domains/academic-writing.md`.
- **humanizer** (~3k★) — removes AI-generated writing tells from text. Useful for content work.
- **n8n-skills** (~2k★) — for automation work. Overlaps with `business/automation-workflows.md`.
- **planning-with-files** (~10k★) — Manus-style persistent markdown planning.

Install only if the use case matches; resist the temptation to install everything (each plugin's tool definitions cost tokens at session start).

## Don't install

The skills/plugins ecosystem is mostly thin wrappers around well-known patterns. Adopting too many produces token bloat without proportional benefit. Pre-install ratio: you should be able to articulate, before installing, what specific failure mode it solves for you.

Install only what you'd be sad to lose.

## Maintenance

- Run `/plugin list` periodically to see what's installed
- Run `/plugin update` when prompted; features and fixes ship regularly
- Uninstall plugins you don't actually use (`/plugin uninstall <name>`) — context cost compounds
- Review this list quarterly; the ecosystem moves fast

## See also

- `core/skills/operating/token-discipline.md` — why these plugins matter at the context level
- `core/skills/operating/walkthrough-then-codify.md` — walk the workflow first; the skill-creator plugin does the packaging
- `ecosystem/external-skills.md` — broader curated reference

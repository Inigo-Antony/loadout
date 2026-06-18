# Plugins to Install

Curated set of Claude Code plugins worth installing — this is Loadout's Layer 1. Source: Nate Herk's "I tried 100+ Claude Code skills, these 6 are the best" plus broader community consensus from ScriptByAI's 2026 list. The default (layered) `install.sh` run provisions this set automatically; `--standalone` skips it.

> Plugins differ from skills: a skill is a markdown file teaching Claude how to do a job better. A plugin is a larger package that may include multiple skills, hooks, MCP servers, and behavioural changes.

## Recommended baseline (install globally)

These pay back across every project. Install once with global scope; they auto-invoke when relevant.

> **Marketplaces first.** A plugin lives in a *marketplace* (a git repo). `claude plugin install <name>@<marketplace>` fails with "not found in marketplace" unless that marketplace has been registered with `claude plugin marketplace add <owner/repo>`. Each block below does both steps. `install.sh` automates the whole set; these manual commands are for installing one plugin on its own. `marketplace add` is safe to re-run — it's a no-op if the marketplace is already present.

### 1. skill-creator (Anthropic official)

**What it does:** Builds new skills from natural language. Describe the workflow; the plugin drafts, tests, iterates, and packages it. Removes the manual `SKILL.md` formatting work.

**Install:**
```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install skill-creator@claude-plugins-official
```

**When it triggers:** Any time you describe a workflow you want reusable. The plugin recognises the intent and offers to build the skill.

**Why install globally:** You'll create skills across projects; baking it into every project is wasteful.

---

### 2. superpowers (community, ~170k★)

**What it does:** Forces senior-developer rhythm on Claude. Instead of jumping to code, Claude plans first, works in an isolated environment, writes tests before implementation, and reviews its own output in two stages (spec match + code quality).

**Install:**
```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install superpowers@claude-plugins-official
```

**When it triggers:** Any production code work. Most beneficial on features the client will actually run; less useful for one-off scripts.

**Cost:** uses more tokens than default rhythm — but reduces debug cycles and the rate of broken-in-production. Net positive on real work.

---

### 3. context-mode (community)

**What it does:** Sandboxes tool calls — a Playwright snapshot or a 50-page log doesn't dump raw into context. The sandbox extracts only what Claude actually needs (a 56KB snapshot becomes ~300 bytes; benchmark shows ~98% reduction over a working session). Tracks events in local SQLite and rebuilds session state when `/compact` runs.

**Install:**
```bash
claude plugin marketplace add mksglu/claude-context-mode
claude plugin install context-mode@context-mode
```

**When it triggers:** Any session that touches tool output (browser automation, log files, large API responses, web fetches). The plugin auto-installs an MCP server, hooks, and routing instructions.

**Effect:** sessions that used to fall apart at 30 minutes can run for hours.

---

### 4. claude-mem (community)

**What it does:** Cross-session memory. Hooks into Claude's session lifecycle, captures file edits, decisions, bug fixes, commands. Compresses to semantic summaries via Claude's agent SDK. Stores in local SQLite with vector search. Three-layer retrieval (compact index → timeline → details) — reports ~10× token savings vs naive context dumping.

Auto-generates and updates folder-level CLAUDE.md as you work.

**Install:**
```bash
claude plugin marketplace add thedotmack/claude-mem
claude plugin install claude-mem@thedotmack
```

**When it triggers:** Every new session — automatically pulls in relevant prior context. No manual invocation.

**Important:** Don't run the npm install line that some guides mention; it installs the SDK only and the hooks never register. Use the plugin install command above.

---

### 5. GSD (Get Shit Done)

**What it does:** Context engineering via fresh sub-agents per task. Each sub-agent has a clean window; the main session stays clean. Quality gates: scope-reduction detection (catches the planner silently dropping requirements), security enforcement anchored to your threat model. Has an autonomous mode for spec-and-walk-away workflows.

**Install:**
```bash
claude plugin marketplace add jnuyens/gsd-plugin
claude plugin install gsd@gsd-plugin
```

**When it triggers:** Multi-step tasks where one context would degrade. Type `/gsd-help` to see commands.

**Cost:** sub-agents use tokens; saves the time you'd otherwise spend redoing work Claude broke because it forgot the spec. Net positive on substantial tasks.

---

### 6. frontend-design (Anthropic official)

**What it does:** Provides design tokens, component patterns, and styling conventions for frontend work. Reduces the "looks AI-generated" output common in default frontend code.

**Install:**
```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
```

**When it triggers:** Any UI / web / component work.

**Why install globally:** Frontend work crosses projects; install once.

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

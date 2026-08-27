---
name: token-discipline
description: Always-relevant guidance on context budget management. Apply automatically — the agent should monitor its own context usage, prefer skills over instructions, and use compaction/clearing tools deliberately rather than letting context bloat degrade output quality.
---

# Token Discipline

Context is a budget, not a free resource. Above ~70% utilisation, output quality starts to degrade noticeably; above ~85% it falls off a cliff. Every token in the window competes with every other token for the model's attention. The cheapest accuracy gain is keeping the window lean.

## The core rule (Ross Mak)

**Skills > AGENTS.md / CLAUDE.md.** A 1,000-line CLAUDE.md adds ~7,000 tokens to *every* turn. A skill with the same content adds ~50 tokens (name + description) until the agent decides it's relevant, then loads the body once. Default to skills. Reserve CLAUDE.md / AGENTS.md for content that genuinely needs to be present every turn — proprietary conventions, hard rules, project-specific glossary.

What does NOT belong in CLAUDE.md:
- Stack info the codebase already reveals ("this project uses React" — `package.json` says so)
- General best practices the model already knows
- Long style guides — those are skills
- Anything starting with "Always remember to…"

## Tactical tools (Claude Code)

| Command | Use when |
| --- | --- |
| `/init` | Starting a new or existing project — scaffolds a project memory file from the codebase |
| `/context` | Diagnose token bloat. Shows percentages by source (system prompt, files, MCP tools, conversation). Run when a session feels sluggish. |
| `/compact` | At ~60% utilisation. Compresses conversation history. Pass keep-instructions: `/compact but keep all API decisions and the data schema`. |
| `/clear` | Switching to an unrelated task. Wipes conversation; CLAUDE.md and skills persist. |
| `/resume` | Pick up a previous session by ID instead of re-explaining context. |
| Status line (`/statusline`) | Persistent display of model, context %, cost. Critical for catching bloat before it bites. |
| Plan mode (Shift+Tab) | Plan-only — Claude reads, researches, drafts steps, but writes nothing until you exit plan mode. |
| `ultrathink` | Allocates ~32k thinking tokens before responding. Use for architecture decisions, hard debugging, refactors that touch multiple files. Don't waste it on simple edits. |

## MCP discipline

MCP servers load their full tool definitions into context. Each enabled MCP costs hundreds to low-thousands of tokens *baseline*. The 200k window can shrink to ~70k usable with too many enabled.

Rules of thumb (from ECC):
- Configure many (20–30) MCPs globally, but **enable <10 per project**
- Keep total active tools under ~80
- Use `disabledMcpServers` in project config
- For narrow needs (read one Notion DB, hit one API endpoint) — skip the MCP entirely and call the API directly. The MCP's value is breadth; if you need one function, breadth is a tax.
- Context7 MCP is the exception worth almost-always-on for coding projects: it pulls live, version-specific library documentation and prevents the model from hallucinating deprecated APIs.

## Sub-agents save the parent's context

When a side task will produce verbose intermediate output (searching a codebase, reading logs, scraping pages, parallel research) — delegate to a sub-agent. The sub-agent runs in its own context window; only the summary returns. The parent context stays clean. Pair with cheap models: sub-agents on Haiku/Sonnet, parent on Opus.

## Operating heuristics

- Watch the status line. If you don't have one, you can't see context fill until it's too late.
- Compact at 60%, not 90%. Compaction at 90% loses material.
- Clear ruthlessly between unrelated tasks — the conversation history isn't free.
- One question per task. Long forking conversations bloat context with reasoning that's no longer relevant.
- For research-heavy work that needs many sources, use sub-agents or save findings to files and `/clear`, then re-enter only what's needed.

## When the budget is tight

Triage in this order:
1. Drop unused MCPs (`/context` will show the cost)
2. `/compact` with keep-instructions
3. Move bulky always-on instructions into a skill
4. Move conversation state into files; `/clear`; reload only what's needed
5. If you've hit `/compact` twice in one session, the task is too big for one context — split it

## Plugin layer (install once, benefits compound)

Three community plugins solve token problems structurally rather than tactically. See `ecosystem/plugins-to-install.md` for install commands.

- **context-mode** — Sandboxes tool calls and returns only the relevant slice to the model. A 56KB Playwright snapshot becomes ~300 bytes; a 46KB access log becomes ~150 bytes. Reported ~98% reduction across a working session. Solves the "tool output floods context" failure mode that no `/compact` can recover from.
- **claude-mem** — Cross-session memory in a local SQLite database with three-layer retrieval (index → timeline → details). Auto-generates folder-level CLAUDE.md and updates as you work. Eliminates the start-of-session re-explanation tax. Works in tandem with context-mode: context-mode keeps *this* session clean; claude-mem carries knowledge between sessions.
- **GSD** (Get Shit Done) — Spawns fresh sub-agents per task with isolated contexts and quality gates (scope-reduction detection, security enforcement). When a task would otherwise sprawl across 60% of one context, GSD splits it into clean child contexts and integrates summaries back. Also has an autonomous mode for hand-off-and-walk-away workflows.

These three together address the dominant token failure modes: pollution from tool output, repetition across sessions, and degradation late in long tasks. None replace `/context` discipline — they extend its ceiling.

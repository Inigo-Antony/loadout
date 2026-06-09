---
name: subagents-and-teams
description: Decide between default mode, sub-agents, and agent teams based on whether the work is sequential, parallelisable-but-independent, or parallelisable-and-coupled. Apply when the task is large enough that one context window will degrade, or when wall-clock time matters.
---

# Sub-agents and Agent Teams

Three modes. Pick the lightest one that fits.

## Mode 1: Default (single agent)

One context window. Sequential work. Best for tasks that:
- Fit comfortably in one context
- Have strict ordering (each step depends on the last)
- Don't produce verbose intermediate output

Do not over-architect. Most tasks are this.

## Mode 2: Sub-agents (parallel, isolated)

Each sub-agent runs in its own context window. The parent orchestrates and receives only summaries. Sub-agents cannot communicate with each other.

**Use when:**
- A side task will produce verbose output the parent doesn't need to retain (search a codebase, read logs, scrape pages)
- Multiple *independent* tasks can run in parallel (research three competitors; document fifty functions; test three implementations)
- You want to run sub-tasks on a cheaper model (Haiku/Sonnet sub-agents under an Opus parent)

**Cost benefit:** the parent's context stays clean → higher accuracy on synthesis. Wall-clock time roughly divided by parallelism.

**Don't use when:** the sub-tasks need to share decisions. If sub-agent 1 defines a data type and sub-agent 2 needs to use it, they will silently produce mismatched outputs because they cannot talk. This is the classic frontend/backend type-drift failure.

## Mode 3: Agent teams (parallel, communicating)

Multiple agents run in parallel AND can message each other. A team lead spawns workers; workers can share artifacts and decisions; you can talk to any member directly.

**Use when:**
- Coupled parallel work — backend + frontend + tests + matching algorithm where decisions in one branch affect the others
- You'd otherwise spend the time integrating sub-agent outputs that drifted
- Long-running multi-component features where coherence matters more than speed

**Costs:** agent teams burn more tokens (more agents × longer runs) and are slower per agent than isolated sub-agents (communication overhead). They produce more cohesive output for genuinely coupled work.

**Setup (Claude Code):**
1. `claude update`
2. `brew install tmux` (Linux: `sudo apt install tmux` / `sudo dnf install tmux`)
3. Enable agent teams + tmux split panels in settings
4. Start session; agents appear in tmux panes
5. `Ctrl+B` + arrow keys navigate between panes; you can talk to any agent or to the orchestrator

## The decision tree

```
Is the task one focused thread, fits in one context?
├─ Yes → Default mode
└─ No → Are the parallel pieces independent (no shared decisions)?
        ├─ Yes → Sub-agents
        └─ No → Agent team
```

## Common patterns

For most single-track work — drafting one document, debugging one program, modelling one system — default mode is correct. Sub-agents start to earn their cost when:

- **Pipeline at scale**: scraping multiple sources in parallel; spawning a sub-agent per item for research; main thread synthesises and drafts.
- **Research with parallel reading**: sub-agents read papers / docs / threads in parallel; main thread builds the artefact.
- **Multi-document work**: sub-agents draft sections in parallel given a shared outline.

Agent teams genuinely fit only when building a multi-component application where pieces must align — most everyday work doesn't qualify.

## Convert successful runs to skills

When a sub-agent or team configuration produces a good run, prompt: *"Based on this conversation, create a skill that spawns this agent configuration with [parameter] as input."* Reuse the configuration without rebuilding the prompt every time.

## See also

- `core/skills/operating/token-discipline.md` — why sub-agents help even when not strictly needed
- `core/skills/operating/walkthrough-then-codify.md` — converting a successful team run into a reusable skill

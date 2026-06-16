Every multiplayer game makes you pick a loadout before you spawn.

The map is the same for everyone. The ruleset is the same for everyone. The only part that's actually yours is what you choose to carry in.

I realized my Claude Code setup had the opposite problem: I was re-fighting the loadout screen on every single project.

New repo → rewrite my CLAUDE.md by hand. My voice. My reasoning defaults. When to brainstorm versus just ship. How much token budget I'm willing to spend before I want the answer. From zero, every time.

Meanwhile I'd already adopted the frameworks that are genuinely good at this: superpowers, GSD, context-mode, claude-mem. They nail the engineering rhythm — TDD discipline, subagent orchestration, context sandboxing, cross-session memory. Excellent, and they keep improving for free as their communities work on them.

But none of them know anything about *me*. That was never their job. And I kept doing it by hand, every project, like the rebuild was just the cost of starting something new.

It isn't. So I built Loadout — a thin personal layer that sits on top of those frameworks instead of competing with them. It owns voice, reasoning defaults, and the brainstorm-to-shipped-outcome arc, and it explicitly yields to the engineering layer wherever they'd overlap. Personalization costs a small, flat, always-on token fee — it doesn't grow the deeper a skill goes, because each skill's body stays dormant until something actually matches.

Pick a preset, run the install wizard, or hand-compose your own. Re-run it safely on any project — it backs up what you had before writing anything fresh.

Repo: github.com/Inigo-Antony/loadout

Genuinely curious: what do you keep rebuilding from scratch on every new project — the thing that's "obviously yours" but never sticks? Drop it in the comments. I'll tell you what I'd put in your loadout.

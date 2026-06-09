---
name: incident-response
description: Structured symptom → hypothesis → narrow → fix → write-up flow for production breakage. Apply when something is broken right now in prod, when users are reporting errors, or when an alert just fired. Enforces evidence-before-action, single-engineer-driver, and a written postmortem so the same break doesn't recur.
---

# Incident Response

For the moment when production is broken and the constraint is *time*, not exploration. Different from regular debugging because the cost of a wrong guess is doubled (you're firefighting in a panic *and* you've burned minutes the user is still affected). Different from `plan-then-execute` because the planning loop has to compress to minutes, not hours.

The pattern is borrowed from incident commanders in operations-heavy organisations (SRE, NOC, hospital triage): a single driver, a clear log, a bias toward reversible action.

## Phase 0 — Decide if this is an incident

Not every error is an incident. Triage in 30 seconds:

- **Sev 1 / incident**: users can't use the product, data is at risk, revenue is bleeding, security event in progress. Page the team. Drop other work.
- **Sev 2 / degraded**: subset of users affected, workaround exists, no data risk. Acknowledge, mitigate, no all-hands.
- **Sev 3 / bug**: it's broken but nobody is yelling. File a ticket, go back to normal flow.

If you spend 5 minutes deciding, treat it as Sev 1 and pull the cord. The cost of an unneeded incident response is low; the cost of underclassifying a real one is high.

## Phase 1 — Establish the facts (T+0 to T+5 min)

Resist the urge to fix. First write down, in a scratch log or a chat channel:

- **What is the symptom?** What does the user see, what does the alert say, what is the failure mode in plain language. Not the cause — the symptom.
- **When did it start?** Look at the alert timestamp, the first user report, the deploy log. Bracket the window.
- **What changed?** Deploys, config changes, migrations, dependency releases, certificate expiries, traffic spikes. Anything in the last 24 h (and especially the last 30 min) is suspect.
- **What is the blast radius?** All users, one region, one tenant, one feature, one query? Define the boundary now.
- **Is data at risk?** If yes, that overrides everything else. Stop writes if necessary.

If any of these are unanswered after 5 minutes, the team is guessing. Pull more evidence (logs, metrics, status pages) before forming a hypothesis.

## Phase 2 — Designate a driver

One person runs the response. Everyone else feeds them evidence or stays out of the way. The driver:

- Owns the running log
- Decides the next investigation step
- Approves any change that touches prod
- Calls the all-clear or the escalation

Even on a team of two, name the driver explicitly. Without one, two engineers each silently assume the other has it, and nobody owns the timeline.

## Phase 3 — Hypothesis → narrow → confirm

The classic loop, with one hard rule: **no change to prod without a stated hypothesis and a stated rollback**.

1. **State the hypothesis** in one sentence. "The 5xx spike is from the new deploy because the migration is locking the orders table."
2. **State how you'd confirm it cheaply.** "Check the slow-query log; check the deploy timestamp vs the alert timestamp; check pg_locks."
3. **Run the cheap check.** Confirms or rejects the hypothesis. If neither, the hypothesis is too vague; refine.
4. **If confirmed, state the fix and the rollback.** "Roll back the deploy. Rollback is `git revert <sha> && deploy`."
5. **Execute.** Verify the symptom disappears. Wait 5 minutes; verify it stays gone.

Multiple competing hypotheses? Rank by likelihood and cost-to-test. Test the cheapest first, regardless of likelihood — speed beats elegance during incidents.

## Phase 4 — Mitigate before you fix

Stop the bleeding first. The clean fix can come after:

- Roll back the deploy (almost always available, almost always the right call early)
- Failover to a healthy region / replica
- Disable the broken feature flag
- Rate-limit the upstream pressure
- Manually patch the bad data, then automate the patch

Mitigation buys time. Time lets you fix properly. The instinct to "fix it right now" during an incident produces second incidents.

## Phase 5 — All-clear

Don't declare it over until:

- Symptom is gone for ≥ 10 minutes on real production traffic (not synthetic checks)
- The metrics that triggered the alert have returned to baseline
- Affected users have been told (status page, in-app, email — proportional to impact)
- The driver explicitly says "all-clear" in the running log

If a fix is "deployed and the dashboard is green", that's not all-clear yet — that's "early signs of recovery". Hold position.

## Phase 6 — Postmortem (T+24h to T+72h)

Non-negotiable for Sev 1 and Sev 2. Format:

1. **Timeline** — from first signal to all-clear, with timestamps. Pull from the running log.
2. **Root cause** — what actually broke and why. "Human error" is never a root cause; the system that allowed the human error is.
3. **Why was it missed?** What monitoring or test would have caught this earlier?
4. **What did we do well?** Faster mitigations than expected, good catches, good handoffs. Reinforce.
5. **What did we do poorly?** Slow detection, wrong hypotheses, missing runbooks, communication gaps.
6. **Action items** — each owned, each with a deadline, each tracked. Two categories: prevent recurrence, and improve response.

Blameless. The point is the system's failure modes, not the engineer's judgement under stress. A team that punishes mistakes in postmortems loses the truth in the next one.

Publish the postmortem internally at minimum. For external-facing incidents that hit customers, publish a customer-facing version too — it earns more trust than the silence does.

## Communication during the incident

- **Internal**: dedicated channel (`#inc-<short-id>`). Driver posts a status update every 15 minutes minimum, even if it's "still investigating". Silence reads as panic.
- **External**: status page updated within 10 minutes of confirming user impact. Use plain language. Don't speculate on cause until confirmed.
- **Stakeholders**: a one-line summary at start, mid-point, and end. Not a play-by-play.

Two anti-patterns: silent firefighting (no one knows what's happening) and over-narration (driver too busy typing to fix). Updates are short and consistent.

## When NOT to apply

- The failure is in a dev / staging environment → it's a bug, not an incident. File a ticket and fix it.
- A user reported a UI glitch with no impact on others → bug, not incident. Triage normally.
- The "incident" is actually a feature request escalating because someone is upset → social problem, not technical. Different skill entirely.
- You're the only person on the team and there's no on-call → still run the phases, but compress; do the postmortem with yourself afterwards.

## Anti-patterns

- Two engineers each independently restarting things in prod
- Changing config in prod without recording what was changed
- Fixing the symptom (raising a timeout) without diagnosing the cause (the slow query)
- Skipping the postmortem because "we figured it out" — the same break will recur in 90 days
- Declaring all-clear before the data has caught up
- Treating the incident as embarrassing and not telling users — users find out anyway, and the cover-up costs more than the outage
- Vague hypotheses ("something is wrong with the database") that can't be tested cheaply
- Running the incident in DMs instead of a logged channel — no log means no postmortem

## See also

- `core/skills/operating/plan-then-execute.md` — same shape, compressed to minutes
- `core/skills/thinking/systems-thinking.md` — for diagnosing root cause across coupled components
- `domains/backend-saas.md` — for the upstream practices (migrations, deploys, observability) that reduce incident frequency
- `domains/infra-containers.md` — for rollback, failover, region-level mitigations
- `core/pitfalls.md` — anti-patterns reference; cross-check the response against it during the postmortem

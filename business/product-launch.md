---
name: product-launch
description: Run the launch window — pre-launch checklist, channel plan, launch-day hour-by-hour, post-launch retro. Apply when shipping a product, feature, or release with a defined date that needs coordinated attention. Distinct from build/validation; this is the narrow time-boxed window where distribution either happens or doesn't.
---

# Product Launch

For the moment when something is built and the question is no longer "what to build" but "how to ship it so people actually notice". Launches fail in two predictable ways: the team treats launch day as a single push (no pre-launch warmup), or they spread it over weeks (no concentrated signal). Both leave distribution on the table.

This skill is for the **window** — the 30 days before, the 24 hours of, and the 14 days after. The decisions upstream of that (whether the product should exist, whether the price is right) live in `digital-products` and `outcome-framing`.

## Phase 1 — Frame the launch (T-30 days)

State each of these before any tactical work:

- **What is launching?** A product, a major feature, a milestone, a paid tier. Be specific.
- **Who is the audience?** Existing users, cold prospects, both. Cold launches need a channel; warm launches need an email.
- **What is the success metric?** Signups, paid conversions, upvotes, demos booked, press hits. One primary, at most two secondary. Numeric, with a target.
- **What is the launch surface?** Product Hunt, Hacker News, Reddit, X, LinkedIn, an email blast, a press push, all of the above. Pick by where the audience is.
- **What is the date?** Pick now. Tuesday–Thursday for Product Hunt; mid-week mornings for HN; tied to a calendar event if there's a hook.

If you can't answer these in one sitting, the product isn't ready to launch — it's ready to validate. Hand back to `digital-products`.

## Phase 2 — Pre-launch checklist (T-30 to T-3)

The checklist is non-negotiable. Anything missing on launch day reads as amateur.

### Product

- [ ] Live URL, no broken paths
- [ ] Onboarding flow tested by someone who's never seen it
- [ ] Sign-up works; payment works; refunds documented
- [ ] Status page or health check (people will check)
- [ ] Mobile experience verified — Product Hunt traffic is ~50% mobile

### Page / surface

- [ ] Landing page above the fold answers: what is it, who is it for, what's the ask
- [ ] Hero asset (image, video, or GIF) loads fast, communicates the value in 3 seconds
- [ ] Pricing visible and unambiguous; "contact us" only if genuinely enterprise
- [ ] FAQ pre-empts the three objections you've already heard from beta users
- [ ] Open Graph / Twitter Card images set; social previews look right

### Assets

- [ ] Tagline ≤ 60 chars, no jargon, no superlatives
- [ ] Description (one paragraph, plain language)
- [ ] 4–6 product screenshots or a 60-second demo video
- [ ] Logo at multiple sizes / dark and light
- [ ] Maker's first-comment draft (for Product Hunt / HN)

### Distribution

- [ ] Email list segmented; T-1 teaser and T-0 announcement drafted
- [ ] Social posts drafted for each platform (different copy per platform; don't cross-post identically)
- [ ] 10–20 supporters lined up who will see the launch and engage authentically in the first 6 hours
- [ ] Press / newsletter outreach sent T-7, with embargoed details
- [ ] Affiliate or partner channels notified

### Operations

- [ ] Support inbox monitored; first-touch SLA agreed (target: <30 min on launch day)
- [ ] Analytics in place (signups, conversion funnel, source attribution)
- [ ] Rollback plan if something breaks under load
- [ ] On-call rotation for launch day if it's a team

If any box is unchecked at T-3, slip the date. A delayed launch is recoverable; a botched launch usually isn't.

## Phase 3 — Launch day (T-0)

Launches reward concentrated attention. The first 6 hours set the algorithmic ranking on every distribution surface that matters. Plan the day hour by hour.

A standard Product-Hunt-shaped launch:

| Time (local) | Action |
| --- | --- |
| 00:01 PT | Go live on Product Hunt. Post maker's first comment. |
| 00:15 | Email blast to existing list. Tweet/post the launch with the link. |
| 00:30 | DM the supporter list with a personal note (not a template). |
| 01:00–06:00 | Reply to every comment within 15 min. Push to secondary channels (Reddit, LinkedIn) once initial traction is visible. |
| 06:00–12:00 | Reach out to anyone who shared early; ask if they'd write a quick review. Send any embargoed press now. |
| 12:00–18:00 | Sustain — respond to comments, share milestones ("we just crossed X"), post in relevant communities (no spam). |
| 18:00–24:00 | Closing push to your time-zone-late audience. Final thank-yous to the supporter list. |

Variants:

- **HN launch**: post early US morning, weekday, "Show HN: <plain title>". No marketing language in the title. Be in the comments answering, not promoting.
- **Newsletter launch**: send Tuesday–Thursday 9–10 AM in the audience's timezone. One CTA, above the fold.
- **Coordinated multi-surface**: stagger by 1–2 hours per surface so the team isn't split.

Single rule that overrides everything else: **answer every comment, in the first 24 hours, personally**. Silence reads as the launch already failed.

## Phase 4 — Post-launch (T+1 to T+14)

The launch was a spike. The job now is to convert spike attention into compounding signal.

- **Day +1**: thank-you post on every surface. Share the results so far (numbers if good, lessons if not). The post-launch follow-up earns goodwill the launch itself didn't.
- **Day +3**: write the launch retro publicly (blog or thread). What worked, what didn't, what the numbers looked like. Builds reputation for the next launch.
- **Day +7**: convert top engagers into something durable — email subscribers, free-tier signups, affiliates, testimonials, case studies.
- **Day +14**: measure against the success metric set in Phase 1. If hit, document the playbook for repeat use. If missed, diagnose: was it surface, asset, audience, or product? Don't blame "the algorithm".

## Phase 5 — The launch artefacts

Every launch produces the same handful of artefacts. Build them as a kit:

- **The page** — landing, designed for cold-traffic conversion
- **The one-pager** — PDF brief for press, partners, embeds; hand off to `report-generation`
- **The deck** — for investors / partners / press calls
- **The email sequence** — teaser, announce, day-1 follow-up, day-7 results
- **The social pack** — copy for X, LinkedIn, Reddit, image variants
- **The maker comment** — first-person, plain, no marketing-speak

Reuse the kit shape for every launch. Each subsequent launch gets faster.

## When NOT to apply

- The product hasn't been validated → run validation first (`digital-products`). A launched-into-the-void product wastes the launch surface.
- No audience and no distribution plan → either build audience first or launch on a marketplace (App Store, Gumroad, AppSumo) where distribution is borrowed.
- Internal release / soft launch → checklist still helps but skip the public-channel coordination.
- The product is for a specific industry where the audience isn't on Product Hunt / HN / X → use direct outreach, not surface launches.

## Anti-patterns

- Picking the launch date because the product is "ready" rather than because the audience is — there's no optimal day-of-readiness, just an optimal day-of-attention
- Posting on every channel with identical copy — flags as automated, kills engagement
- "Soft launching" indefinitely and never getting a clean spike — momentum needs a date
- Ignoring early comments because "we're busy with the launch" — the comments are the launch
- Treating the launch as one day instead of a 30+44-day window
- Launching the build instead of the outcome — "we shipped X" is not interesting; "X now solves Y for Z" is
- No retro → next launch repeats the same mistakes

## See also

- `business/digital-products.md` — validation, build, pricing decisions that precede launch
- `business/outcome-framing.md` — the page copy, the tagline, the recommendation framing
- `business/seo-and-marketing.md` — sustained distribution after the launch spike fades
- `business/content-creation.md` — the launch retro and ongoing channel
- `domains/report-generation.md` — the launch one-pager and post-launch report
- The installed planning rhythm (superpowers/GSD) — the launch is a plan-mode artefact in itself

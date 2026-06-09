---
name: monetization
description: Execution path for turning a project into revenue. Invoked from monetize-or-opensource after the monetize path is selected. Handles validation interviews, MVP scoping, pricing, distribution, and customer support setup. Distinguishes between owned-asset paths (compounds) and trade-time paths (doesn't).
---

# Monetization

Turning a working project into revenue. The path bifurcates immediately into two categories with different economics:

- **Owned-asset paths** — digital products, SaaS, courses, paid newsletters. Build once, sell many. Compounds.
- **Trade-time paths** — consulting, services, custom builds. Trade hours for money. Doesn't compound.

The MarksInsights critique applies: AI doesn't make trade-time paths into owned assets — it just makes the trade more efficient. Choose deliberately based on what you actually want long-term.

## Step 1 — Validate before building anything

Most monetisation attempts fail because they skip validation. Validation has three levels of strength:

1. **Weak** — people say "yeah, I'd buy that". Likes on social. Verbal interest. Almost meaningless.
2. **Medium** — people put down email/time. Waitlist signups, demo requests, calendar bookings. Moderate signal.
3. **Strong** — people pay. Pre-orders, paid pilots, deposit-and-build. The only real signal.

If you skip to building before reaching at least medium validation, you're betting weeks-to-months of work on a guess. Don't.

**Validation interview structure (5–10 conversations with prospective buyers):**
- "Walk me through how you currently handle [the problem]."
- "When did you last try to fix this? What did you try?"
- "What did you spend trying to fix it — time, money, frustration?"
- "If a perfect solution existed, what would it cost you to *not* have it?"
- "Would you pay $X for [your proposed solution]?" — observe their reaction more than the answer.

Watch for: enthusiasm without specifics ("yeah that'd be great"), shifting to feature requests, polite agreement. Listen for: a real story of trying to solve it, willingness to discuss real numbers, urgency.

## Step 2 — MVP scoping

The minimum viable version is the smallest thing that solves the validated problem. Not "minimum that ships" — minimum that *works for real customers*.

Cut ruthlessly:
- One use case. Not three.
- One platform. Not all platforms.
- One persona. Not "for everyone".
- One channel. Not omnichannel.

Every feature past the minimum delays revenue and increases the chance of building the wrong thing. You'll add what real customers ask for, not what you imagine they'd ask for.

**MVP timelines that work:**

| Path | MVP timeline | Revenue start |
| --- | --- | --- |
| Digital product (template, ebook, prompt pack) | 1–2 weeks | Same week as MVP |
| Cohort course | 2–4 weeks (curriculum), then sell-then-build | Pre-sell before building |
| Self-paced course | 4–8 weeks | Available immediately on launch |
| Paid newsletter | 0 days (first issue is the MVP) | First send |
| SaaS product | 4–8 weeks for narrow vertical | Beta pricing before full launch |
| Consulting service | Days (you can deliver now) | First engagement |

Anything longer than the timelines above suggests over-scoping. Recheck.

## Step 3 — Pricing

Pricing is the highest-leverage decision. Most underprice; few overprice.

**Anchors that work:**

- **Value-based** — what's the problem worth to the buyer? Price at 10–30% of that value. (Saves $20k/year? Price $2–6k.)
- **Comparable products** — what does the market price similar things at? Price near the top half if your offering is differentiated.
- **Cost-plus** — only acceptable for genuinely commodity products; usually undersells

**Tiering strategy:**

- Three tiers (not two, not five) — basic / standard / premium
- Make the middle tier the obvious value choice
- Top tier exists partly to make the middle look reasonable
- Differentiate by *outcome*, not feature count

**Things that command premium pricing:**

- Faster results (time-to-value)
- Custom or done-for-you components
- Direct access to the creator
- Implementation help, not just access
- Money-back guarantees (lower buyer risk)

**Test prices.** Launch at one price; revisit after 50–100 sales. Most products price too low at launch and stay there.

## Step 4 — Distribution and launch

A product without distribution doesn't sell. Pick the channel before launch:

- **Existing audience** (your email list, social, community) — by far the easiest if you have one
- **Marketplace** (Gumroad, AppSumo, Product Hunt, Etsy, App Store, etc.) — less margin, more visibility
- **Direct outreach** — for high-ticket, smaller markets
- **Paid ads** — only after organic validation; not for cold launch
- **Partnership / affiliate** — leverage someone else's audience for revenue share

The launch event itself matters. A coordinated launch (announcement to your audience + Product Hunt + a Twitter thread + email to your list) on the same day produces orders of magnitude more than dribbling it out.

## Step 5 — Customer support and operations

The work after launch is what determines whether the business is sustainable.

- **Response time** — under 24 hours is the bar. Faster is better.
- **Refund policy** — generous. The 1–3% who refund cost less than fighting them.
- **Documentation / FAQs** — every recurring question gets a written answer; future buyers find it themselves.
- **Update cadence** — for products that should evolve (software, courses), regular updates retain customers.
- **Churn vs acquisition focus** — for subscription/recurring, retaining one customer is cheaper than acquiring two; balance accordingly.

## Step 6 — Iterate based on real data

After launch, the priorities reorder:

1. **What customers actually do with it** (not what they said they would)
2. **What customers ask for** (the feature requests reveal real demand)
3. **Where they churn / refund** (the failure modes you didn't anticipate)
4. **What sales conversations stall on** (objections, missing trust signals, unclear value)

Build the next version based on these signals, not on your roadmap from before launch.

## The trade-time-for-money trap

If your monetisation path is consulting / services / custom work — you have a job, not a business. Income stops when you stop. Per the MarksInsights observation: AI makes the trade more efficient (3–5× speed), but the ceiling is still hours × rate.

Acceptable reasons to choose trade-time anyway:
- Want income within weeks, not months
- Enjoy client work and don't want owned assets
- Building case studies that will support productisation later
- Supporting an owned-asset business (consulting funds product development)

If none of those apply, ask whether the project could become an owned asset instead. Often, the same domain knowledge can productise into a course, a tool, or a community with very different long-term economics.

## Open-core hybrid

For software projects: the foundation is open source (drives adoption, builds trust, enables community); a hosted/premium version is paid (generates revenue from the subset of users with real budgets).

What works for paid tier:
- Hosting / managed instance
- Compliance and SLA
- Premium support
- Advanced features that primarily benefit organisations (SSO, audit logs, multi-user)
- Priority feature development

What doesn't work:
- Crippling the open version to drive paid conversion (community notices and forks)
- Paid features individuals would expect for free
- Pricing that undercuts the value of the free version

## When NOT to monetise

- Project doesn't address a real, validated problem
- Validation interviews reveal "interesting but I wouldn't pay"
- The market segment is too small at viable price points
- Compliance / regulatory constraints make monetisation harder than open-source
- You don't have the energy for customer support and ongoing iteration

## Anti-patterns

- Building before validating
- Pricing low because "I'm new"
- Launching to no audience and expecting organic discovery
- Treating sales as an admission of failure to be done by someone else
- Confusing "many free users" with "monetisable"
- Adding features instead of marketing existing capability
- Discounting deeply at launch — sets a price ceiling forever
- Ignoring refund/support requests because the work isn't fun

## See also

- `meta/monetize-or-opensource.md` — the parent decision skill
- `meta/sub/open-sourcing.md` — for the open-core route or a parallel OSS layer
- `business/digital-products.md` / `business/ai-consulting.md` / `business/automation-workflows.md` — specific monetisation forms
- `business/outcome-framing.md` — for the pitch language and pricing framing
- `business/seo-and-marketing.md` — for distribution

---
name: frontend
description: Operating instructions for website and frontend design work. Apply when generating UI, layouts, or design systems. Enforces taste discovery before generation and accessibility as a baseline, not an afterthought.
---

# Website Design

> Skeleton module. Add specific design preferences (typography, palette, motion) as taste solidifies.

## Discover taste before designing

Don't generate to defaults. Ask:

- **Reference sites**: 2–3 sites/products that capture the aesthetic the user wants
- **Mood**: editorial / utilitarian / playful / brutalist / minimal / dense?
- **Density**: information-rich (Bloomberg) vs spacious (Stripe)?
- **Motion**: static, subtle, expressive?
- **Brand constraints**: existing logo, colours, typography that must hold

If none of this is provided and the request is "make a landing page", ask first. The fastest way to a good design is one round of clarification, not three rounds of generation.

## Defaults that hold up

When in doubt:

- **Type**: a system font stack or one Google font (Inter, Geist, IBM Plex). Two faces maximum: one display, one body. Sizes on a scale (e.g. 12 / 14 / 16 / 20 / 28 / 40 / 64).
- **Spacing**: a 4px or 8px scale. Don't invent gaps.
- **Colour**: one neutral scale (grey or warm grey, 9–10 stops) + one accent. Add semantic colours (success / warning / error) only when needed.
- **Layout**: 12-column grid; max content width 1200–1280px for marketing, 1440–1600px for app.
- **Radius**: pick one (4 / 8 / 12px) and use it consistently. Mixing radii = visual noise.

## Accessibility baseline (non-negotiable)

- Contrast ratio ≥ 4.5:1 for body text, ≥ 3:1 for large text and UI components. Use a checker.
- All interactive elements keyboard-reachable; visible focus state on every one.
- `alt` text on every meaningful image; `alt=""` on decorative ones.
- Semantic HTML: `<button>` for actions, `<a>` for navigation, headings in order (no `h3` after `h1` skipping `h2`).
- Forms: every input has a label; errors announced with `aria-live`; placeholder is not a substitute for label.
- Don't rely on colour alone to convey meaning (e.g. error states need an icon or text, not just red).

## Component patterns

- **Buttons**: primary / secondary / ghost / destructive — four variants is usually enough. Each in three sizes (sm / md / lg).
- **Forms**: label above input, helper text below, error text replaces helper text on error.
- **Tables**: zebra striping only when density is high; sticky header for >10 rows; right-align numbers.
- **Modals**: only for blocking decisions or short forms. Otherwise use a side panel or a route.

## Performance

- Images: AVIF or WebP, with `srcset` for responsive sizing. No 4MB hero PNGs.
- Fonts: preload critical faces; `font-display: swap` to avoid invisible text.
- JavaScript: every interactive component has a non-JS fallback when feasible.
- Lighthouse score ≥ 90 on mobile is a reasonable bar for marketing sites.

## When designing for a Claude Code project

- Use the `frontend-design` skill (in `/mnt/skills/public/frontend-design/SKILL.md`) for environment-specific design tokens and component patterns.
- Don't reach for `localStorage` / `sessionStorage` in artifacts — they fail in the Claude.ai sandbox.
- Single-file artifacts unless asked otherwise.

## Process

1. **Wireframe first** (low fidelity, structure only) — confirms layout and IA before time goes into pixels
2. **Static high-fidelity** of one core page — confirms aesthetic
3. **Build out** other pages once aesthetic is approved
4. **Component extraction** — once 3 pages exist, common patterns become a system

Don't skip wireframes for non-trivial work. A wireframe takes 30 minutes; a wrong layout in production code takes a day.

## Anti-patterns

- Generating five pages before confirming the aesthetic on one
- Using stock UI library defaults uncritically — every component looks the same
- Adding micro-interactions everywhere; reserve motion for things that benefit from it
- Auto-playing video, pop-up modals on first visit, scroll-jacking
- Centred body text in long paragraphs

## See also

- `domains/backend-saas.md` — for the application surrounding the design
- `core/CLAUDE.md` — voice and copy preferences

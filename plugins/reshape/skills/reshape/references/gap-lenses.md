# Gap lenses

What to look for when auditing a PRD. These lenses find candidates; your judgment decides which ones actually matter for *this* feature and its next stage. A lens that doesn't apply produces no questions. Don't turn this file into a questionnaire.

**If the team has its own PRD standard** (template, checklist, README rules), audit against that first. Its required sections and checklist items are the definition of "complete" that the team will be held to, so an empty checklist answer or a missing required section is a gap even when no lens below would flag it.

## Contents

1. The four tests
2. Core lenses (any PRD)
3. Emphasis by next stage
4. Design lens (anything with a UI)
5. Feature-type lenses
6. Vague-language watchlist
7. Severity calibration

---

## 1. The four tests

Run every requirement through these. A requirement that fails one has a gap.

- **Two builders:** would two competent builders produce the same thing from this sentence? If they'd diverge, the sentence is ambiguous.
- **Guess:** what would the designer, engineer, or QA have to invent, assume, or come back and ask?
- **Pass/fail:** could QA write a test that clearly passes or fails against it?
- **Failure:** does it say what happens when the thing is empty, wrong, slow, at its limit, done twice, undone, or done by someone without permission?

And one test for the whole doc:

- **Why:** is the reason behind each significant requirement stated or obvious? Requirements without a why get cut under pressure or gold-plated without it.

## 2. Core lenses (any PRD)

1. **Problem & evidence** — who hurts, how much, how we know (data, research, quotes), why now. Is the PRD a *solution* without a stated problem? Is the evidence about the same users the feature targets?
2. **Users & context** — segments and roles; who is *not* a user; permissions per role; device and surface; frequency; expertise; state of mind (rushed, anxious, exploring). Are "users" one group or several with different jobs?
3. **Outcome & success** — a metric with baseline, target, timeframe, and data source; a guardrail metric (what must not get worse); how we'd know it failed; whether the events needed to measure it exist.
4. **Scope** — in, out, and later; the smallest version that solves the problem; explicit non-goals; what this must not break. Scope without an out-of-scope list isn't scope.
5. **Timing** — when it has to ship and what drives that date (a deal, an event, a contract, a dependency); what gives if it slips — scope, quality, or the date. A PRD with no date is a gap whenever the next stage is planning work.
6. **Behavior** — flows start to finish (entry points, happy path, alternate paths, exits); business rules, calculations, validations, defaults, limits; configuration (who can change what, at which level — org, team, user, per action).
7. **States & edge cases** — empty, first-run, loading, partial, error, success, permission-denied, offline or slow, at limit or quota, duplicates, concurrent edits, undo and reversibility, destructive actions and their confirmation, deletion and what it cascades to, time zones, localization (long strings, right-to-left, formats).
8. **Data & content** — what's shown and captured; the source of truth; lifecycle (create, edit, delete, retain, archive); migration or backfill of existing data; privacy, PII, consent; copy, notifications, emails, error messages; analytics events needed for lens 3.
9. **Dependencies & constraints** — other teams, features, or PRDs (recorded on *both* sides); third parties; platform rules; legal and compliance; budget.
10. **Non-functional** — performance targets (with numbers), scale, reliability, security, accessibility (target standard), supported platforms and browsers, localization.
11. **Rollout & operations** — phasing, feature flags, beta cohort, migration, backward compatibility, pricing, packaging, entitlements, support and docs, monitoring, kill switch, launch comms.
12. **Risks & assumptions** — what must be true for this to work; what would kill it. Run a quick pre-mortem — "it launched and flopped; why?" — and turn the likeliest answers into questions or Risks lines. Look especially for side effects on what already exists: a new price that undercuts an existing plan, a new notification that adds to the noise the feature was meant to cut, a permission change that widens who sees what.
13. **Ownership & open items** — owner and decision-makers; existing TBDs; questions without owners; decisions without dates.
14. **Consistency** — contradictions between sections or between the PRD and its sources; terminology drift (one concept, several names — use the glossary's term if there is one); numbers that don't add up; statements superseded by later decisions in the logs.
15. **Future-proofing** — what's planned *after* this (later phases, an AI layer on top of a manual flow, v2) and whether this version accidentally forecloses it. Only ask when a later phase is known or obvious.

## 3. Emphasis by next stage

"Blocking" depends on who reads the PRD next.

| Next stage | Lean hardest on | Typical blocking gaps |
|---|---|---|
| Design | 1, 2, 4, 6, 7, copy from 8, plus the design lens | who the user is; core flows; which surfaces; scope edges; states |
| Engineering | 4, 5, 6, 7, data from 8, 9, 10, 11 | rules and limits; data lifecycle; dependencies; performance numbers; migration |
| QA | 6, 7 — every requirement passes the pass/fail test | untestable requirements; unspecified error behavior |
| Launch / GTM | 3, 5, 11, comms from 8 | success metric; rollout plan; pricing and packaging |
| Exec / approval | 1, 3, 4, 5, 12, plus cost and effort | the problem and its evidence; the success metric; the scope; the risks |

## 4. Design lens (anything with a UI)

- **The job, not the feature.** Reframe the feature list as what the user is trying to get done. A PRD often ships a solution disguised as a problem.
- **Surfaces** — which existing screens and components change, and which are new.
- **Flows per surface** — entry and exit points; what the user came from and goes to next.
- **States per surface** — from core lens 7; list only the ones that apply.
- **Data the UI needs** — what's on screen, where it comes from, what happens while it loads or when it's missing.
- **Copy & content** — labels, empty-state text, errors, confirmations, notifications.
- **Interaction & motion** — only where it carries meaning (progress, causality, undo), not decoration.
- **Design-system fit** — what existing components cover, what's genuinely new.
- **Design principles** — two to four tiebreakers for the trade-offs that will come up ("never a dead end", "one primary action per view").
- **Usability success** — task completion, time on task, error rate; falsifiable, never "looks clean".
- **Not designing** — what is explicitly out of the design scope.

## 5. Feature-type lenses

Use the ones that match the feature; ignore the rest.

**AI / ML features** — typically *blocking*: where the facts come from, the measurable quality bar, and what data goes to the model provider. Typically *important*: cost per action against a budget, latency, and what happens when the model or provider is down. Never leave these to a polish list.
- What the model does and must never do; inputs and outputs, with examples of good and bad output.
- Where the facts come from: does the model *generate* answers, or produce something (a query, a draft) that a deterministic system executes? In anything numeric or factual, generated facts are a blocking risk.
- The quality bar and how it's measured — an eval set, human review, an acceptance threshold.
- Failure modes — wrong, unsure, refuses, harmful, slow, unavailable — and the user experience for each.
- Human in the loop and autonomy — the default level, who can change it, what needs approval before it takes effect.
- Latency and cost per action; a budget; the fallback when the model is down.
- Data handling — what's sent to the model provider, retention, training use, PII, customer consent and contracts.
- Transparency (is AI output labeled?), feedback and correction loops, abuse and prompt-injection exposure.
- Direction for whoever writes the prompts: intent, tone, examples, what "good" looks like.

**API / platform / integration** — consumers and their use cases; the contract and versioning; auth and scopes; rate limits and quotas; error model; idempotency; pagination; SLAs; deprecation policy; docs, SDKs, sandbox.

**Data / analytics / reporting** — exact metric definitions (formulas), grain, freshness, source of truth, access control, export, backfill, historical accuracy when definitions change.

**Migration / infra / re-platforming** — what changes for users (ideally nothing); cutover plan; rollback; downtime; data verification; dual running; the migration's own success criteria.

**Growth / experiments** — hypothesis, variants, primary metric and minimum detectable effect, sample size and duration, guardrails, the decision rule, the ramp plan.

**Mobile** — offline behavior, push permission prompts, app-store review, OS and version support, deep links, background behavior.

**Payments / pricing / billing** — pricing model, proration, refunds and credits, failed payments and dunning, taxes and VAT, currencies, invoices, entitlements on upgrade and downgrade, migration of existing subscribers, and how the new price compares with existing plans (does it undercut one?).

**Notifications / messaging** — triggers, channels, frequency caps and digests (which messages go into a digest and which are sent on their own), preferences and opt-out, quiet hours, critical messages that bypass preferences, templates and copy, deliverability.

**Admin / internal tools / permissions** — the roles matrix, audit log, bulk actions, safeguards on destructive actions, impersonation.

**Regulated or sensitive domains** (health, finance, children, HR, legal) — the regulations that apply, consent, retention, data residency, audit trails, accessibility law.

## 6. Vague-language watchlist

Scan for these, then judge each one in context. Each hit that carries a requirement needs a number, a definition, an example — or an explicit "deliberately left to design".

- **Placeholders:** TBD, TBC, TODO, XXX, ???, `[brackets]`, "to be decided", "later" (with no when), empty checklist answers.
- **Unquantified qualities:** fast, quick, instant, real-time, easy, simple, intuitive, seamless, user-friendly, clean, modern, robust, reliable, scalable, secure, flexible, smart, delightful, accurate.
- **Unbounded quantities:** some, many, few, several, most, large, small, high, low, frequent, all.
- **Escape hatches:** etc., and/or, as needed, if possible, where appropriate, ideally, should/could/may (when it's unclear whether something is required), "support X", "handle X".
- **Unmeasurable goals:** improve, enhance, increase engagement, better experience, optimize, positive feedback.

## 7. Severity calibration

- **Blocking** — different plausible answers produce materially different products, designs, or estimates, or the next stage can't start correctly. Typical: who the user is, core scope, a contradiction in core behavior, the success definition when the doc is going for approval, an AI feature's source of truth.
- **Important** — a wrong guess causes rework or bugs, but work can start. Typical: error and empty states, limits, permission details, notification frequency.
- **Polish** — the doc gets clearer, but nobody would build the wrong thing without it. Typical: wording, minor edge cases, secondary metrics.

When unsure between blocking and important, pick important — over-calling "blocking" trains the user to ignore the label. But polish is never a behavior change: if a reasonable owner could answer it differently, it's at least important, and it gets asked.

# Example session

A complete reshape of a small PRD, showing the target quality at each step. The domain is incidental; what matters is the shape — how questions are anchored and kept short, how a messy reply gets interpreted, and how the answers land in the PRD.

## Contents

1. The input
2. First message
3. A messy reply, and how to read it
4. The PRD after round 1
5. Round 2
6. Wrap-up
7. Openers for a re-run and a stub
8. Strong and weak questions

---

## 1. The input

`docs/prd-bulk-import.md` (in git, clean):

```markdown
# PRD: Bulk contact import

_Owner: Maya Chen · Status: draft · Last updated: 2026-09-30_

## Problem
Sales teams moving to us from spreadsheets re-type their contacts by hand. On onboarding calls, new teams
say this takes them 2–3 days, and a third of trial teams never import anything.

## Goal
Make importing contacts fast and easy so new teams are productive on day one.

## Users
Sales reps and admins.

## Requirements
1. Users can upload a CSV of contacts.
2. We map CSV columns to contact fields automatically.
3. Duplicates should be handled.
4. Large files are supported.
5. Users see a summary when the import finishes.

## Metrics
- Increase activation.

## Open questions
- Do we support Excel files? (Maya)
```

A sibling, `docs/notes/2026-09-24-import-sync.md`, contains:

```markdown
- Max 50,000 rows per file for v1 (Priya: anything bigger needs the async pipeline, which is Q1).
- Excel (.xlsx) is v2 — CSV only for launch.
- Priya: dedupe should key on email; we don't have a reliable second key.
```

## 2. First message

With a structured question tool (Claude Code's `AskUserQuestion`), the setup part below — read, health, plan, sources — is the text message, and each question then goes out as its own tool call, one per screen. Question 1 becomes:

```json
{"questions": [{
  "header": "Who imports",
  "question": "Who can run an import? Users says \"Sales reps and admins\" — a 50,000-row import by any rep can flood a shared workspace, so this sets permissions and whether import is a setup step or an everyday tool.",
  "multiSelect": false,
  "options": [
    {"label": "Admins only (Recommended)", "description": "Importing is a one-time onboarding step, and admins own data hygiene."},
    {"label": "Admins + reps, own contacts", "description": "Reps can import, but only into contacts they own."},
    {"label": "Anyone, same rights", "description": "Simplest, but any rep can pollute shared data."}
  ]
}]}
```

A proposal question (like question 2 below) uses `Accept proposal (Recommended)` as its first option, with the full proposal in the description. The numbered text layout that follows is the fallback when no such tool exists — the content of each question is the same either way.


```markdown
## Reshaping `docs/prd-bulk-import.md`

**My read:** New sales teams spend 2–3 days re-typing spreadsheet contacts, and a third of trial teams never
import at all. This PRD adds CSV upload with automatic column mapping so a team is working in the product on
day one. Next stop: design and engineering.
_If this is off, correct me first — the questions below build on it._

**Health:** strong on problem and evidence · thin on success metric, duplicate rules, failure handling,
permissions · no conflicts
**Plan:** ~2 rounds, ~8 questions, blocking first. I'll write your answers into the PRD after each round —
it's in git, so `git diff` will show every change. Short on time? Say `quick` and I'll stop after the blockers.

**From your sources** — I'll write these in with your answers unless you object:
- Max 50,000 rows per file in v1 — `notes/2026-09-24-import-sync.md` → Requirement 4 (replaces "large files")
- CSV only at launch; Excel in v2 — same notes → resolves the open question on Excel
- Duplicates are matched on email — same notes (Priya) → Requirement 3

### Round 1 of ~2 — foundations

**1. Who can run an import?** · blocking
> Users: "Sales reps and admins."
A 50,000-row import by any rep can flood a shared workspace; this decides permissions, and whether import
is a setup step or an everyday tool.
a) Admins only ← recommended: importing is a one-time onboarding step, and admins own data hygiene
b) Admins, plus reps importing into their own contacts only
c) Anyone, same rights

**2. What number tells us this worked?** · blocking
> Metrics: "Increase activation."
"Activation" can't fail, so it can't guide trade-offs, and nobody will instrument it.
→ Proposed: share of new teams that import ≥100 contacts within 24 hours of signup reaches 60% within 90
days of launch. Guardrail: duplicate-contact support tickets don't rise. Accept, edit, or replace it.

**3. When a row's email already exists, what happens?** · blocking
> Requirement 3: "Duplicates should be handled."
Skip, overwrite, and merge are three different features with three different risks of losing data.
a) Skip the row and list it in the summary ← recommended: nothing is overwritten by surprise, and re-running is easy
b) Update the existing contact with the CSV's values
c) Let the person choose for each import

**4. What happens to rows that fail validation?** · important
> _Not covered:_ bad emails, missing required fields, unparseable dates.
All-or-nothing and partial import feel completely different to a user; without a rule, engineering picks one.
a) Import the valid rows; report failures with a downloadable error file ← recommended: users fix a few rows, not the whole file
b) Reject the whole file if any row fails

---
Reply however you like — e.g. `1a · 2 ok but 50% · 3 park → Priya`.
`rec` accepts all my recommendations · `park` sends a question to the open list (say who owns it) · `n/a` drops it · `stop` wraps up.
```

Note what's *not* asked: the row limit, the Excel question, and the dedupe key are all answered by the notes, so they're listed as fills, not questions. The problem statement is solid, so there's no question about it.

## 3. A messy reply, and how to read it

```
1 a but team leads too, they onboard their own pods. 2 target's fine, no idea on baseline tho, ask dev from
data. 3 c i think — customers hate losing data. 4 rec
```

- **Q1** → admins and team leads. But "team lead" isn't a role anywhere in the PRD — is it an existing role? That's a blocking follow-up for round 2. Write what's certain now: reps can't import.
- **Q2** → target accepted. The baseline is unknown → an open question owned by Dev (Data), type research.
- **Q3** → per-import choice. That implies a step in the flow and a pre-selected default → follow-up.
- **Q4** → recommendation accepted.
- **No objection to the fills** → write them in.

## 4. The PRD after round 1

Only the lines that the answers touch change. Everything else — the problem statement, the goal, the header — is left byte-for-byte as Maya wrote it.

```diff
 _Owner: Maya Chen · Status: draft · Last updated: 2026-09-30_
+_Owner: Maya Chen · Status: draft · Last updated: 2026-10-16_
```
(The header line is replaced, not duplicated — only the date changes.)

```diff
 ## Users
-Sales reps and admins.
+- **Who can import:** workspace admins and team leads (team leads onboard their own pods). Sales reps can't run imports.
+- **Who uses the result:** everyone in the workspace, under the existing contact permissions.

 ## Requirements
 1. Users can upload a CSV of contacts.
 2. We map CSV columns to contact fields automatically.
-3. Duplicates should be handled.
-4. Large files are supported.
+3. **Duplicates** are matched on email. For each import, the person chooses whether matching rows are skipped or update the existing contact.
+4. Files of up to 50,000 rows are supported. CSV only at launch; Excel (.xlsx) is planned for v2.
 5. Users see a summary when the import finishes.
+6. **Invalid rows** (bad email, missing required field, unparseable value) are skipped and valid rows still import. The summary lists the failures and offers a downloadable file of the failed rows, each with its reason.

 ## Metrics
-- Increase activation.
+- **Primary:** share of new teams that import ≥100 contacts within 24 hours of signup — target 60% within 90 days of launch. Baseline: open question 1.
+- **Guardrail:** duplicate-contact support tickets don't increase.

 ## Open questions
-- Do we support Excel files? (Maya)
+- ~~Do we support Excel files? (Maya)~~ **Resolved 2026-10-16:** CSV only at launch, Excel in v2 — see Requirement 4.
+1. **[non-blocking] What's today's baseline for new teams importing ≥100 contacts within 24 hours?** Needed to judge the 60% target.
+   Owner: Dev (Data) · Type: research · Proposed default: measure the last 90 days of signups before launch.
+
+## Decision log
+### 2026-10-16 — reshape session
+- Users, Requirement 3 — admins and team leads can import, reps can't; per-import choice between skip and update. _(answers)_
+- Requirements 3, 4 — duplicates matched on email; 50,000-row limit; CSV only, Excel in v2. _(from notes 2026-09-24 — confirmed)_
+- Requirement 6, Metrics — partial import with an error file; primary metric, 60% target, guardrail. _(recommended defaults; target confirmed)_
+- Open questions — baseline → Dev (Data). _(parked by the user)_
```

The report shown to the user before round 2:

```markdown
**Updated the PRD:**
- Users — admins and team leads can import; reps can't (Q1)
- Requirements 3, 4, new 6 — email matching with a per-import skip/update choice, 50,000-row limit, CSV only, partial import with an error file (Q3, Q4, notes)
- Metrics — primary metric, 60% target, guardrail (Q2)
- Open questions — Excel resolved; baseline added → Dev (Data)
- Decision log added at the end
```

## 5. Round 2

```markdown
### Round 2 of ~2 — behavior

**1. Is "team lead" an existing role, or a new one?** · blocking
> Your answer to Q1: "team leads too"
The PRD only defines admins and reps. An existing role is a checkbox; a new one is a permissions project.
a) It exists today — tell me its name in the product
b) It's new — add it to this PRD's scope
c) Admins only for v1; team-lead imports arrive with the roles work ← recommended: keeps v1 free of new permissions

**2. Which duplicate option is pre-selected?** · important
> Requirement 3 (from your answer to Q3): the person chooses for each import
Most people accept the default, so the default is what happens on most imports.
a) Skip ← recommended: the safe choice can't destroy data
b) Update

**3. What if a CSV column can't be mapped automatically?** · important
> Requirement 2: "We map CSV columns to contact fields automatically."
Exports name columns inconsistently ("E-mail", "Work email"), and some columns won't match any field.
a) Show a mapping step where unmatched columns can be assigned or ignored ← recommended
b) Ignore unmatched columns silently
c) Create a custom field for each unmatched column

**4. Can an import be undone?** · important
> _Not covered._
A wrong mapping across 50,000 rows is a disaster without undo, and undo shapes the summary screen.
a) Yes — "undo this import" for 7 days removes the contacts it created ← recommended
b) No — people delete contacts by hand
```

Reply: `1 c. 2 a. 3 rec. 4 no undo for v1, too expensive per Priya. stop after this, I need to get it to design`

"Stop" means: write this round's answers, then wrap up — don't start another round. Undo becomes an explicit out-of-scope item, because a builder would otherwise wonder whether it was forgotten:

```diff
-- **Who can import:** workspace admins and team leads (team leads onboard their own pods). Sales reps can't run imports.
+- **Who can import:** workspace admins. Sales reps can't run imports. (Team-lead imports arrive with the roles work — see Out of scope.)
```

```diff
-3. **Duplicates** are matched on email. For each import, the person chooses whether matching rows are skipped or update the existing contact.
+3. **Duplicates** are matched on email. For each import, the person chooses whether matching rows are skipped or update the existing contact; **skip** is pre-selected.
```

```diff
 6. **Invalid rows** (bad email, missing required field, unparseable value) are skipped and valid rows still import. …
+7. **Unmatched columns:** before importing, a mapping step lists any CSV columns that couldn't be matched automatically; each can be assigned to a contact field or ignored.
```

```diff
+## Out of scope (v1)
+- Team-lead imports — depends on the roles work.
+- Undoing an import — too expensive for v1 (Priya); people delete contacts by hand.
+- Excel (.xlsx) files — v2.
```

The round-2 decisions go into the same dated block as one or two more grouped lines, each tagged with its source. All of round 2's changes are made in one pass: one edit per section, one edit to the log.

## 6. Wrap-up

```markdown
## Done — ready for design, with 1 open question

**Changed:** Users, Requirements 2–4 (+ new 6, 7), Metrics · added Out of scope, Decision log · Open questions updated
**Closed:** 11 gaps (8 answered, 3 from your notes) · **Open:** 1, not blocking
**Review:** `git diff docs/prd-bulk-import.md`

**For owners** — ready to paste:
- **Dev (Data):** What share of new teams imported ≥100 contacts within 24 hours of signup over the last 90
  days? It's the baseline for the bulk-import PRD's 60% target.

Status says `draft` — set it to `ready-with-open-questions`?
5 polish items are left (wording, minor edge cases) — say `polish` whenever you want them.
```

## 7. Openers for a re-run and a stub

**Re-run** — lead with what changed and what's still open; don't re-audit settled ground:

```markdown
## Reshaping `specs/notification-preferences-prd.md` — second pass

**Since the last session (Oct 2):** 3 commits by Ana — snooze added (§4.6), email digest changed to
weekly-only (§5), SMS channel added as TBD (§3).
**Still open from last time:** #1 [BLOCKING] admin-enforced settings (Ana) · #2 quiet hours across time zones (Design)
**Conflict:** §5 now says "weekly only", but the Oct 2 decision was "daily or weekly, user's choice".

### Round 1 of ~2 — what changed
…
```

**Stub** — say what it is and offer to build it, rather than auditing five bullets:

```markdown
## Reshaping `docs/prd-team-billing.md`

This is a stub — five bullets and a TODO — so there's nothing to tighten yet, only foundations to lay. I'll
build it out with you through the same Q&A: two or three rounds, problem, users, and timing first. Each section gets
drafted from your answers and your pricing-call notes; anything you haven't decided becomes an open
question, not an invention. It isn't in git, so I'll keep a copy of the original as
`prd-team-billing.pre-reshape.md` before the first edit.

### Round 1 of ~3 — foundations
…
```

## 8. Strong and weak questions

| Weak | Why it's weak | Strong |
|---|---|---|
| "What are the success metrics?" | Generic; ignores what the doc says | "Metrics says 'increase activation' — which number, from what baseline, by when?" + a concrete proposal |
| "Have you considered error handling?" | Yes/no, unanchored, nothing to decide | "Nothing covers rows that fail validation — import the valid ones and report the rest, or reject the file?" |
| "Who are the users?" | Already answered ("reps and admins") | "Can reps import, or only admins? A 50,000-row import by any rep can flood a shared workspace." |
| "Shouldn't we just skip duplicates?" | Leading; the recommendation is baked into the question | Neutral options, with the recommendation marked beside one of them |
| "What's the size limit, which formats, and what about timeouts?" | Three decisions in one | Three questions — or fewer, if a source answers some of them |
| "What's the maximum file size?" | The notes already say 50,000 rows | Not a question at all: list it under "From your sources" |
| "Is this feature a good idea?" | Not answerable; sounds like a challenge | "§1 cites trial teams that never import — is the goal to win those trials, or to speed up teams that already would?" |
| Polish item: "No cap on imports per day in v1" | A real decision with a real alternative, slipped into an `apply`-all list | Ask it as a question — or park it for engineering with "no cap" as the proposed default |
| Polish item: "Imported contacts notify their owners" | Adds notifications; the owner never weighed in | A question: "Should imported contacts trigger the usual new-contact notifications? 50,000 rows means 50,000 alerts." |

---
name: reshape
description: >-
  Close the gaps in an existing PRD by interviewing its owner in chat, then writing the answers back
  into the PRD itself. Reads the PRD plus the discussion notes, linked docs, and team template around it;
  finds what a designer, engineer, or QA would otherwise have to guess (vague requirements, missing
  success metrics, fuzzy scope, unhandled edge cases, contradictions, TBDs); asks the critical questions
  one at a time, each with a recommended answer; then edits the PRD in place, logging every decision
  and parking anything unresolved as an owner-tagged open question. Use whenever someone wants a PRD,
  spec, product brief, one-pager, or requirements doc reviewed, stress-tested, poked holes in, tightened,
  de-risked, or made ready for design or engineering; says "grill me on this PRD", "what's missing from
  my spec", "find the gaps", "is this ready for eng?", or "ask me questions about this doc"; or wants to
  re-run on a PRD that changed. Works with Markdown, pasted text, Word/PDF exports, and connected docs.
metadata:
  author: iamshubhransh
  version: "2.1.0"
---

Turn a PRD that a team would have to guess from into one they can build from: find the gaps, ask the owner the questions that matter — in chat, a few at a time, each with a recommended answer — and write every answer back into the PRD itself. The PRD stays the single source of truth; nothing gets parked in a side document.

The failure this prevents is expensive and quiet: a designer or engineer fills a gap with their own guess, builds it well, and the team finds out in review that it was the wrong guess.

## How to behave throughout

- **You interview and edit; the owner decides.** Everything you write into the PRD traces to an answer, a source you cited to them, or a recommendation they accepted. Nothing reaches the PRD that the user hasn't seen in chat.
- **Ask only what you can't find.** Check the PRD, its neighbors, linked docs, and (for current behavior) the code first. Asking what the doc already answers is the fastest way to lose the user's trust.
- **Few, sharp, answerable questions** — anchored to the doc, saying what goes wrong if left open, with a recommendation so the user can answer with one keypress.
- **Upstream before downstream.** Problem, users, scope, and timing first; their answers rewrite everything below.
- **Respect the user's time.** Aim to finish in two rounds, and keep each round's writing to one quick pass — the user is waiting.
- **Don't manufacture questions.** If the PRD is solid, say so and stop.
- **Sound like a sharp senior reviewer:** direct, specific, no flattery, no filler.

## Phase 1: Find the PRD and everything around it

**Locate it:** whatever the user gave you (path, link, paste, attachment, or arguments such as `/reshape docs/checkout-prd.md quick, for design`); else a name match on folders, files, and titles; else search the working directory for `prd*.md`, `*-prd.md`, `*spec*.md`, `*requirements*.md`, `*brief*.md`, and PRD-looking docs under `docs/`, `product/`, `specs/`, newest first. One clear candidate → use it and say so. Several → list up to five and ask. None → ask the user to share it. If it isn't a local text file (pasted, Word/PDF, Google Docs/Notion/Confluence, a ticket, an image) or is split across files, read `references/sources-and-formats.md` now — it covers reading each one and writing back safely.

**Read the whole PRD** — tables, footnotes, appendices, comments. You can't call something missing until you've checked every section.

**Read what's around it** — the *why* usually lives outside the PRD:
- **Siblings:** brainstorms, discussion or meeting notes, research, decision records. Read the latest material first and anything that sounds like a decision. A logged decision the PRD doesn't reflect is a gap.
- **Linked local docs,** one hop out, when they bear on a likely gap.
- **The team's standard:** a template, README/CONTRIBUTING rules, a checklist, a glossary, `CLAUDE.md`/`AGENTS.md`. **It is your first lens** — its required sections and checklist items define "complete". Note what it says does *not* belong in a PRD (e.g. "product only — technical design lives in the TRD").
- **Earlier gap-closing sessions:** a decision log, changelog, or dated open questions; the file's git history. If found, this is a re-run — see Edge cases.
- **The code,** only for how something works *today*. When it differs from the PRD, that's a question, not an answer.

**Note the doc's shape** before touching it — structure, numbering, requirement IDs, style, terminology, language, metadata (owner, status, last updated, provenance), whether the feature is already live — and its **next stage** (design, engineering, QA, launch, approval). "Blocking" means blocking that stage; if you can't tell, assume design and engineering and say so.

## Phase 2: Audit silently

Read `references/gap-lenses.md`, then audit against the team's standard and those lenses, including the lens for the feature's type (AI, API, billing, notifications…). A **gap** is anything the next reader would have to guess. Quick tests: would **two builders** build the same thing from this sentence? Could QA write a **pass/fail** test? Does it say what happens when this is **empty, wrong, slow, at its limit, done twice, or undone**? Then a 30-second **pre-mortem**: it launched and flopped — why? The likeliest causes become questions, or lines in a Risks section.

For each gap, work out **where** (section + short quote, or the named absence), **severity** — *blocking* (different answers produce a materially different product, or the next stage can't start correctly), *important* (a wrong guess means rework or bugs), *polish* (clarity only) — and **path**: resolve it yourself from a cited source, ask, or route it to someone else. Give each question **your recommendation** with a one-clause reason; a question about a fact you can't check gets none, and you say so. Never prop up a recommendation with statistics you can't source; a guessed number is a placeholder.

Plan the rounds: blocking first, upstream before downstream (problem → users → scope → success → timing → behavior → states → non-functional → rollout). A round asks for **at most five decisions** — questions, plus anything routed or flagged for the user to weigh in on. Most PRDs close in two rounds and 8–12 questions; take a third round only if blocking or important questions remain. Re-plan every round across everything still open: follow-ups raised by answers compete with the remaining questions on severity rather than jumping the queue, and the feature type's must-asks come before nice-to-know detail — so a user who stops early has still been asked what matters most. Detail the next stage owns (where a control sits on screen, layout, UI wording) isn't yours to ask: note it as "left to design".

Special cases:
- **Contradictions** — within the doc, or between the doc and a log, a linked doc, or the code — are always questions: quote both sides, recommend one, never pick silently. When a later logged decision disagrees with the PRD, recommend the later one, but still ask.
- **A solution without a problem** ("add an AI assistant to the dashboard") — the first question reframes: state the underlying need you infer and ask whether it's right. A mandate from above is recorded as a constraint.
- **No identifiable user need** — blocking question #1; the PRD isn't ready for any stage until it's answered.
- **Cross-cutting gaps** — a term, convention, or contract spanning features. Don't settle a repo-wide convention inside one PRD: record the dependency and route the question to its owner.

## Phase 3: Open the session

Read `references/example-session.md` once before writing this — it shows the target quality for every message.

**First, one short text message** that sets up the session — no questions in it:

```
## Reshaping `<path or title>`

**My read:** <2–3 sentences: who it's for, the problem, what's proposed>. Next stop: <stage>.
**Health:** strong on <x, y> · thin on <a, b, c> · <n> conflict(s)
**Plan:** ~2 rounds, ~<q> questions, one at a time, blocking first; I'll write your answers into the PRD after each round.
**From your sources** — I'll write these in with your answers unless you object:
- <fact> — `<source>` → §<section>

Questions come next, one per screen: pick with the arrow keys, or choose "Other" to type your own answer — including `park → <owner>`, `n/a`, `you decide`, `quick`, or `stop`. If my read above is off, say so in the first one.
```

**Then ask the questions one at a time with the structured question tool** (in Claude Code, `AskUserQuestion`): one question per call, so the user sees a single question, moves through the options with the arrow keys, and can always type their own answer. Asking one at a time also lets each question adapt to the last answer. Map each question onto the tool like this:

- **question** — the question itself, then its anchor and stakes in a sentence or two: `Do the drawer changes apply to every opportunity? Student View says "Instead of showing opened PDF, show the following details" — if this covers every job, it's a redesign of every drawer.` For a conflict, quote both sides.
- **header** — the topic in at most 12 characters, e.g. `Drawer scope`, `Short JD`, `CTC rules`.
- **options** — 2–4 real alternatives, each a 1–5 word label with a one-line description of what it means and its trade-off. Put your recommendation first and end its label with ` (Recommended)`; its description carries the one-clause reason. Never add "Other" yourself — the tool always offers it.
- **A proposal instead of options** (a metric, a rule, a number): option 1 is `Accept proposal (Recommended)` with the full proposal in its description (or in `preview` when it's long), options 2–3 are the real alternatives; edits come through "Other".
- **A fact you can't check** ("does this field exist today?"): plain options, none marked recommended, and say in the question why there's no recommendation.

Never put two decisions in one question, and don't add a separate "park" or "skip" option — that's what "Other" is for. Keep round 1 to three or four questions — if your read-back is wrong, fewer are wasted. Anything the request or earlier conversation already answered counts as answered. If the user corrects your read-back, re-audit before continuing.

**No structured question tool** (claude.ai, other agents, or the user asked for text): fall back to one plain message per round with numbered questions — anchor quote, one line on why it matters, `a)`/`b)` options with `← recommended: <reason>` — and the reply legend: `rec` accepts all recommendations · `park` sends a question to the open list · `n/a` drops it · `stop` wraps up. The "all the questions at once" mode always uses this text format.

## Phase 4: Run the rounds

Each round: ask its questions one by one → write all of the round's answers to the PRD in one pass (Phase 5) → report → start the next round. Don't write after every single question; the round is the unit of writing.

**Reading replies** — a picked option is a clear answer; typed "Other" answers (and text-mode replies like `1a 2b` or "rec except 3") come in every format. Map each answer to its question:
- **Picked an option / accepted the recommendation** → a decision. **Free text** → a decision in their words, tightened, never reinterpreted.
- **"You decide"** → your recommendation, logged as delegated; for a blocking product call, say once that the owner should validate it.
- **"Don't know", "later", "skip", "not my call"** → an open question; suggest an owner role if none was named.
- **"N/A", "doesn't matter"** → drop it and don't re-ask; record it as out of scope if it's really a scope boundary.
- **No answer** → carry it once; if it's blocking and skipped again, park it as blocking.
- **Ambiguous, or conflicts with another answer** → don't guess; ask a short follow-up question next.
- **"stop" or "quick"** typed into any question → stop asking, write what you have, wrap up (parking the rest as below).
- **A question back** → a fuller recommendation with the trade-off; they decide.
- **New information that moves scope** → integrate it, re-plan, and say what changed.

**Reporting** — one line per section touched, with the question it came from:

```
**Updated the PRD:**
- §2 Users — primary user is the recruiter; hiring managers are read-only (Q1)
- Open questions — added #3 SSO for shared links → Security (Q4, parked)
```

**Polish as one short bulk list.** When only polish remains, list it in one text block (at most eight numbered items), then ask a single question: `Apply all (Recommended)` / `Skip all`, with "Other" for `apply except 2, 5`. In text mode, the user replies `apply`, `apply except 2`, or `skip`. **Only true polish belongs here** — wording, quantifying what the doc already implies, an obvious missing state. Anything a reasonable owner might answer differently is a question, however small it looks: limits and caps, schedules, who sees or gets what, anything that widens results or adds notifications, rollout cohorts, accessibility or performance targets, scope cuts. A user who replies `apply` hasn't really decided those. The test for each item: if the owner answered the opposite, would anything be built differently? Then it's a question.

**Stopping** — wrap up when nothing blocking or important is left unasked, when the user says stop, or when answers are mostly "park". If the user stops early, don't lose what's left: park the remaining blocking and important questions as open questions with your recommendation as the proposed default, and mention that polish is available on request. In the wrap-up, name exactly which defaults the user never saw — they're proposals, so never suggest building against them as if decided. Never stretch a session to look thorough.

## Phase 5: Write answers into the PRD

**Before the first write:** if the file is in git with uncommitted changes, say so (their diff will mix with yours). If it isn't under version control, save `<name>.pre-reshape.<ext>` beside it and mention it. Shared cloud docs need the user's go-ahead first — see `references/sources-and-formats.md`.

**One pass per round:** re-read the file once (someone may have edited it mid-session — merge, don't overwrite), then make one edit per section that changes, not one per line, and add the round's log entries in a single edit. Don't re-read the references each round. Building out a stub, or rebuilding a pasted doc, is the exception: write the new draft in one go — there's little author text to protect, but keep the original lines' meaning.

**Where answers go:** the section a reader would look in. Create a section only if none fits, in the doc's style, where its ordering implies. If the team's standard excludes a topic from PRDs, route it — an open question for the owning team, or their companion doc if the user agrees; content already in the PRD against the standard gets the same treatment (propose moving it, don't expand it). **Apply each answer everywhere it reaches:** if a rule covers the email digest, check whether the badge, the flow, and the checklist mention the same thing.

**How to write:**
- **Requirements, not transcripts** — "**Primary user:** recruiters. Hiring managers have read-only access.", never "Q: … A: …".
- **Match the doc** — headings, numbering, IDs, bullets versus prose, tone, terminology, language.
- **Keep the user's specifics exactly** — their numbers, names, and words. Tighten phrasing; never change meaning.
- **Make it testable** — a number, limit, or rule in the answer is written as one.
- **Edit surgically** — leave every untouched line byte-for-byte alone; keep numbering stable (leave a pointer where a moved item was).
- **Never delete the author's content silently** — if an answer supersedes a line, rewrite it and say so. If the feature is **already live**, mark superseded requirements with a dated note instead.
- **Confirm big implied changes** (removing a section, reversing a goal) before making them.
- **Label assumptions** — beliefs that could be wrong — with how or when to validate them. Decisions are plain requirements.
- **Label your inferences in the PRD itself** — anything the user didn't explicitly say (an implication of an answer, a reading you chose) gets a marker such as _(inferred — confirm)_, not just a mention in chat.

**Open questions** go in the doc's existing section, or a new one near the end, each with severity, owner, type (**decision**, **research**, or **direction**), and a proposed default:

```
- **[BLOCKING] Do enterprise workspaces need SSO for shared links in v1?** Blocks the sharing-flow design.
  Owner: Security · Type: decision · Proposed default: no SSO in v1; links require login.
```

Pre-existing questions that now have an answer are marked resolved in place, with the answer and where it lives. Questions raised and closed within the session don't appear.

**Decision log** — provenance, so a reviewer can tell an owner's decision from an accepted AI recommendation. Use the doc's existing changelog or decision log, in its format; otherwise add `## Decision log` at the end. Group by round or topic — a handful of lines per session — and tag each line's source honestly: _(answer)_, _(from <source>, confirmed)_, _(recommended default)_, _(delegated)_, _(parked by the user)_, or _(raised by reshape — not yet discussed)_.

```
### 2026-10-16 — reshape session
- §2, §6.3 — primary user is the recruiter; alerts are a daily digest, not instant. _(answers)_
- §6 FR-4 — includes direct applicants and sourced profiles. _(from brainstorm.md, Oct 8 — confirmed)_
- §10 — saved-search cap → Engineering. _(parked by the user)_
```

**Metadata** — bump "last updated" if present. Keep any provenance or authorship marker honest (gaps closed by the owner's answers mean it's no longer purely AI-drafted). Never change a status field on your own — propose it in the wrap-up.

## Phase 6: Wrap up

Before writing the summary, re-read the sections you changed, together, once — your own edits can contradict each other (a digest that shows a candidate once, a badge that counts them per search). Fix or flag what you find.

```
## Done — ready for design, with 2 open questions

**Changed:** §2 Users, §4 Scope (+ Out of scope), §5 Metrics, §6 FR-7–9, §7 Edge cases · added Open questions, Decision log
**Closed:** 11 gaps (8 answered, 2 from sources, 1 delegated) · **Open:** 2 (1 blocking)
**Review:** `git diff product/features/saved-searches/prd.md`

**For owners** — ready to paste:
- **Security:** Do enterprise workspaces need SSO for shared links in v1? It blocks the sharing-flow design. Proposed default: no SSO in v1.

Status says `draft` — set it to `ready-with-open-questions`?
Re-run this once the owners answer; it picks up from the open questions.
```

The verdict is **ready for <stage>**, **ready, with open questions** (only non-blocking — a perfectly good state), or **not ready** (blocking questions open — list them first). Be honest: an open blocking question means not ready. For a pasted PRD, also hand back the full revised text ready to paste.

## Modes

| The user says | Do this |
|---|---|
| "quick", "top issues", "I have 5 minutes" | One round of the ≤5 most blocking questions, write, wrap up. |
| "thorough", "everything", "sign-off ready" | Every important question, then the polish list. |
| "all the questions at once", "I'll answer later", "send to the team" | One numbered list grouped by severity, each with its recommendation; write nothing until answers arrive. Offer to add the list to the PRD's open questions. |
| "don't edit", "just review", "read-only" | Audit and ask in chat; change no files. Offer to apply everything at the end. |
| "for design" / "for eng" / "for QA" / "for launch" / "for exec review" | That stage defines "blocking"; weight the lenses as `references/gap-lenses.md` describes. |

## Edge cases

- **Stub or near-empty PRD** — say so, and offer to build it out through the same Q&A, foundations first (problem, users, outcome, scope, success, timing), in the team template if there is one. Never fill sections with invented content.
- **Already solid** — say so, raise only the real gaps (or none), stop.
- **Re-runs** — open with what's still open and what changed since the last session (git history helps). Re-audit only what changed; re-ask nothing decided unless new information contradicts it — then ask, and mark the old decision superseded. Update existing open questions in place instead of duplicating them or reusing their numbers; append a new dated log block.
- **The user isn't the owner** — let them park freely; the owner-grouped list becomes the main output. If the doc clearly belongs to someone else, ask once whether to edit it or work on a copy.
- **Several PRDs** — offer an audit table (doc · top blocking gaps · readiness), then reshape one at a time.
- **Very long PRDs** — audit all of it, ask which part matters most now; rounds stay at five decisions.
- **Language** — edit in the PRD's language; talk to the user in theirs.
- **Undo** — restore the earlier text (git, the backup, or your record) and log the reversal.

## Verify

```
[ ] Read the whole PRD, its siblings, linked docs, and the team's standard before asking anything
[ ] No question asked what the PRD, its sources, or the conversation already answered
[ ] Questions asked one per screen with the structured question tool (text rounds only when no such tool exists)
[ ] Every question anchored, one decision, says why it matters, has a recommendation (or says why not)
[ ] ≤5 decisions per round; blocking and upstream first; timing and the feature-type must-asks covered
[ ] Every contradiction asked about with both sides quoted — none resolved silently
[ ] Nothing reached the PRD that the user hadn't seen; the polish list held only true polish
[ ] Each answer applied everywhere it reaches; inferences labelled in the PRD; untouched lines unchanged; numbering stable
[ ] Changed sections re-read together before the wrap-up — no contradictions introduced
[ ] No author content deleted silently; live features marked superseded; excluded topics routed
[ ] Open questions carry severity, owner, type, proposed default; resolved ones point to their answer
[ ] Decision log grouped, each line's source tagged honestly
[ ] Backup if not version-controlled; shared docs edited only after a go-ahead; status never changed unasked
[ ] Early stop parked the remaining important questions; unseen defaults named; verdict honest; owners' asks ready to paste
```

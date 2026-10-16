# reshape

A Claude skill that **closes the gaps in a PRD by interviewing its owner**, then writes
every answer back into the PRD itself. No side document, no checklist dumped in chat:
the PRD comes out as something a designer or engineer can build from without guessing.

## What it does

1. **Reads everything first** — the whole PRD, the discussion notes and briefs next to it,
   linked docs, your team's template or CONTRIBUTING rules, and the file's git history.
   It never asks what those already answer; it lists those facts for you to confirm.
2. **Finds the gaps** — vague requirements, missing success metrics, fuzzy scope,
   unhandled edge cases, TBDs, and contradictions (within the doc, or between the doc and
   a newer decision in the notes). Each gap is rated blocking, important, or polish.
3. **Asks the critical questions one at a time** — in Claude Code, one per screen: pick
   an option with the arrow keys or type your own answer. Every question quotes the line
   it's about, says what goes wrong if it stays open, and leads with a recommended answer.
   Blocking questions come first; most PRDs close in two rounds.
4. **Writes the answers into the PRD** after each round, in the doc's own structure and
   voice. Untouched lines stay byte-for-byte the same, and every decision goes into a
   decision log tagged with where it came from (your answer, a source, or an accepted
   recommendation).
5. **Ends with an honest verdict** — "ready for design", "ready with open questions", or
   "not ready" — plus copy-paste questions for each owner. Anything you couldn't answer
   becomes an open question with an owner and a proposed default.

It works on Markdown files, pasted text, Word and PDF exports, and connected docs
(Google Docs, Notion, Confluence — it asks before editing a shared doc), and handles
stubs, re-runs after the PRD changed, reviewers who aren't the owner, and several PRDs.

## Install

### npx skills

```bash
npx skills add iamshubhransh/reshape
```

### One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/iamshubhransh/reshape/main/install.sh | bash
```

> Like to read before you pipe to `bash`? [Review `install.sh`](./install.sh) first,
> or clone the repo and run `./install.sh` locally.

### Claude Code plugin

```text
/plugin marketplace add iamshubhransh/reshape
/plugin install reshape@reshape
```

### claude.ai

Download `reshape.zip` from the [latest release](https://github.com/iamshubhransh/reshape/releases/latest),
then go to **Customize → Skills → Upload a skill**.

## Use it

```text
/reshape docs/checkout-prd.md
```

Or just ask: *"grill me on this PRD"*, *"what's missing from my spec?"*, *"is this ready
for eng?"*. Add `quick` for one round of blockers only, `for design` / `for eng` to change
what counts as blocking, or `don't edit` for a review without file changes. During a
session, type `park → Legal`, `n/a`, `you decide`, or `stop` into any question.

## Repo layout

```
install.sh                               # curl|bash installer
.claude-plugin/marketplace.json          # marketplace catalog
plugins/reshape/
├── .claude-plugin/plugin.json           # plugin manifest
└── skills/reshape/
    ├── SKILL.md                         # the workflow
    └── references/
        ├── gap-lenses.md                # what counts as a gap, by lens and feature type
        ├── sources-and-formats.md       # reading and safely writing back each source
        └── example-session.md           # a complete worked session
```

## License

MIT — see [LICENSE](./LICENSE).

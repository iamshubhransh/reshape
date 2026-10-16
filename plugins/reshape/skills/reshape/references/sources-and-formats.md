# Sources and formats

Read this when the PRD isn't a plain local text file, when it's spread across several files, or when you're unsure whether you can safely write to it.

**The rule underneath everything here:** edit the original only when you can do it *faithfully* (its formatting survives) and *safely* (the user expects the edit and nobody else is surprised by it). Otherwise, work on a copy and hand the result back in a form the user can apply. Say which you're doing in your first message, so there's no surprise at the end.

## Contents

1. Writing back, by source
2. Context sources
3. Scale

---

## 1. Writing back, by source

**Local Markdown or plain text** (`.md`, `.mdx`, `.txt`, `.rst`, `.adoc`, `.org`)
Edit in place, respecting the markup: don't break tables, front matter, footnotes, or admonition syntax. If the file is in git, the user reviews with `git diff`. If it isn't, save `<name>.pre-reshape.<ext>` beside it before the first write.

**A PRD split across several files** (chapters, appendices, a requirements table in its own file)
Audit them as one document. Write each answer into the file that owns the topic, and list every touched file in the wrap-up.

**Pasted into the chat**
There's no original to edit, but you still want a durable, diffable working copy. If you can write files, save the paste before the first round — propose a path (e.g. `./<feature>-prd.md`) in your first message and go ahead unless the user objects — and edit that. At the end, hand back the full revised text so they can paste it into wherever the PRD lives. If you can't write files, keep the working version in the conversation and output it in full once, at the end, not after every round.

**An uploaded attachment** (a chat attachment is a copy, not the original)
Read it. Deliver the revised PRD as a new file: in the same format if you can produce that format faithfully, otherwise as Markdown — and say which.

**Word (`.docx`)**
Extract the text (pandoc, python-docx, or a document tool or skill if one is available). If you have a tool that edits `.docx` while preserving formatting — ideally as **tracked changes**, which Word users can accept or reject one by one — use it. Otherwise work in a Markdown copy beside it (`<name>.reshaped.md`), say so at the start, and never overwrite the `.docx` with a lossy conversion.

**PDF, images, screenshots**
Read-only by nature. Extract or transcribe into a Markdown working copy. Flag anything you couldn't read with confidence — dense tables, small print, handwriting — instead of guessing at it.

**Google Docs, Notion, Confluence, Coda, SharePoint, Quip** (through a connector)
Read through whatever connector is available; if there isn't one, ask the user to export or paste the doc. Writing back is outward-facing: teammates see edits immediately and watchers may be notified. So before the first edit, ask once whether to:
- (a) edit the doc directly — mention that its version history can undo this;
- (b) add the changes as suggestions or comments, if the connector supports that;
- (c) keep a local working copy and hand back the revised sections to paste.
Never edit a shared doc without that go-ahead.

**Tickets used as PRDs** (Jira, Linear, GitHub or GitLab issues)
Same as shared docs: confirm before writing, since edits and comments notify people. Prefer one update to the description at the end over many small edits.

**Links you can't open** (Figma, a private doc, a dashboard, a recording)
Don't pretend to know what's inside. If it probably holds answers ("flows: see Figma"), ask the user for what you need from it. If it doesn't bear on a gap, skip it.

## 2. Context sources

**Discussion logs, meeting notes, chat exports**
They hold the why — and often decisions newer than the PRD. Read the most recent material first; search for decision language ("decided", "agreed", "we'll", "won't", "out of scope", "v1", "parked"); note who decided what, and when. A decision in a log that the PRD doesn't reflect is either a "from your sources" fill (when it's compatible with the PRD) or a contradiction question (when it isn't).

**The codebase**
Consult it for facts about current behavior — existing roles, limits, flows, error handling — instead of asking the user, and cite the file. Current code is not a requirement: when it differs from the PRD, ask which is intended.

**Team conventions**
Templates, checklists, README or CONTRIBUTING rules, glossaries, `CLAUDE.md` / `AGENTS.md`. They outrank the generic lenses. A glossary also settles terminology drift — use its canonical terms in your edits. If the conventions define statuses, provenance tags, or a changelog format, follow them exactly.

**The conversation itself**
If the user discussed the feature earlier in the session, those statements are sources too. Don't re-ask what they already told you; list it under "from your sources" and cite it as "earlier in this chat".

## 3. Scale

- **A very long PRD** — audit the whole thing, then ask which part matters most right now and work through it section by section. Keep rounds at five questions regardless of size.
- **Several PRDs** — start with an audit table (doc · top blocking gaps · readiness), then run one interview at a time in the user's order. Never interleave two PRDs' questions in one round.
- **Huge logs** — skim the structure first, read the decision-bearing passages, and prefer recent material. Don't let a 5,000-line chat export delay the first round; you can read more between rounds.

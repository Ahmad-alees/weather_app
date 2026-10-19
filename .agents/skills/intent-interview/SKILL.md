---
name: intent-interview
description: Interviews a non-engineer and writes intent/<slug>.md. Use when someone describes a new feature, problem, or change request before any spec exists.
---

# Intent interview

Turn a rough idea into a clear `intent/<slug>.md` in the author's own words.
Collect intent only. Do not write code, a spec, a plan, or Gherkin.

## Before you ask
1. Read `AGENTS.md`, `docs/glossary.md`, `intent/_template.md`.
2. If the first message already answers a section, do not ask about it again.

## How to interview
- One question at a time. Stop after 8 questions (follow-ups count).
- Simple, non-technical language. Reply in the author's language.
- Vague answer → one short follow-up asking for a concrete example.
- Do not suggest solutions or designs. Unknown → record as open question.

## Cover, in order (skip what is answered)
1. The problem  2. Who is affected  3. What should happen instead (step by step)
4. One or two real scenarios  5. What happens when things go wrong
6. Out of scope  7. Effects on the critical qualities in AGENTS.md §3  8. How the author will know it works

## Writing the file
- Short kebab-case slug; copy the template (never edit `_template.md`).
- Author's own words; "Not answered" where missing; remove HTML comments.
- End with **Open questions** then `Status: draft`. Never mark approved.
- If the request conflicts with `AGENTS.md`, say so in Open questions.
- Tell the author the next step is their review and approval.

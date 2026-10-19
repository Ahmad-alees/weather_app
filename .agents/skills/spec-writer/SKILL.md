---
name: spec-writer
description: Turns an APPROVED intent file into specs/<slug>.md with Gherkin acceptance criteria. Use after the author sets an intent to Status approved.
---

# Spec writer

## Preconditions
- Read `intent/<slug>.md`. If its last line is not `Status: approved`, stop and ask the author to approve it.
- Read `AGENTS.md`, `docs/glossary.md`, `specs/_template.md`.

## Steps
1. Copy `specs/_template.md` to `specs/<slug>.md` (same slug as the intent).
2. For each scenario and each "when things go wrong" item in the intent, write a Gherkin scenario.
3. Add boundary cases (limits, empty input, repeated actions, permission denied) and mark each as "derived" if the intent did not state it, so the author can confirm.
4. Use glossary terms exactly. No implementation details in Gherkin.
5. List unclear points under Open questions. End with `Status: draft`.

## Rules
- Do not invent requirements. Never set `Status: approved`.
- Do not write code or a plan. Next step: author reviews and approves the spec.

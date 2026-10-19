---
name: plan-writer
description: Turns an APPROVED spec into plans/<slug>.md, a short ordered implementation plan. Use after the author approves a spec and before any code is written.
---

# Plan writer

## Preconditions
- `specs/<slug>.md` must end with `Status: approved`; otherwise stop and ask.
- Read `AGENTS.md` (especially "Ask first" and §3 rules) and `plans/_template.md`.

## Steps
1. Inspect the existing code first; reuse existing utilities and patterns.
2. Copy the template to `plans/<slug>.md`.
3. Write small ordered steps, each with files touched and how it is verified.
4. Map every Gherkin scenario to at least one test or manual check.
5. List anything needing prior approval (dependency, schema, permissions, core engine change).
6. Flag risks to the critical qualities in AGENTS.md §3. End with `Status: draft`.

## Rules
- No code in this stage. Wait for the author's approval before implementing.

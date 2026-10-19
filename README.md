# Waether

A Flutter app that shows the weather for the region where the user lives.

> Status: structure only — no code yet. Follows the AI Project Kit (MIND AI Labs).

## Workflow (every feature)

`Intent → Spec → Plan → Implement → Test → Review`

- Only the human changes a status from `draft` to `approved`.
- No code without an approved spec and plan.
- Log meaningful decisions in `docs/AI_LOG.md`.

## Layout

```
AGENTS.md            single source of truth for agent rules
CLAUDE.md            one line: @AGENTS.md
.agents/skills/      intent-interview, spec-writer, plan-writer, review-checklist
docs/                PRD.md, glossary.md, AI_LOG.md
intent/ specs/ plans/  one file per feature (+ _template.md)
design/              screens / links
lib/  test/          Flutter code and tests
```

## Setup / run / test
To be filled after the Flutter project is created and commands are verified.

## Maintaining this kit
- Rules live in `AGENTS.md` only. Skills hold playbooks, not standing rules.
- Corrected the agent twice for the same mistake? Add a rule to `AGENTS.md` §11.

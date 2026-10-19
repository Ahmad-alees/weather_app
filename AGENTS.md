# AGENTS.md — Waether

> Standing instructions for every AI agent in this repository.
> Read fully before any task. Keep it short, current, and specific.

## 1. Project summary
- **One-line goal:** A Flutter app that shows the weather conditions for the region where the user lives.
- **Users:** Anyone who wants a better, lighter weather app that does the same job.
- **Problem solved:** Other weather apps are difficult and slow.
- **Nature:** Educational project (non-commercial). **Out of scope forever:** <ask>

## 2. Tech stack and platform
- **Language / framework:** Dart / Flutter
- **Platform(s):** Android only (do not add others)
- **Data / storage:** <undecided → ask>
- **Backend:** undecided → ask
- **Weather data source (API):** undecided → ask
- **Languages / localization / RTL:** Arabic (RTL) by default; English selectable in settings
- **Plugins / MCP connectors in use:** none

## 3. Non-negotiable rules
1. Weather data shown must be accurate and clearly tied to the user's region; never show stale data without saying so.
2. Location privacy: never log, upload, or store the user's precise location without explicit approval.
3. Never commit secrets (API keys); use git-ignored env files.
4. Ask before adding a dependency (name, why, alternative).
5. Never edit a status line in `intent/`, `specs/`, `plans/`. Only the human approves.
6. Never claim something works without having run it.

## 4. Scope reference (core features)
- See `intent/weather-by-region.md` (draft): current weather and details, 5-day forecast, weather-based background, device location only (no city management), settings: 3 unit options (+ language switch, to be confirmed)

## 5. Open decisions (do not assume — ask)
- Weather API provider
- Local storage / caching / backend

## 6. Workflow
`Intent → Spec → Plan → Implement → Test → Review`. Do not skip ahead.
1. **Intent** — `intent/<slug>.md` via the `intent-interview` skill.
2. **Spec** — `specs/<slug>.md` (Gherkin) via `spec-writer`, only from an *approved* intent.
3. **Plan** — `plans/<slug>.md` via `plan-writer`; wait for approval.
4. **Implement** — small steps, one concern at a time, on a branch.
5. **Test** — run tests, report real output.
6. **Review** — use `review-checklist`; summarize diff, risks, unverified items.

No approved intent/spec → propose the intent interview instead of writing code.

## 7. Autonomy levels (default L2)
| Level | Use for | Behavior |
|---|---|---|
| L1 Suggest | snippets, explanations | show in chat, touch no files |
| L2 Propose diff | small changes | show diff, wait for approval |
| L3 Execute on branch | features, refactors | plan → approve → edit → test → report |

## 8. Hard rules
**Always:** work on a branch; small focused commits; match existing conventions; add tests with every behavior change (regression test for every bug); verify every import/package exists; use the glossary terms; no hard-coded user-facing strings.
**Ask first:** new dependency; schema/migration change; permissions/manifest/build config (e.g. location permission); changing core engine behavior; anything uploaded off-device; deleting files or large renames; tasks touching more than ~5 files.
**Never:** push to `main` or force-push; commit secrets or real user data; build SQL by string concatenation; disable or weaken a test; invent APIs or packages; log sensitive user data.

## 9. Repository layout
```
AGENTS.md  CLAUDE.md  README.md
.agents/skills/<name>/SKILL.md
docs/ PRD.md glossary.md AI_LOG.md
intent/ specs/ plans/ design/
lib/  test/
```

## 10. Commands
```
flutter pub get      flutter run      flutter test      dart format . && flutter analyze
```
Not yet verified in this repo. Inspect the repo once the Flutter project exists, state what you inferred, and ask me to confirm.

## 11. Project-specific rules (add as you learn)
- Every time you correct the agent twice for the same mistake, add a rule here.

## 12. Communication
- Reply in Arabic by default (confirm with the human); code, identifiers, commits, file names in English.
- Structure substantial answers: Objective → Approach → Implementation → Verification → Next steps.
- After each task state: what changed, what was tested (and how), what could NOT be verified, risks.
- If unsure or blocked, stop and say so.

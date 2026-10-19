# AI Log

## 2026-10-17 — Set up project structure
- Goal: create the repo structure from the Coding with AI slides (AI Project Kit) for a Flutter weather app
- Prompt (summary): follow the structure in the slides, then start building a Flutter app showing weather for the user's region
- AI output (summary): scaffold of AGENTS.md, CLAUDE.md, README, skills, docs, templates; unknown fields left as open decisions
- Decision: pending human review
- Why: —
- Verification done: none (no code yet)

## 2026-10-17 — Platform decision
- Goal: resolve the first open decision in AGENTS.md §5
- Decision: Android only (chosen by the author)
- Verification done: none (no code yet)

## 2026-10-17 — Intent interview: weather-by-region
- Goal: capture the first feature's intent in the author's words
- Prompt (summary): one-question-at-a-time interview; author also shared 4 screenshots of a reference weather app
- AI output (summary): intent/weather-by-region.md, Status: draft; problem/users left "Not answered"
- Decision: pending author review and approval
- Why: only the human approves
- Verification done: none (no code yet)

## 2026-10-17 — Intent update: open questions answered
- Goal: resolve open questions in intent/weather-by-region.md
- Decision: problem, users, languages, units and four backgrounds added from the author's answers; language switch conflicts with "3 settings only" — flagged for confirmation
- Verification done: none (no code yet)

## 2026-10-17 — Intent update: scope change
- Goal: apply the author's latest answers to intent/weather-by-region.md
- Decision: add-cities feature cancelled (device location only); region = city; 4 more backgrounds (night, snow, fog, storm); refresh on every open; author name added; provider recommendation requested
- Verification done: none (no code yet)

## 2026-10-17 — Provider recommendation
- Goal: recommend a weather data provider (author asked Claude to choose)
- AI output (summary): recommended Open-Meteo (no API key, 16-day forecast, free for non-commercial use); alternatives WeatherAPI (3-day free forecast) and OpenWeatherMap (key, 1,000 calls/day)
- Decision: pending — author confirmed the project is educational (non-commercial); final provider decision at plan stage
- Verification done: none (field availability to be verified at plan stage)
- Decision: language confirmed as a 4th setting (author)
- Decision: failure behavior changed to old data + message that data is old (author); implies saving last data on the device
- Decision: 'cannot determine' message only when no saved data; otherwise old data + 'data is old' message (author)
- Decision: Update button under the 'data is old' message; night + rain = night background with rain effect (author)
- Decision: last-update time shown; night combinations work like night+rain; unlisted conditions get an expressive background (author). Only the provider question remains open in the intent

## 2026-10-17 — Spec: weather-by-region
- Goal: write specs/weather-by-region.md from the approved intent
- Decision: intent approved by the author in chat (status line recorded as approved); spec written as draft; derived scenarios marked for the author to confirm
- Verification done: none (no code yet)

## 2026-10-17 — Spec approved, plan written
- Goal: write plans/weather-by-region.md from the approved spec
- Decision: spec approved by the author in chat (status line recorded); plan written as draft; provider (Open-Meteo), dependencies, permissions and the city-name privacy question wait for the author
- Verification done: provider fields checked in public documentation only; nothing run
- Decision: city name via Android built-in geocoder (geocoding package), author accepts it may contact Google; intent/spec privacy wording amendment proposed, awaiting author approval
- Decision: author approved the geocoder privacy wording (intent + spec amended), the 5 packages, permissions, Open-Meteo; generic label when city name unavailable. Plan stays draft until the author approves it

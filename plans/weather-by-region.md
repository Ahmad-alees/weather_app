# Plan: Weather by region

- **Slug:** weather-by-region
- **Source spec:** specs/weather-by-region.md

## Decisions this plan relies on
- **Platform:** Android only (AGENTS.md §2).
- **Weather data provider (approved by the author):** Open-Meteo, free for non-commercial use, no API key. Checked in public documentation: current temperature, humidity, feels-like temperature, weather code, pressure, wind speed and direction, and the day/night flag; hourly UV index and chance of rain; daily low/high, weather code, sunrise and sunset. Air quality comes from a separate Open-Meteo air-quality service (seen in search results, not yet tested).
- **State management:** Flutter built-ins only (`ChangeNotifier` / `ValueNotifier`), to keep the app light and avoid an extra dependency.
- **Night:** taken from the provider's day/night flag for the device's region (the author chose "actual local time").
- **Not yet verified:** nothing has been run. Flutter and the real API responses are checked in the implementation steps.

## Steps (small, ordered, each verifiable)
1. Create the Flutter project, Android only — files: `pubspec.yaml`, `android/`, `lib/main.dart`, `analysis_options.yaml` — verified by: `flutter analyze` and `flutter test` (empty test passes).
2. Weather condition model and mapping from provider weather code + day/night flag to one of: sunny, cloudy, partly cloudy, rainy, snow, fog, storm, night, night + effect, other — files: `lib/domain/weather_condition.dart`, `test/weather_condition_test.dart` — verified by: unit tests for every row of the background tables, the four night combinations, and an unlisted code.
3. Unit conversion (C/F, km/h/mph, mbar/mmHg) — files: `lib/domain/units.dart`, `test/units_test.dart` — verified by: unit tests including zero and negative temperatures.
4. Settings storage (three units + language), Arabic default — files: `lib/data/settings_store.dart`, `test/settings_store_test.dart` — verified by: tests for defaults and for values kept after a simulated restart.
5. Localization Arabic (RTL) + English, all user-facing strings in resource files, including the two messages — files: `lib/l10n/*.arb`, `l10n.yaml` — verified by: widget test that the language switch changes text and direction.
6. Weather API client and parser (forecast + air quality) — files: `lib/data/weather_api.dart`, `lib/data/models.dart`, `test/weather_api_test.dart`, `test/fixtures/*.json` (made-up sample data) — verified by: parsing tests, including a response with a missing detail.
7. Location service (permission, one-time location) and the region name from Android's built-in geocoder, with a generic label when no name is found (author's decisions) — files: `lib/data/location_service.dart`, `lib/data/region_name_resolver.dart` — verified by: tests with fake location and name sources; manual check on a device, including a device without the geocoder service (no name available → see risks).
8. Cache of the last weather and the time of the last update, on the device only — files: `lib/data/weather_cache.dart`, `test/weather_cache_test.dart` — verified by: save/load tests and an empty-cache test.
9. Weather repository and screen state: refresh on every open; success, old data, no data — files: `lib/domain/weather_repository.dart`, `lib/ui/weather_controller.dart`, `test/weather_repository_test.dart` — verified by: tests for each failure scenario in the spec (internet off, location off, permission denied, update fails again, update succeeds, region changed).
10. Main screen: region name, temperature, condition with low/high, air quality, 5-day forecast, details, last update time — files: `lib/ui/home_screen.dart`, `lib/ui/widgets/*` — verified by: widget tests for the scenarios; a missing detail shows as unavailable.
11. Backgrounds drawn in code (gradients and simple animated effects, no image assets), including night + rain/snow/fog/storm and a fallback for unlisted conditions — files: `lib/ui/backgrounds/*` — verified by: widget tests per condition; manual look on a device.
12. Failure UI: old data + "data is old" message + Update button; no-data message — files: `lib/ui/widgets/stale_banner.dart`, `lib/ui/widgets/no_data_view.dart` — verified by: widget tests.
13. Settings screen with exactly four options — files: `lib/ui/settings_screen.dart` — verified by: widget test that no other option exists.
14. Android permissions (internet, approximate location) — files: `android/app/src/main/AndroidManifest.xml` — verified by: manifest inspection and a manual permission flow on a device. **Needs approval.**
15. Manual verification list for the author: compare temperature and condition with another weather app; internet off; location off; language and units.

## Files to touch
- New project: `pubspec.yaml`, `analysis_options.yaml`, `l10n.yaml`, `android/` (manifest only), `lib/` (domain, data, ui, l10n), `test/`.
- Docs: `README.md` and `AGENTS.md` §10 (commands, after they are verified), `docs/AI_LOG.md`.

## Risks (esp. AGENTS.md §3 rules)
- **Accuracy (rule 1):** two weather apps often use different data sources, so values can differ by a degree or two. Success check 4 ("matches another app") may need a tolerance. The author should decide what difference is acceptable.
- **Freshness (rule 1):** the free Open-Meteo plan updates hourly, so a value may lag slightly. The last-update time on screen shows what the user sees.
- **Location privacy (rule 2):** the weather request must contain the coordinates, which the intent allows ("the request needed to fetch weather data"). The built-in geocoder may send the location to Google on many devices; the author accepted this, and the intent wording needs the amendment above.
- **City name unavailable:** on a device without the geocoder service, or offline, no city name may come back. Decided by the author: a generic label is shown (added to the spec as a derived scenario).
- **Secrets (rule 3):** none needed for Open-Meteo.
- **Lightness (author's goal):** avoid image assets and heavy packages; measure app size and start time at review.
- **Unverified API details:** air-quality fields and the exact day/night behavior are checked in step 6 against real responses.

## Needs approval first (AGENTS.md "Ask first") — approved by the author on 2026-10-17
- **Dependencies** (name — why — alternative):
  - `geolocator` — device location — alternative: write platform code (more work, more risk).
  - `http` — network requests — alternative: `dart:io` HttpClient (no dependency, more code).
  - `shared_preferences` — settings and cached weather — alternative: write a JSON file with `dart:io`.
  - `flutter_localizations` + `intl` — Arabic/English, RTL, number and date formats — no good alternative.
  - `geocoding` — city name from coordinates through Android's built-in geocoder (author's decision) — alternative: a name-lookup web service (sends the location to a third party).
- **Permissions / manifest:** `INTERNET` and approximate location (`ACCESS_COARSE_LOCATION`).
- **Weather data provider:** Open-Meteo.
- **City name from coordinates:** decided by the author: Android's built-in geocoder through the `geocoding` package.
- **Intent wording amendment (approved and applied to the intent and the spec):** the intent and the privacy scenario in the spec say nothing about the user is sent out except the request needed to fetch the weather data. The built-in geocoder may contact Google on many devices. Proposed addition to the intent and the spec: "The city name is obtained through Android's built-in geocoder, which may contact a Google service on some devices."

## Test plan
- Unit: condition mapping, unit conversion, parsing, cache, settings, repository states.
- Widget/integration: main screen, backgrounds per condition, failure UI, settings screen, language switch and RTL.
- Manual: on an Android device — permission flow, internet off, location off, comparison with another app, a look at every background.
- Scenario coverage: each Gherkin scenario in `specs/weather-by-region.md` maps to at least one test above or to a manual check (comparison with another app, backgrounds, permission flow).

Status:approved

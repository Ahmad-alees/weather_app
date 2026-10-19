# Intent: Weather by region

- **Slug:** weather-by-region
- **Date:** 2026-10-17
- **Author:** Ahmad Sohail

## 1. The problem
Other weather apps are difficult and slow. The author wants to build a weather app (Flutter) that shows the weather conditions for the region where the user lives.

## 2. Who is affected
Anyone who wants a better, lighter app that does the same job.

## 3. What should happen instead
- The app shows the temperature, the weather condition, the wind, and more details, in the style of the reference screenshots (an existing Arabic weather app).
- Main screen in the reference: city name, current temperature, weather condition with low/high, air quality, and a 5-day forecast.
- Details in the reference: humidity, feels-like temperature, UV index, pressure, chance of rain, wind direction and speed, sunrise and sunset.
- The background changes according to the weather condition.
- The app shows the weather only for the city the user is in, determined from the device location. Region means the city. There is no adding of other cities.
- Every time the app is opened, the weather is updated immediately.
- The screen shows the time of the last update.
- The settings screen has four options: three unit options and the language:
  - Temperature: C or F.
  - Wind speed: km/h or mph.
  - Pressure: mbar or mmHg.
  - Language: Arabic (default) or English.
- Backgrounds by weather condition:
  - Sunny: a bright background.
  - Cloudy: clouds.
  - Rainy: rain.
  - Partly cloudy: clouds with sunlight breaking through.
  - Night: a night background with a crescent moon.
  - Snow: falling snow.
  - Fog: a foggy background.
  - Storm: a strong-wind background.
  - Night with rain: the night background with a rain effect. Night with snow, fog, or storm works the same way: the night background with that condition's effect.
  - Any other weather condition: a background that expresses that condition.

## 4. Example scenarios
1. The user opens the app and sees the correct temperature for their city.
2. The weather condition changes and the background changes with it.
3. The author compares the app's results with another weather app to check that the information is correct.

## 5. When things go wrong
- If the weather cannot be fetched (no internet or location services off), the old saved data is still shown, together with a message that the data is old and the user should update it. Under the message there is an Update button.
- If there is no saved data at all (e.g. first launch), the user sees a message saying the weather in their city cannot be determined and asking them to enable location services or the internet.

## 6. What this is NOT
For now, no: adding or managing other cities, notifications, ads, maps, login, home-screen widget. In settings, no: automatic night update, sound effects, comments (only the four options above).

## 7. Effects on the rest of the product
- **Accuracy:** results will be compared with another weather app to verify them.
- **Localization / RTL:** Arabic by default (the reference screenshots are in Arabic), switchable to English in settings.
- **Data and sync:** The last fetched weather is kept on the device so it can be shown when refresh fails. The device location is not stored anywhere except on the device. Nothing about the user is sent out except the request needed to fetch weather data. The city name is obtained through Android's built-in geocoder, which may contact a Google service on some devices (accepted by the author, 2026-10-17). If the city name cannot be found, a generic label is shown instead of the name (author).
- **Safety / wording:** Not answered.

## 8. How we will know it works
1. The correct temperature for the user's city appears when the app opens.
2. The background changes with the weather condition.
3. When the internet is turned off, the old data appears together with the message that it is old.
4. The results match another weather app.

## Open questions
- Which weather data provider, and does it supply every detail in the reference (e.g. air quality, UV index, chance of rain)? The author asked Claude to recommend the best one (decided at the plan stage, AGENTS.md §5).

Status: approved

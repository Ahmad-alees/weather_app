# Spec: Weather by region

- **Slug:** weather-by-region
- **Source intent:** intent/weather-by-region.md
- **Date:** 2026-10-17

Scenarios marked **(derived)** were not stated in the intent; the author confirmed them when approving this spec.

## Acceptance criteria (Gherkin)

```gherkin
Feature: Weather by region

  Background:
    Given the app is installed on an Android device

  # ---------- Main screen ----------

  Scenario: Open the app with location and internet available
    Given location services are on
    And the internet is on
    When the user opens the app
    Then the weather is updated immediately
    And the screen shows the region name
    And the screen shows the current temperature
    And the screen shows the weather condition with the low and the high
    And the screen shows the air quality
    And the screen shows a 5-day forecast
    And the screen shows humidity, feels-like temperature, UV index, pressure, chance of rain, wind direction and speed, sunrise and sunset
    And the screen shows the time of the last update

  Scenario: The region is the city where the user is
    Given location services are on
    When the user opens the app
    Then the screen shows the weather only for the region where the device is located

  Scenario: Every open refreshes the weather
    Given the app was opened earlier and the weather has since changed
    When the user opens the app again
    Then the weather is updated immediately
    And the screen shows the new condition and the new time of the last update

  Scenario: The values match another weather app
    Given the author opens another weather app for the same region
    When the author compares the two apps
    Then the temperature and the weather condition match

  # ---------- Backgrounds ----------

  Scenario Outline: Background follows the weather condition
    Given the weather condition is "<condition>"
    When the weather is shown
    Then the background is "<background>"

    Examples:
      | condition     | background                                  |
      | sunny         | a bright background                         |
      | cloudy        | clouds                                      |
      | partly cloudy | clouds with sunlight breaking through       |
      | rainy         | rain                                        |
      | snow          | falling snow                                |
      | fog           | a foggy background                          |
      | storm         | a strong-wind background                    |
      | night         | a night background with a crescent moon     |

  Scenario Outline: Night combined with another condition
    Given it is night
    And the weather condition is "<condition>"
    When the weather is shown
    Then the background is the night background with the "<effect>" effect

    Examples:
      | condition | effect         |
      | rain      | rain           |
      | snow      | falling snow   |
      | fog       | fog            |
      | storm     | strong wind    |

  Scenario: A condition that is not listed
    Given the weather condition is not one of the listed conditions
    When the weather is shown
    Then the background expresses that condition

  Scenario: Background changes when the condition changes
    Given the screen shows a background for one condition
    When the weather is updated and the condition changes
    Then the background changes to the one for the new condition

  # ---------- When things go wrong ----------

  Scenario: Refresh fails and old saved data exists
    Given the app has saved weather data from an earlier open
    And the internet is off
    When the user opens the app
    Then the screen shows the old saved data
    And the screen shows a message that the data is old and the user should update it
    And an Update button appears under the message

  Scenario: Refresh fails because location services are off and old saved data exists
    Given the app has saved weather data from an earlier open
    And location services are off
    When the user opens the app
    Then the screen shows the old saved data
    And the screen shows a message that the data is old and the user should update it
    And an Update button appears under the message

  Scenario: No saved data at all
    Given the app has no saved weather data
    And the weather cannot be fetched
    When the user opens the app
    Then the screen shows a message that the weather in the user's city cannot be determined
    And the message asks the user to enable location services or the internet

  Scenario: Update succeeds
    Given the screen shows the old-data message and the Update button
    And the internet and location services are now on
    When the user presses Update
    Then the weather is updated
    And the old-data message disappears
    And the time of the last update changes

  Scenario: Update fails again (derived)
    Given the screen shows the old-data message and the Update button
    And the weather still cannot be fetched
    When the user presses Update
    Then the old saved data and the old-data message stay on the screen

  # ---------- Settings ----------

  Scenario: The settings screen has only four options
    When the user opens the settings screen
    Then the screen shows temperature units, wind speed units, pressure units and language
    And the screen shows no other option

  Scenario Outline: Choose a unit
    Given the screen shows weather values
    When the user sets "<setting>" to "<unit>"
    Then the weather values for "<setting>" are shown in "<unit>"

    Examples:
      | setting        | unit |
      | temperature    | C    |
      | temperature    | F    |
      | wind speed     | km/h |
      | wind speed     | mph  |
      | pressure       | mbar |
      | pressure       | mmHg |

  Scenario: Language is Arabic by default
    Given the app is opened for the first time
    Then the interface is in Arabic

  Scenario: Switch the language to English
    Given the interface is in Arabic
    When the user sets the language to English in the settings
    Then the interface is in English

  Scenario: Chosen settings are kept after restart (derived)
    Given the user chose units and a language
    When the user closes and reopens the app
    Then the chosen units and language are still applied

  # ---------- Privacy ----------

  Scenario: Nothing about the user leaves the device except the weather request
    Given the weather is being updated
    When the app contacts the weather data provider
    Then nothing about the user is sent out except the request needed to fetch the weather data
    And the city name is obtained through Android's built-in geocoder, which may contact a Google service on some devices
    And the device location is not stored anywhere except on the device

  # ---------- Not included ----------

  Scenario: Features that are not part of the app
    When the user looks through the whole app
    Then there is no way to add or manage other cities
    And there are no notifications, ads, maps, login or home-screen widget
    And the settings have no automatic night update, sound effects or comments

  # ---------- Boundary cases (derived) ----------

  Scenario: Location permission denied and old saved data exists (derived)
    Given the user denied the location permission
    And the app has saved weather data
    When the user opens the app
    Then the screen shows the old saved data with the old-data message and the Update button

  Scenario: Location permission denied and no saved data (derived)
    Given the user denied the location permission
    And the app has no saved weather data
    When the user opens the app
    Then the screen shows the message that the weather in the user's city cannot be determined
    And the message asks the user to enable location services or the internet

  Scenario: One detail is not available from the data (derived)
    Given the weather data has no value for one detail, such as air quality
    When the weather is shown
    Then the rest of the screen is shown normally
    And the missing detail is shown as unavailable instead of a wrong value

  Scenario: The city name cannot be found (derived)
    Given the weather data was fetched
    And the city name cannot be obtained
    When the weather is shown
    Then a generic label is shown instead of the region name
    And the rest of the screen is shown normally

  Scenario: The user moves to another city (derived)
    Given the app showed the weather for one region
    And the device is now in another city
    When the user opens the app
    Then the screen shows the weather for the new region
```

## Edge cases covered
- Failure with old saved data, and failure with none (stated in the intent).
- Location off, location permission denied, internet off.
- Repeated Update presses while still offline (derived).
- Settings kept after restart (derived).
- A missing detail in the data (derived).
- The user moving to another city (derived).
- The city name cannot be found: a generic label is shown (author).

## Out of scope
- Adding or managing other cities, notifications, ads, maps, login, home-screen widget.
- Settings other than temperature units, wind speed units, pressure units and language.

## Open questions
- Weather data provider: decided in the plan (AGENTS.md §5). The spec assumes it supplies air quality, UV index and chance of rain.
- Resolved: "night" follows the actual local time of the region (author).
- Resolved: the wording of the two messages was agreed by the author; the plan will use Arabic and English versions.

Status: approved

/// A visual weather category supported by the app's background system.
enum WeatherCondition {
  sunny,
  partlyCloudy,
  cloudy,
  rainy,
  snow,
  fog,
  storm,
  night,
  nightRain,
  nightSnow,
  nightFog,
  nightStorm,
  other,
}

/// Maps Open-Meteo weather codes to the visual categories in the design.
///
/// The mapping follows the WMO interpretation table used by Open-Meteo. At
/// night, clear and cloudy conditions use the dedicated night background;
/// precipitation and storms retain their weather effect over that background.
WeatherCondition weatherConditionFromOpenMeteo({
  required int weatherCode,
  required bool isDay,
}) {
  final baseCondition = switch (weatherCode) {
    0 => WeatherCondition.sunny,
    1 || 2 => WeatherCondition.partlyCloudy,
    3 => WeatherCondition.cloudy,
    45 || 48 => WeatherCondition.fog,
    51 ||
    53 ||
    55 ||
    56 ||
    57 ||
    61 ||
    63 ||
    65 ||
    66 ||
    67 ||
    80 ||
    81 ||
    82 => WeatherCondition.rainy,
    71 || 73 || 75 || 77 || 85 || 86 => WeatherCondition.snow,
    95 || 96 || 99 => WeatherCondition.storm,
    _ => WeatherCondition.other,
  };

  if (isDay) {
    return baseCondition;
  }

  return switch (baseCondition) {
    WeatherCondition.rainy => WeatherCondition.nightRain,
    WeatherCondition.snow => WeatherCondition.nightSnow,
    WeatherCondition.fog => WeatherCondition.nightFog,
    WeatherCondition.storm => WeatherCondition.nightStorm,
    WeatherCondition.other => WeatherCondition.other,
    _ => WeatherCondition.night,
  };
}

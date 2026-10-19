import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/weather_condition.dart';

void main() {
  group('weatherConditionFromOpenMeteo', () {
    test('maps every supported daytime condition', () {
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 0, isDay: true),
        WeatherCondition.sunny,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 2, isDay: true),
        WeatherCondition.partlyCloudy,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 3, isDay: true),
        WeatherCondition.cloudy,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 61, isDay: true),
        WeatherCondition.rainy,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 73, isDay: true),
        WeatherCondition.snow,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 45, isDay: true),
        WeatherCondition.fog,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 95, isDay: true),
        WeatherCondition.storm,
      );
    });

    test('maps night combinations to their dedicated backgrounds', () {
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 0, isDay: false),
        WeatherCondition.night,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 61, isDay: false),
        WeatherCondition.nightRain,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 73, isDay: false),
        WeatherCondition.nightSnow,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 45, isDay: false),
        WeatherCondition.nightFog,
      );
      expect(
        weatherConditionFromOpenMeteo(weatherCode: 95, isDay: false),
        WeatherCondition.nightStorm,
      );
    });

    test('uses the fallback category for an unlisted code', () {
      expect(
        weatherConditionFromOpenMeteo(weatherCode: -1, isDay: true),
        WeatherCondition.other,
      );
    });
  });
}

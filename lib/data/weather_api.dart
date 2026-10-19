import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/data/location_service.dart';
import 'package:weather_app/domain/weather_data.dart';

class WeatherApi {
  WeatherApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<WeatherData> fetch({
    required DeviceLocation location,
    required String regionName,
  }) async {
    final forecastUri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${location.latitude}',
      'longitude': '${location.longitude}',
      'current': 'temperature_2m,apparent_temperature,relative_humidity_2m,surface_pressure,wind_speed_10m,wind_direction_10m,weather_code,is_day',
      'hourly': 'uv_index,precipitation_probability',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset',
      'forecast_days': '5',
      'timezone': 'auto',
    });
    final airUri = Uri.https(
      'air-quality-api.open-meteo.com',
      '/v1/air-quality',
      {
        'latitude': '${location.latitude}',
        'longitude': '${location.longitude}',
        'hourly': 'us_aqi',
        'timezone': 'auto',
      },
    );

    final responses = await Future.wait([
      _client.get(forecastUri),
      _client.get(airUri),
    ]);
    if (responses.first.statusCode != 200) {
      throw const WeatherRequestException();
    }

    final forecastJson =
        jsonDecode(responses.first.body) as Map<String, dynamic>;
    final airJson = responses.last.statusCode == 200
        ? jsonDecode(responses.last.body) as Map<String, dynamic>
        : <String, dynamic>{};
    final current = forecastJson['current'] as Map<String, dynamic>;
    final hourly = forecastJson['hourly'] as Map<String, dynamic>;
    final currentTime = DateTime.parse(current['time'] as String);
    final hourlyIndex = _closestTimeIndex(
      hourly['time'] as List<dynamic>,
      currentTime,
    );
    final daily = forecastJson['daily'] as Map<String, dynamic>;

    return WeatherData(
      regionName: regionName,
      fetchedAt: DateTime.now(),
      temperature: _number(current['temperature_2m']),
      apparentTemperature: _number(current['apparent_temperature']),
      weatherCode: current['weather_code'] as int,
      isDay: current['is_day'] == 1,
      humidity: _nullableInt(current['relative_humidity_2m']),
      pressure: _nullableNumber(current['surface_pressure']),
      windSpeed: _nullableNumber(current['wind_speed_10m']),
      windDirection: _nullableNumber(current['wind_direction_10m']),
      uvIndex: _nullableNumberAt(
        hourly['uv_index'] as List<dynamic>,
        hourlyIndex,
      ),
      rainChance: _nullableIntAt(
        hourly['precipitation_probability'] as List<dynamic>,
        hourlyIndex,
      ),
      airQualityIndex: _airQualityAt(airJson, currentTime),
      forecast: List<ForecastDay>.generate(
        5,
        (index) => ForecastDay(
          date: DateTime.parse(
            (daily['time'] as List<dynamic>)[index] as String,
          ),
          weatherCode: (daily['weather_code'] as List<dynamic>)[index] as int,
          low: _number((daily['temperature_2m_min'] as List<dynamic>)[index]),
          high: _number((daily['temperature_2m_max'] as List<dynamic>)[index]),
          sunrise: DateTime.parse(
            (daily['sunrise'] as List<dynamic>)[index] as String,
          ),
          sunset: DateTime.parse(
            (daily['sunset'] as List<dynamic>)[index] as String,
          ),
        ),
      ),
    );
  }

  int _closestTimeIndex(List<dynamic> values, DateTime target) {
    for (var index = 0; index < values.length; index++) {
      if (!DateTime.parse(values[index] as String).isBefore(target))
        return index;
    }
    return values.length - 1;
  }

  int? _airQualityAt(Map<String, dynamic> json, DateTime target) {
    final hourly = json['hourly'];
    if (hourly is! Map<String, dynamic>) return null;
    final values = hourly['us_aqi'];
    final times = hourly['time'];
    if (values is! List<dynamic> || times is! List<dynamic> || values.isEmpty)
      return null;
    return _nullableIntAt(values, _closestTimeIndex(times, target));
  }

  double _number(Object? value) => (value as num).toDouble();
  double? _nullableNumber(Object? value) => (value as num?)?.toDouble();
  double? _nullableNumberAt(List<dynamic> values, int index) =>
      _nullableNumber(values[index]);
  int? _nullableInt(Object? value) => (value as num?)?.round();
  int? _nullableIntAt(List<dynamic> values, int index) =>
      _nullableInt(values[index]);
}

class WeatherRequestException implements Exception {
  const WeatherRequestException();
}

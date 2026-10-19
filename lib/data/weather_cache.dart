import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/weather_data.dart';

class WeatherCache {
  WeatherCache() : _preferences = SharedPreferencesAsync();

  static const _key = 'cached_weather';
  final SharedPreferencesAsync _preferences;

  Future<WeatherData?> load() async {
    final raw = await _preferences.getString(_key);
    if (raw == null) return null;
    return WeatherData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(WeatherData data) =>
      _preferences.setString(_key, jsonEncode(data.toJson()));
}

import 'package:flutter/material.dart';
import 'package:weather_app/data/settings_store.dart';
import 'package:weather_app/data/weather_repository.dart';
import 'package:weather_app/domain/units.dart';
import 'package:weather_app/domain/weather_data.dart';

class WeatherController extends ChangeNotifier {
  WeatherController({
    SettingsStore? settingsStore,
    WeatherRepository? repository,
  }) : _settingsStore = settingsStore ?? SettingsStore(),
       _repository = repository ?? WeatherRepository();
  final SettingsStore _settingsStore;
  final WeatherRepository _repository;
  AppSettings _settings = const AppSettings();
  WeatherData? _weather;
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isStale = false;
  AppSettings get settings => _settings;
  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isStale => _isStale;
  Locale get locale => Locale(_settings.languageCode);
  Future<void> initialize({required String genericRegionName}) async {
    _settings = await _settingsStore.load();
    _weather = await _repository.cachedWeather();
    _isStale = _weather != null;
    _isLoading = false;
    notifyListeners();
    await refresh(genericRegionName: genericRegionName);
  }

  Future<void> refresh({required String genericRegionName}) async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    try {
      _weather = await _repository.refresh(
        genericRegionName: genericRegionName,
      );
      _isStale = false;
    } catch (_) {
      _isStale = _weather != null;
    } finally {
      _isRefreshing = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(AppSettings value) async {
    _settings = value;
    notifyListeners();
    await _settingsStore.save(value);
  }

  Future<void> setTemperatureUnit(TemperatureUnit value) =>
      updateSettings(_settings.copyWith(temperatureUnit: value));
  Future<void> setWindUnit(WindSpeedUnit value) =>
      updateSettings(_settings.copyWith(windSpeedUnit: value));
  Future<void> setPressureUnit(PressureUnit value) =>
      updateSettings(_settings.copyWith(pressureUnit: value));
  Future<void> setLanguage(String value) =>
      updateSettings(_settings.copyWith(languageCode: value));
}

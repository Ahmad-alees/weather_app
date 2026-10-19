import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/units.dart';

class AppSettings {
  const AppSettings({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.kilometersPerHour,
    this.pressureUnit = PressureUnit.millibar,
    this.languageCode = 'ar',
  });

  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;
  final PressureUnit pressureUnit;
  final String languageCode;

  AppSettings copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit,
    String? languageCode,
  }) => AppSettings(
    temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
    pressureUnit: pressureUnit ?? this.pressureUnit,
    languageCode: languageCode ?? this.languageCode,
  );
}

class SettingsStore {
  SettingsStore() : _preferences = SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;
  static const _temperatureKey = 'temperature_unit';
  static const _windKey = 'wind_unit';
  static const _pressureKey = 'pressure_unit';
  static const _languageKey = 'language';

  Future<AppSettings> load() async => AppSettings(
    temperatureUnit: TemperatureUnit.values.byName(
      await _preferences.getString(_temperatureKey) ??
          TemperatureUnit.celsius.name,
    ),
    windSpeedUnit: WindSpeedUnit.values.byName(
      await _preferences.getString(_windKey) ??
          WindSpeedUnit.kilometersPerHour.name,
    ),
    pressureUnit: PressureUnit.values.byName(
      await _preferences.getString(_pressureKey) ?? PressureUnit.millibar.name,
    ),
    languageCode: await _preferences.getString(_languageKey) ?? 'ar',
  );

  Future<void> save(AppSettings settings) async {
    await _preferences.setString(
      _temperatureKey,
      settings.temperatureUnit.name,
    );
    await _preferences.setString(_windKey, settings.windSpeedUnit.name);
    await _preferences.setString(_pressureKey, settings.pressureUnit.name);
    await _preferences.setString(_languageKey, settings.languageCode);
  }
}

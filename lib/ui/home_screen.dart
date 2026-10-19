import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/settings_store.dart';
import 'package:weather_app/domain/units.dart';
import 'package:weather_app/domain/weather_condition.dart';
import 'package:weather_app/domain/weather_data.dart';
import 'package:weather_app/l10n/app_strings.dart';
import 'package:weather_app/ui/settings_screen.dart';
import 'package:weather_app/ui/weather_background.dart';
import 'package:weather_app/ui/weather_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.controller, super.key});
  final WeatherController controller;
  @override
  Widget build(BuildContext context) {
    final text = AppStrings(controller.locale);
    final weather = controller.weather;
    final condition = weather == null
        ? WeatherCondition.other
        : weatherConditionFromOpenMeteo(
            weatherCode: weather.weatherCode,
            isDay: weather.isDay,
          );
    return Directionality(
      textDirection: text.textDirection,
      child: WeatherBackground(
        condition: condition,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: weather == null
                ? _NoData(text: text, controller: controller)
                : _DataView(
                    text: text,
                    weather: weather,
                    controller: controller,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DataView extends StatelessWidget {
  const _DataView({
    required this.text,
    required this.weather,
    required this.controller,
  });
  final AppStrings text;
  final WeatherData weather;
  final WeatherController controller;
  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => controller.refresh(genericRegionName: text.genericRegion),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather.regionName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${text.lastUpdated} · ${DateFormat.Hm(controller.locale.languageCode).format(weather.fetchedAt)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: text.settings,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WeatherBackground(
                    condition: WeatherCondition.cloudy,
                    child: SettingsScreen(controller: controller),
                  ),
                ),
              ),
              icon: const Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
        if (controller.isRefreshing)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
        if (controller.isStale)
          _StaleBanner(text: text, controller: controller),
        const SizedBox(height: 18),
        Center(
          child: Column(
            children: [
              Text(
                _temperature(
                  weather.temperature,
                  controller.settings.temperatureUnit,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 96,
                  fontWeight: FontWeight.w300,
                  height: .95,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                text.condition(weather.weatherCode),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                '${_temperature(weather.forecast.first.low, controller.settings.temperatureUnit)} / ${_temperature(weather.forecast.first.high, controller.settings.temperatureUnit)}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Align(
          alignment: Alignment.center,
          child: _Pill(
            label:
                '${text.airQuality} ${weather.airQualityIndex ?? text.unavailable}',
          ),
        ),
        const SizedBox(height: 16),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text.forecast,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 8),
              ...weather.forecast.map(
                (day) => _ForecastRow(
                  day: day,
                  text: text,
                  settings: controller.settings,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.35,
          children: [
            _Detail(
              label: text.humidity,
              value: weather.humidity == null
                  ? text.unavailable
                  : '${weather.humidity}% ',
              icon: Icons.water_drop_outlined,
            ),
            _Detail(
              label: text.feelsLike,
              value: _temperature(
                weather.apparentTemperature,
                controller.settings.temperatureUnit,
              ),
              icon: Icons.thermostat,
            ),
            _Detail(
              label: text.pressure,
              value: weather.pressure == null
                  ? text.unavailable
                  : _pressure(
                      weather.pressure!,
                      controller.settings.pressureUnit,
                    ),
              icon: Icons.speed,
            ),
            _Detail(
              label: text.uvIndex,
              value: weather.uvIndex?.toStringAsFixed(0) ?? text.unavailable,
              icon: Icons.wb_sunny_outlined,
            ),
            _Detail(
              label: text.rainChance,
              value: weather.rainChance == null
                  ? text.unavailable
                  : '${weather.rainChance}%',
              icon: Icons.umbrella_outlined,
            ),
            _Detail(
              label: text.wind,
              value: weather.windSpeed == null
                  ? text.unavailable
                  : _wind(
                      weather.windSpeed!,
                      controller.settings.windSpeedUnit,
                    ),
              icon: Icons.navigation_outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${text.sunrise} / ${text.sunset}',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.Hm(text.locale.languageCode)
                        .format(weather.forecast.first.sunrise),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Icons.wb_sunny_outlined, color: Color(0xFFFFD36B)),
                  Text(
                    DateFormat.Hm(text.locale.languageCode)
                        .format(weather.forecast.first.sunset),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _NoData extends StatelessWidget {
  const _NoData({required this.text, required this.controller});
  final AppStrings text;
  final WeatherController controller;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            color: Colors.white.withValues(alpha: .9),
            size: 72,
            semanticLabel: text.locationUnavailable,
          ),
          const SizedBox(height: 24),
          Text(
            text.noData,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: controller.isRefreshing
                ? null
                : () =>
                      controller.refresh(genericRegionName: text.genericRegion),
            child: Text(text.update),
          ),
        ],
      ),
    ),
  );
}

class _StaleBanner extends StatelessWidget {
  const _StaleBanner({required this.text, required this.controller});
  final AppStrings text;
  final WeatherController controller;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFC247)),
            const SizedBox(width: 8),
            Text(
              text.staleTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(text.staleBody, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: controller.isRefreshing
              ? null
              : () => controller.refresh(genericRegionName: text.genericRegion),
          child: Text(text.update),
        ),
      ],
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .25),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: .12)),
    ),
    child: child,
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .25),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(label, style: const TextStyle(color: Colors.white)),
  );
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({
    required this.day,
    required this.text,
    required this.settings,
  });
  final ForecastDay day;
  final AppStrings text;
  final AppSettings settings;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            DateFormat.E(text.locale.languageCode).format(day.date),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Icon(_icon(day.weatherCode), color: Colors.white),
        const SizedBox(width: 12),
        Text(
          '${_temperature(day.low, settings.temperatureUnit)} / ${_temperature(day.high, settings.temperatureUnit)}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        const Spacer(),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

String _temperature(double value, TemperatureUnit unit) {
  final converted = convertTemperature(value, unit).round();
  return '$converted°${unit == TemperatureUnit.celsius ? 'C' : 'F'}';
}

String _wind(double value, WindSpeedUnit unit) {
  final converted = convertWindSpeed(value, unit).round();
  return '$converted ${unit == WindSpeedUnit.kilometersPerHour ? 'km/h' : 'mph'}';
}

String _pressure(double value, PressureUnit unit) {
  final converted = convertPressure(value, unit).round();
  return '$converted ${unit == PressureUnit.millibar ? 'mbar' : 'mmHg'}';
}

IconData _icon(int code) => switch (code) {
  0 => Icons.wb_sunny_rounded,
  1 || 2 => Icons.wb_cloudy_rounded,
  3 => Icons.cloud_rounded,
  45 || 48 => Icons.foggy,
  71 || 73 || 75 || 77 || 85 || 86 => Icons.ac_unit,
  95 || 96 || 99 => Icons.thunderstorm_rounded,
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
  81 
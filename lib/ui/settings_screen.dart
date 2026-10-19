import 'package:flutter/material.dart';
import 'package:weather_app/data/settings_store.dart';
import 'package:weather_app/domain/units.dart';
import 'package:weather_app/l10n/app_strings.dart';
import 'package:weather_app/ui/weather_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.controller, super.key});
  final WeatherController controller;
  @override
  Widget build(BuildContext context) {
    final text = AppStrings(controller.locale);
    return Directionality(
      textDirection: text.textDirection,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(text.settings),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Option(
              title: text.temperatureUnits,
              selected: controller.settings.temperatureUnit,
              values: const [
                TemperatureUnit.celsius,
                TemperatureUnit.fahrenheit,
              ],
              label: (v) => v == TemperatureUnit.celsius ? '°C' : '°F',
              onChanged: controller.setTemperatureUnit,
            ),
            _Option(
              title: text.windUnits,
              selected: controller.settings.windSpeedUnit,
              values: const [
                WindSpeedUnit.kilometersPerHour,
                WindSpeedUnit.milesPerHour,
              ],
              label: (v) =>
                  v == WindSpeedUnit.kilometersPerHour ? 'km/h' : 'mph',
              onChanged: controller.setWindUnit,
            ),
            _Option(
              title: text.pressureUnits,
              selected: controller.settings.pressureUnit,
              values: const [
                PressureUnit.millibar,
                PressureUnit.millimetersOfMercury,
              ],
              label: (v) => v == PressureUnit.millibar ? 'mbar' : 'mmHg',
              onChanged: controller.setPressureUnit,
            ),
            _Option(
              title: text.language,
              selected: controller.settings.languageCode,
              values: const ['ar', 'en'],
              label: (v) => v == 'ar' ? text.arabic : text.english,
              onChanged: controller.setLanguage,
            ),
          ],
        ),
      ),
    );
  }
}

class _Option<T> extends StatelessWidget {
  const _Option({
    required this.title,
    required this.selected,
    required this.values,
    required this.label,
    required this.onChanged,
  });
  final String title;
  final T selected;
  final List<T> values;
  final String Function(T) label;
  final Future<void> Function(T) onChanged;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .25),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: .12)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 12),
        SegmentedButton<T>(
          showSelectedIcon: false,
          segments: values
              .map(
                (value) =>
                    ButtonSegment(value: value, label: Text(label(value))),
              )
              .toList(),
          selected: {selected},
          onSelectionChanged: (selected) => onChanged(selected.first),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(Colors.white),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.white.withValues(alpha: .12),
            ),
          ),
        ),
      ],
    ),
  );
}

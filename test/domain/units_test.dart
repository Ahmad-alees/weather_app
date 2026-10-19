import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/domain/units.dart';

void main() {
  group('convertTemperature', () {
    test('keeps Celsius values unchanged', () {
      expect(convertTemperature(-10, TemperatureUnit.celsius), -10);
    });

    test('converts Celsius to Fahrenheit', () {
      expect(convertTemperature(0, TemperatureUnit.fahrenheit), 32);
      expect(convertTemperature(-40, TemperatureUnit.fahrenheit), -40);
    });
  });

  group('convertWindSpeed', () {
    test('converts kilometres per hour to miles per hour', () {
      expect(
        convertWindSpeed(1.609344, WindSpeedUnit.milesPerHour),
        closeTo(1, 0.000001),
      );
    });
  });

  group('convertPressure', () {
    test('converts millibar to millimetres of mercury', () {
      expect(
        convertPressure(1013.25, PressureUnit.millimetersOfMercury),
        closeTo(760, 0.01),
      );
    });
  });
}

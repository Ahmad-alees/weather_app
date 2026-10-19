enum TemperatureUnit { celsius, fahrenheit }

enum WindSpeedUnit { kilometersPerHour, milesPerHour }

enum PressureUnit { millibar, millimetersOfMercury }

double convertTemperature(double celsius, TemperatureUnit unit) =>
    switch (unit) {
      TemperatureUnit.celsius => celsius,
      TemperatureUnit.fahrenheit => (celsius * 9 / 5) + 32,
    };

double convertWindSpeed(double kilometersPerHour, WindSpeedUnit unit) =>
    switch (unit) {
      WindSpeedUnit.kilometersPerHour => kilometersPerHour,
      WindSpeedUnit.milesPerHour => kilometersPerHour / 1.609344,
    };

double convertPressure(double millibar, PressureUnit unit) => switch (unit) {
  PressureUnit.millibar => millibar,
  PressureUnit.millimetersOfMercury => millibar * 0.750061683,
};

class ForecastDay {
  const ForecastDay({
    required this.date,
    required this.weatherCode,
    required this.low,
    required this.high,
    required this.sunrise,
    required this.sunset,
  });

  final DateTime date;
  final int weatherCode;
  final double low;
  final double high;
  final DateTime sunrise;
  final DateTime sunset;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'weatherCode': weatherCode,
    'low': low,
    'high': high,
    'sunrise': sunrise.toIso8601String(),
    'sunset': sunset.toIso8601String(),
  };

  factory ForecastDay.fromJson(Map<String, dynamic> json) => ForecastDay(
    date: DateTime.parse(json['date'] as String),
    weatherCode: json['weatherCode'] as int,
    low: (json['low'] as num).toDouble(),
    high: (json['high'] as num).toDouble(),
    sunrise: DateTime.parse(json['sunrise'] as String),
    sunset: DateTime.parse(json['sunset'] as String),
  );
}

class WeatherData {
  const WeatherData({
    required this.regionName,
    required this.fetchedAt,
    required this.temperature,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.isDay,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.uvIndex,
    required this.rainChance,
    required this.airQualityIndex,
    required this.forecast,
  });

  final String regionName;
  final DateTime fetchedAt;
  final double temperature;
  final double apparentTemperature;
  final int weatherCode;
  final bool isDay;
  final int? humidity;
  final double? pressure;
  final double? windSpeed;
  final double? windDirection;
  final double? uvIndex;
  final int? rainChance;
  final int? airQualityIndex;
  final List<ForecastDay> forecast;

  Map<String, dynamic> toJson() => {
    'regionName': regionName,
    'fetchedAt': fetchedAt.toIso8601String(),
    'temperature': temperature,
    'apparentTemperature': apparentTemperature,
    'weatherCode': weatherCode,
    'isDay': isDay,
    'humidity': humidity,
    'pressure': pressure,
    'windSpeed': windSpeed,
    'windDirection': windDirection,
    'uvIndex': uvIndex,
    'rainChance': rainChance,
    'airQualityIndex': airQualityIndex,
    'forecast': forecast.map((day) => day.toJson()).toList(),
  };

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
    regionName: json['regionName'] as String,
    fetchedAt: DateTime.parse(json['fetchedAt'] as String),
    temperature: (json['temperature'] as num).toDouble(),
    apparentTemperature: (json['apparentTemperature'] as num).toDouble(),
    weatherCode: json['weatherCode'] as int,
    isDay: json['isDay'] as bool,
    humidity: json['humidity'] as int?,
    pressure: (json['pressure'] as num?)?.toDouble(),
    windSpeed: (json['windSpeed'] as num?)?.toDouble(),
    windDirection: (json['windDirection'] as num?)?.toDouble(),
    uvIndex: (json['uvIndex'] as num?)?.toDouble(),
    rainChance: json['rainChance'] as int?,
    airQualityIndex: json['airQualityIndex'] as int?,
    forecast: (json['forecast'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(ForecastDay.fromJson)
        .toList(),
  );
}

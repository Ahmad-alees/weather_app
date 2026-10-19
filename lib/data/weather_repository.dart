import 'package:weather_app/data/location_service.dart';
import 'package:weather_app/data/weather_api.dart';
import 'package:weather_app/data/weather_cache.dart';
import 'package:weather_app/domain/weather_data.dart';

class WeatherRepository {
  WeatherRepository({
    LocationService? locationService,
    WeatherApi? api,
    WeatherCache? cache,
  }) : _locationService = locationService ?? LocationService(),
       _api = api ?? WeatherApi(),
       _cache = cache ?? WeatherCache();

  final LocationService _locationService;
  final WeatherApi _api;
  final WeatherCache _cache;

  Future<WeatherData?> cachedWeather() => _cache.load();

  Future<WeatherData> refresh({required String genericRegionName}) async {
    final location = await _locationService.currentLocation();
    final regionName =
        await _locationService.regionName(location) ?? genericRegionName;
    final weather = await _api.fetch(
      location: location,
      regionName: regionName,
    );
    await _cache.save(weather);
    return weather;
  }
}

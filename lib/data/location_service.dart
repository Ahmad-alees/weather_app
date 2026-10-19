import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DeviceLocation {
  const DeviceLocation(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class LocationService {
  Future<DeviceLocation> currentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationUnavailableException();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationUnavailableException();
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
    return DeviceLocation(position.latitude, position.longitude);
  }

  Future<String?> regionName(DeviceLocation location) async {
    try {
      final places = await Geocoding().placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (places.isEmpty) return null;
      final place = places.first;
      return place.locality?.trim().isNotEmpty == true
          ? place.locality
          : place.subAdministrativeArea?.trim();
    } catch (_) {
      return null;
    }
  }
}

class LocationUnavailableException implements Exception {
  const LocationUnavailableExc
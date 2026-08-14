import 'package:geolocator/geolocator.dart';

class LocationService {
  static const double defaultRadius = 100; // মিটার

  static Future<bool> hasPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  static Future<Position> getCurrentLocation() async {
    final hasPerm = await hasPermission();
    if (!hasPerm) throw Exception('Location permission denied');
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<bool> isAtLocation({
    required double targetLat,
    required double targetLon,
    double radius = defaultRadius,
  }) async {
    try {
      final pos = await getCurrentLocation();
      final distance = Geolocator.distanceBetween(
        pos.latitude, pos.longitude,
        targetLat, targetLon,
      );
      return distance <= radius;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> verifyLocation({
    required double targetLat,
    required double targetLon,
    double radius = defaultRadius,
  }) async {
    final hasPerm = await hasPermission();
    if (!hasPerm) {
      throw Exception('GPS permission required.');
    }
    final isAt = await isAtLocation(
      targetLat: targetLat,
      targetLon: targetLon,
      radius: radius,
    );
    if (!isAt) {
      throw Exception('You are not within ${radius}m of the proposed location.');
    }
    return true;
  }
}

import 'package:geolocator/geolocator.dart';

class LocationService {
  static const double defaultRadius = 100; // মিটার

  // লোকেশন পারমিশন চেক
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

  // বর্তমান লোকেশন পাওয়া
  static Future<Position> getCurrentLocation() async {
    final hasPerm = await hasPermission();
    if (!hasPerm) throw Exception('Location permission denied');
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // নির্দিষ্ট লোকেশনে আছে কিনা চেক করা
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

  // GPS ভেরিফাই বাটনের জন্য (সার্কেল প্রস্তাবের সময়)
  static Future<bool> verifyLocation({
    required double targetLat,
    required double targetLon,
    double radius = defaultRadius,
  }) async {
    final hasPerm = await hasPermission();
    if (!hasPerm) {
      throw Exception('GPS permission required. Please enable location services.');
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

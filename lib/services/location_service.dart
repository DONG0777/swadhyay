import 'package:geolocator/geolocator.dart';

class LocationService {
  // পারমিশন চেক ও রিকোয়েস্ট
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // সার্ভিস চালু আছে কিনা চেক
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // বর্তমান লোকেশন পাওয়া
  Future<Position> getCurrentLocation() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      throw Exception('লোকেশন পারমিশন দেওয়া হয়নি।');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // দুটি লোকেশনের মধ্যে দূরত্ব (মিটারে)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}

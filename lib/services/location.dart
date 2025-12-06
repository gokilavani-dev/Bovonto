import 'package:geolocator/geolocator.dart';
import 'dart:math';

class LocationService {
  static const companyLat = 9.848738; // <-- replace with real company latitude
  static const companyLng =
      78.086800; // <-- replace with real company longitude

  // Distance calculator using Haversine formula
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371000; // meters
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  static double _degToRad(double deg) => deg * (pi / 180);

  static Future<bool> isWithinRange(double rangeMeters) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double distance = calculateDistance(
      pos.latitude,
      pos.longitude,
      companyLat,
      companyLng,
    );

    return distance <= rangeMeters;
  }
}

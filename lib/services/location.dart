import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

class LocationService {
  static const double companyLat = 9.848738;
  static const double companyLng = 78.086800;

  static double _degToRad(double deg) => deg * (pi / 180);

  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371000;
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

  static Future<bool> _ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // UNIVERSAL LOCATION FETCH (Works on all Geolocator versions)
  static Future<Position?> _getLocation() async {
    bool ok = await _ensurePermission();
    if (!ok) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low, // battery saver & stable
      );
    } catch (e) {
      debugPrint("LOCATION ERROR: $e");
      return null;
    }
  }

  static Future<String> validateLocation(double rangeMeters) async {
    Position? pos = await _getLocation();
    if (pos == null) return "location_off";

    double dist = calculateDistance(
      pos.latitude,
      pos.longitude,
      companyLat,
      companyLng,
    );

    debugPrint("USER DISTANCE = $dist");

    if (dist > rangeMeters) return "far";
    return "ok";
  }
}

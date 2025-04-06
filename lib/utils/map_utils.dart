import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  /// Calculate area of a polygon in square meters
  static double calculatePolygonArea(List<LatLng> coordinates) {
    if (coordinates.length < 3) return 0;

    // Earth's radius in meters
    const double earthRadius = 6371000;

    // Calculate area using the Shoelace formula combined with the Haversine formula
    double area = 0;

    for (int i = 0; i < coordinates.length; i++) {
      int j = (i + 1) % coordinates.length;

      // Convert latitude and longitude from degrees to radians
      final lat1 = coordinates[i].latitude * pi / 180;
      final lng1 = coordinates[i].longitude * pi / 180;
      final lat2 = coordinates[j].latitude * pi / 180;
      final lng2 = coordinates[j].longitude * pi / 180;

      // Calculate the cross product
      area += (lng2 - lng1) * (2 + sin(lat1) + sin(lat2));
    }

    // Finish the calculation
    area = area * earthRadius * earthRadius / 2;
    return area.abs();
  }

  /// Convert square meters to acres
  static double squareMetersToAcres(double squareMeters) {
    // 1 acre = 4046.86 square meters
    return squareMeters / 4046.86;
  }

  /// Get the center point of a list of coordinates
  static LatLng getPolygonCenter(List<LatLng> coordinates) {
    if (coordinates.isEmpty) return const LatLng(0, 0);

    double latitudeSum = 0;
    double longitudeSum = 0;

    for (var coordinate in coordinates) {
      latitudeSum += coordinate.latitude;
      longitudeSum += coordinate.longitude;
    }

    return LatLng(
      latitudeSum / coordinates.length,
      longitudeSum / coordinates.length,
    );
  }

  /// Format acres with 2 decimal places
  static String formatAcres(double acres) {
    return acres.toStringAsFixed(2);
  }
}
import 'dart:math' as math;

class DistanceCalculator {
  
  static double calculateDistanceInKm(double userLat, double userLong,
      double restaurantLat, double restaurantLong) {
    const int radiusOfEarth = 6371000;
    final double latDistance = _degreesToRadians(restaurantLat - userLat);
    final double longDistance =
        _degreesToRadians(restaurantLong - userLong);
    final double a = (math.sin(latDistance / 2) * math.sin(latDistance / 2)) +
        (math.cos(_degreesToRadians(userLat)) *
            math.cos(_degreesToRadians(restaurantLat)) *
            math.sin(longDistance / 2) *
            math.sin(longDistance / 2));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distanceMeters = radiusOfEarth * c;
    final double distanceKm = distanceMeters / 1000;

    return distanceKm;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

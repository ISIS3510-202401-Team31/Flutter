import 'package:geolocator/geolocator.dart';
import 'package:unifood/repository/analytics_repository.dart';

class LocationRepository {
  Future<Position> getUserLocation() async {
    try {
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return userLocation;
    } catch (e, stackTrace) {
      // Instantiating AnalyticsRepository internally
      final analyticsRepository = AnalyticsRepository();

      // Saving error information using AnalyticsRepository
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUserLocation',
      };
      analyticsRepository.saveError(errorInfo);

      // Re-throwing the caught error
      print("Error getting user's location: $e");
      rethrow;
    }
  }
}

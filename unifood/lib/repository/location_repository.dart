import 'package:geolocator/geolocator.dart';
import 'package:unifood/repository/analytics_repository.dart';

class LocationRepository {
  Future<Position> getUserLocation() async {
    try {
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return userLocation;
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUserLocation',
      };
      AnalyticsRepository().saveError(errorInfo);
      print("Error getting users location: $e");
      rethrow;
    }
  }
}

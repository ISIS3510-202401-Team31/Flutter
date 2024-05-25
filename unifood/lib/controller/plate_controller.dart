import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/plate_repository.dart';
import 'package:unifood/repository/location_repository.dart';
import 'package:unifood/repository/shared_preferences.dart';

class PlateController {
  final PlateRepository _plateRepository = PlateRepository();
  final LocationRepository _locationRepository = LocationRepository();

  final StreamController<List<Plate?>> _platesByIdController =
      StreamController<List<Plate?>>.broadcast();
  final StreamController<List<Plate?>> _platesByPriceRangeController =
      StreamController<List<Plate?>>.broadcast();

  Stream<List<Plate?>> get platesByRestaurantId => _platesByIdController.stream;
  Stream<List<Plate?>> get platesByPriceRange =>
      _platesByPriceRangeController.stream;

  void dispose() {
    _platesByIdController.close();
    _platesByPriceRangeController.close();
  }

  Future<void> getPlatesByRestaurantId(String restaurantId) async {
    try {
      final data = await _plateRepository.getPlatesByRestaurantId(restaurantId);

      final plates = data
          .map(
            (item) => Plate(
              id: item['id'] ?? "",
              restaurantId: item['restaurantId'] ?? "",
              imagePath: item['imageURL'] ?? "",
              name: item['name'] ?? "",
              description: item['description'] ?? "",
              price: item['price'].toDouble() ?? 0.0,
              ranking: item['ranking'] ?? {},
            ),
          )
          .toList();

      _platesByIdController.sink.add(plates);
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlatesByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plates by id in view model: $e');
      rethrow;
    }
  }

  Future<Plate?> getPlateById(String plateId, String restaurantId) async {
    try {
      final data = await _plateRepository.getPlateById(plateId, restaurantId);

      if (data == null) return null;
      return Plate(
        id: data['id'] ?? "",
        restaurantId: data['restaurantId'] ?? "",
        ranking: data['ranking'] ?? {},
        imagePath: data['imageURL'] ?? "",
        name: data['name'] ?? "",
        description: data['description'] ?? "",
        price: data['price'].toDouble() ?? 0.0,
      );
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlateById',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plate by id in view model: $e');
      rethrow;
    }
  }

  Future<List<Plate>> fetchPlatesByPriceRange() async {
    try {
      final userLocation = await _getUserLocation();
      Users? user = await SharedPreferencesService().getUser();

      final data = await _plateRepository.fetchPlatesByPriceRange(
          user!.uid, userLocation.latitude, userLocation.longitude);

      final plates = data
          .map(
            (item) => Plate(
              id: item['id'] ?? "",
              restaurantId: item['restaurantId'] ?? "",
              imagePath: item['imageURL'] ?? "",
              name: item['name'] ?? "",
              description: item['description'] ?? "",
              price: item['price'].toDouble() ?? 0.0,
              ranking: item['ranking'] ?? {},
            ),
          )
          .toList();

      return plates;
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchPlatesByPriceRange',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw ('Timeout while fetching plates by price range: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchPlatesByPriceRange',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plates by price range in view model: $e');
      rethrow;
    }
  }

  Future<Position> _getUserLocation() async {
    try {
      return await _locationRepository.getUserLocation();
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUserLocation',
      };
      AnalyticsRepository().saveError(errorInfo);
      print("Error getting user's location: $e");
      rethrow;
    }
  }
}

import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/plate_repository.dart';

class PlateViewModel {
  final PlateRepository _plateRepository = PlateRepository();

  Future<List<Plate>> getPlatesByRestaurantId(String restaurantId) async {
    try {
      final data = await _plateRepository.getPlatesByRestaurantId(restaurantId);

      return data
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
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlatesByRestaurantId',
      };
      ErrorRepository().saveError(errorInfo);
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
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching plate by id in view model: $e');
      rethrow;
    }
  }
}

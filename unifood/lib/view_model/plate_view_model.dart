import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/plate_repository.dart';

class PlateViewModel {
  final PlateRepository _plateRepository = PlateRepository();

  Future<List<Plate>> getPlatesByRestaurantId(String restaurantId) async {
    try {
      final List<Map<String, dynamic>> data =
          await _plateRepository.getPlatesByRestaurantId(restaurantId);

      return data
          .map(
            (item) => Plate(
              imagePath: item['imageURL'],
              name: item['name'],
              description: item['description'],
              price: item['price'].toDouble(),
            ),
          )
          .toList();
    }  catch (e, stackTrace) {
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
}

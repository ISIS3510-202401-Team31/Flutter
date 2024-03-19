import 'package:unifood/model/plate_entity.dart';
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
              price: item['price'],
            ),
          )
          .toList();
    } catch (error) {
      print('Error fetching menu items in view model: $error');
      rethrow;
    }
  }
}

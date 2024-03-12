import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/repository/plate_repository.dart';

class PlateViewModel {
  final PlateRepository _plateRepository = PlateRepository();

  Future<List<Plate>> getMenuItems() async {
    try {
      final List<Map<String, dynamic>> data =
          await _plateRepository.getMenuItems();

      return data
          .map(
            (item) => Plate(
              imagePath: item['imagePath'],
              name: item['nombre'],
              description: item['descripcion'],
              price: item['precio'],
            ),
          )
          .toList();
    } catch (error) {
      print('Error fetching menu items in view model: $error');
      rethrow;
    }
  }
}

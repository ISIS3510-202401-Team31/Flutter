import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/restaurant_repository.dart';

class RestaurantViewModel {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final List<Map<String, dynamic>> data =
          await _restaurantRepository.getRestaurants();

      return data
          .map(
            (item) => Restaurant(
              imageUrl: item['imageUrl'],
              logoUrl: item['logoUrl'],
              name: item['name'],
              isOpen: item['isOpen'],
              distance: item['distance'].toDouble(),
              rating: item['rating'].toDouble(),
              avgPrice: item['avgPrice'].toDouble(),
              foodType: item['foodType'],
              phoneNumber: item['phoneNumber'],
              workingHours: item['workingHours'],
              likes: item['likes'],
              address: item['address'],
              addressDetail: item['addressDetail'],
            ),
          )
          .toList();
    } catch (error) {
      print('Error fetching menu items in view model: $error');
      rethrow;
    }
  }

  Future<Restaurant?> getRestaurantByName(String restaurantName) async {
  try {
    final Map<String, dynamic>? data =
        await _restaurantRepository.getRestaurantByName(restaurantName);

    if (data != null) {
      return Restaurant(
        imageUrl: data['imageURL'] ?? '',
        logoUrl: data['logoURL'] ?? '',
        name: data['name'] ?? '',
        isOpen: data['isOpen'] ?? false,
        distance: data['distance']?.toDouble() ?? 0.0,
        rating: data['rating']?.toDouble() ?? 0.0,
        avgPrice: data['avgPrice']?.toDouble() ?? 0.0,
        foodType: data['foodType'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        workingHours: data['workingHours'] ?? '',
        likes: data['likes'].toInt() ?? 0,
        address: data['address'] ?? '',
        addressDetail: data['addressDetail'] ?? '',
      );
    } else {
      return null;
    }
  } catch (error) {
    print('Error fetching restaurant by name in view model: $error');
    rethrow;
  }
}

}

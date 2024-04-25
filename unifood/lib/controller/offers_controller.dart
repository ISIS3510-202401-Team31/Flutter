import 'package:unifood/model/offer_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/offers_repository.dart';
import 'package:unifood/model/restaurant_entity.dart';
class OffersController {
  final OffersRepository _offersRepository = OffersRepository();

  Future<List<Offer>> getOffersByRestaurantId(String restaurantId) async {
    try {
      final data = await _offersRepository.getOffersByRestaurantId(restaurantId);

      return data.map((item) => Offer(
          id: item['id'] ?? "",
          restaurantId: item['restaurantId'] ?? "",
          imagePath: item['imagePath'] ?? "",
          mainText: item['mainText'] ?? "",
          subText: item['subText'] ?? "",
          points: item['points'] ?? 0,
        )).toList();
    } catch (e, stackTrace) {
      // Save error information to the database
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getOffersByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching offers by restaurant id in view model: $e');
      rethrow;
    }
  }

  Future<Restaurant> getRestaurantInformationById(String restaurantId) async {
    try {
      final restaurantData = await _offersRepository.getRestaurantInformationById(restaurantId);
      if (restaurantData != null) {
        return Restaurant(
          id: restaurantId,
          imageUrl: restaurantData['imageUrl'] ?? "",
          logoUrl: restaurantData['logoURL'] ?? "",
          name: restaurantData['name'] ?? "",
          isOpen: restaurantData['isOpen'] ?? false,
          distance: restaurantData['distance'] ?? 0.0,
          rating: restaurantData['rating'] ?? 0.0,
          avgPrice: restaurantData['avgPrice'] ?? 0.0,
          foodType: restaurantData['foodType'] ?? "",
          phoneNumber: restaurantData['phoneNumber'] ?? "",
          workingHours: restaurantData['workingHours'] ?? "",
          likes: restaurantData['likes'] ?? 0,
          address: restaurantData['address'] ?? "",
          addressDetail: restaurantData['addressDetail'] ?? "",
          latitude: restaurantData['latitude'] ?? "",
          longitude: restaurantData['longitude'] ?? ""
        );
      } else {
        throw Exception('Restaurant data not found for ID: $restaurantId');
      }
    } catch (e, stackTrace) {
      // Save error information to the database
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurantInformationById',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching restaurant information by restaurant id in view model: $e');
      rethrow;
    }
  }

}

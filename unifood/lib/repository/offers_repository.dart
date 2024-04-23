import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/repository/analytics_repository.dart';

class OffersRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  OffersRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<List<Map<String, dynamic>>> getOffersByRestaurantId(String restaurantId) async {
    try {
      final querySnapshot = await _firestoreServiceAdapter.getCollectionDocuments('restaurants/$restaurantId/offers');
      List<Map<String, dynamic>> offers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> offerData = doc.data() as Map<String, dynamic>;
        offerData['id'] = doc.id;
        offerData['restaurantId'] = restaurantId;
        return offerData;
      }).toList();
      return offers;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getOffersByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching offers by restaurant id in repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRestaurantInformationById(String restaurantId) async {
    try {
      final docSnapshot = await _firestoreServiceAdapter.getDocumentById('restaurants', restaurantId);
      if (docSnapshot.exists) {
        Map<String, dynamic>? restaurantData = docSnapshot.data();
        if (restaurantData != null) {
          // Only extracting necessary fields
          return {
            'name': restaurantData['name'],
            'logoURL': restaurantData['logoURL'],
            'phoneNumber': restaurantData['phoneNumber'],
            'rating': restaurantData['rating']
          };
        }
      } else {
        print('No restaurant found with id: $restaurantId');
        return null;
      }
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurantInformationById',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching restaurant information by id in repository: $e');
      rethrow;
    }
  }
}

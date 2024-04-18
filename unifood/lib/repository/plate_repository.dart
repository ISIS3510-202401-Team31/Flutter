import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/repository/analytics_repository.dart';

class PlateRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  PlateRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<List<Map<String, dynamic>>> getPlatesByRestaurantId(String restaurantId) async {
    try {
      final querySnapshot = await _firestoreServiceAdapter.getCollectionDocuments('restaurants/$restaurantId/plates');

      List<Map<String, dynamic>> plates = querySnapshot.docs.map((doc) {
        Map<String, dynamic> plateData = doc.data();
        plateData['id'] = doc.id;
        plateData['restaurantId'] = restaurantId;
        return plateData;
      }).toList();

      return plates;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlatesByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plates by id in repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPlateById(String plateId, String restaurantId) async {
    try {
      final docSnapshot = await _firestoreServiceAdapter.getDocumentById('restaurants/$restaurantId/plates', plateId);

      if (docSnapshot.exists) {
        Map<String, dynamic>? plateData = docSnapshot.data();
        plateData?['id'] = docSnapshot.id;
        plateData?['restaurantId'] = restaurantId;
        return plateData;
      } else {
        print('No plate found with id: $plateId');
        return null;
      }
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlateById',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plate by id in repository: $e');
      rethrow;
    }
  }
}

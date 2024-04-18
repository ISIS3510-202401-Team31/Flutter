import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/repository/analytics_repository.dart';

class ReviewRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  ReviewRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<List<Map<String, dynamic>>> getReviewsByRestaurantId(String restaurantId) async {
    try {
      final querySnapshot = await _firestoreServiceAdapter.getCollectionDocuments('restaurants/$restaurantId/reviews');
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by restaurant id in repository: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReviewsByPlateId(String plateId, String restaurantId) async {
    try {
      final querySnapshot = await _firestoreServiceAdapter.getCollectionDocuments('restaurants/$restaurantId/plates/$plateId/reviews');
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByPlateId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by plate id in repository: $e');
      rethrow;
    }
  }
}

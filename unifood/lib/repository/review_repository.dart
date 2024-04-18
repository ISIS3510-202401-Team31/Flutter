import 'package:unifood/data/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/repository/analytics_repository.dart';

class ReviewRepository {
  FirebaseFirestore databaseInstance = FirebaseService().database;

  Future<List<Map<String, dynamic>>> getReviewsByRestaurantId(
      String restaurantId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await databaseInstance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('reviews')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by id in repository: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReviewsByPlateId( String plateId, String restaurantId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await databaseInstance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('plates')
          .doc(plateId)
          .collection('reviews')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by id in repository: $e');
      rethrow;
    }
  }
}

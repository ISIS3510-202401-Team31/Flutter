import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/data/firebase_service.dart';
import 'package:unifood/repository/error_repository.dart';

class PlateRepository {
  FirebaseFirestore databaseInstance = FirebaseService().database;

  Future<List<Map<String, dynamic>>> getPlatesByRestaurantId(
      String restaurantId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await databaseInstance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('plates')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {

      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlatesByRestaurantId',
      };
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching plates by id in repository: $e');
      rethrow;
    }
  }
}

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
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching plates by id in repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPlateById(String plateId, String restaurantId) async {
    try {
      print(restaurantId);
      DocumentSnapshot<Map<String, dynamic>?> docSnapshot =
          await databaseInstance
              .collection('restaurants')
              .doc(restaurantId)
              .collection('plates')
              .doc(plateId)
              .get();

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
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurantById',
      };
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching restaurant by id in repository: $e');
      rethrow;
    }
  }
}

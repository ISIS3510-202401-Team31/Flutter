import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/data/firebase_service.dart';

class PlateRepository {

  FirebaseFirestore databaseInstance = FirebaseService().database;

  Future<List<Map<String, dynamic>>> getPlatesByRestaurantId(String restaurantId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await databaseInstance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('plates')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error fetching menu items: $error');
      rethrow;
    }
  }
}

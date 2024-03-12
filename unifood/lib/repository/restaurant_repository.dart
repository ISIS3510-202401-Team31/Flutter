import 'package:unifood/data/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantRepository {
  
  FirebaseFirestore databaseInstance = FirebaseService().database;
  
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await databaseInstance.collection('restaurants').get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error fetching menu items: $error');
      rethrow;
    }
  }

   Future<Map<String, dynamic>?> getRestaurantByName(String restaurantName) async {
    try {
      QuerySnapshot<Map<String, dynamic>?> querySnapshot = 
          await databaseInstance.collection('restaurants').where('name', isEqualTo: restaurantName).get();

      return querySnapshot.docs.first.data();

    } catch (error) {
      print('Error fetching restaurant by name: $error');
      rethrow;
    }
  }

}

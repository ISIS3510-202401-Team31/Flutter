import 'package:unifood/data/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantRepository {
  FirebaseFirestore databaseInstance = FirebaseService().database;

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await databaseInstance.collection('restaurants').get();

      List<Map<String, dynamic>> restaurants = querySnapshot.docs.map((doc) {
        Map<String, dynamic> restaurantData = doc.data();
        restaurantData['docId'] =
            doc.id; // Agregar el docId a los datos del restaurante
        return restaurantData;
      }).toList();

      return restaurants;
    } catch (error) {
      print('Error fetching menu items: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRestaurantById(String restaurantId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>?> docSnapshot =
          await databaseInstance
              .collection('restaurants')
              .doc(restaurantId)
              .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        print('No restaurant found with id: $restaurantId');
        return null;
      }
    } catch (error) {
      print('Error fetching restaurant by id: $error');
      rethrow;
    }
  }
}

import 'package:unifood/data/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewRepository {
  
  FirebaseFirestore databaseInstance = FirebaseService().database;
  
  Future<List<Map<String, dynamic>>> getReviewsByRestaurantId(String restaurantId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await databaseInstance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('reviews')
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error fetching reviews: $error');
      rethrow;
    }
  }

}

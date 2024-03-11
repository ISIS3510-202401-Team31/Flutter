import 'package:unifood/data/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlateRepository {
  
  FirebaseFirestore databaseInstance = FirebaseService().database;
  
  Future<List<Map<String, dynamic>>> getMenuItems() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await databaseInstance.collection('plates').get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      print('Error fetching menu items: $error');
      throw error;
    }
  }

}

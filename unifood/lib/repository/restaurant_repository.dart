import 'dart:convert';
import 'package:unifood/data/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:unifood/repository/error_repository.dart';

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
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurants',
      };
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching restaurants in repository: $e');
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

  Future<List<Map<String, dynamic>>> fetchRecommendedRestaurants(
      String userId, String categoryFilter) async {
    try {
      final response = await http.get(
          Uri.parse('http://3.22.0.19//recommend/$userId/$categoryFilter'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception('Failed to load recommended restaurants');
      }
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchRecommendedRestaurants',
      };
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching recommended restaurants in repository: $e');
      rethrow;
    }
  }
}

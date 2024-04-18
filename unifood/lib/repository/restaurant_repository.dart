import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/data/firebase_service_adapter.dart';


class RestaurantRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  RestaurantRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      final querySnapshot = await _firestoreServiceAdapter.getCollectionDocuments('restaurants');

      List<Map<String, dynamic>> restaurants = querySnapshot.docs.map((doc) {
        Map<String, dynamic> restaurantData = doc.data();
        restaurantData['docId'] = doc.id; 
        return restaurantData;
      }).toList();

      return restaurants;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching restaurants in repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRestaurantById(String restaurantId) async {
    try {
      final docSnapshot = await _firestoreServiceAdapter.getDocumentById('restaurants', restaurantId);

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        print('No restaurant found with id: $restaurantId');
        return null;
      }
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurantById',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching restaurant by id in repository: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecommendedRestaurants(
      String userId, String categoryFilter) async {
    try {
      final response = await http
        .get(Uri.parse(
            'http://3.22.0.19:5000//recommend/$userId/$categoryFilter'))
        .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
       List<Map<String, dynamic>> restaurantsData = List<Map<String, dynamic>>.from(responseData);

      for (Map<String, dynamic> restaurantData in restaurantsData) {
        restaurantData['id'] = restaurantData['docId']; // Asignar docId como el id del restaurante
      }

      return restaurantsData;

      } else {
        print('Failed to load recommended restaurants. Status code: ${response.statusCode}');
        return []; 
      }
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchRecommendedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw('Timeout while fetching recommended restaurants: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchRecommendedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching recommended restaurants in repository: $e');
      rethrow;
    }
}
}

import 'dart:async';
import 'dart:convert';

import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:http/http.dart' as http;
import 'package:unifood/repository/shared_preferences.dart';

class PlateRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  PlateRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  static final Map<String, List<Map<String, dynamic>>> _cache = {};

  Future<List<Map<String, dynamic>>> getPlatesByRestaurantId(
      String restaurantId) async {
    try {
      final querySnapshot = await _firestoreServiceAdapter
          .getCollectionDocuments('restaurants/$restaurantId/plates');

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
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plates by id in repository: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPlateById(
      String plateId, String restaurantId) async {
    try {
      final docSnapshot = await _firestoreServiceAdapter.getDocumentById(
          'restaurants/$restaurantId/plates', plateId);

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
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPlateById',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plate by id in repository: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPlatesByPriceRange(
      String userId, double userLat, double userLong) async {
    final String cacheKey = '$userLat-$userLong';
    try {
      final response = await http
          .get(Uri.parse(
              'http://3.22.0.19:5000//dishes_by_price_range/$userId/$userLat/$userLong'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> platesData =
            List<Map<String, dynamic>>.from(responseData);

        for (Map<String, dynamic> plateData in platesData) {
          plateData['id'] = plateData['docId'];
        }

        _cache[cacheKey] = platesData;

        return platesData;
      } else {
        if (_cache.containsKey(cacheKey)) {
          print('Returning cached response for $cacheKey');
          return _cache[cacheKey]!;
        } else {
          print(
              'Failed to load plates by price range. Status code: ${response.statusCode}');
          return [];
        }
      }
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchPlatesByPriceRange',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw ('Timeout while fetching plates by price range: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchPlatesByPriceRange',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching plates by price range in repository: $e');
      if (_cache.containsKey(cacheKey)) {
        print('Returning cached response for $cacheKey');
        return _cache[cacheKey]!;
      } else {
        rethrow;
      }
    }
  }
}

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:path/path.dart';

class RestaurantRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  // RestaurantRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();
  Map<String, List<Map<String, dynamic>>> _cache = {};

  late Database _database;

  RestaurantRepository()
      : _firestoreServiceAdapter = FirestoreServiceAdapter() {
    // Initialize database when the repository is created
    _initDatabase();
  }

  final int _maxDatabaseSizeInBytes = 50 * 1024 * 1024; // 50MB

  // Verifica si el tamaño de la base de datos excede el límite
  Future<bool> _isDatabaseSizeExceeded() async {
    final databasePath =
        join(await getDatabasesPath(), 'restaurant_database.db');
    final file = File(databasePath);
    final fileSize = await file.length();
    return fileSize >= _maxDatabaseSizeInBytes;
  }

  // Initialize the local database
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'restaurant_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE restaurants(docId TEXT PRIMARY KEY, data TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertRestaurant(Map<String, dynamic> restaurantData) async {
    if (await _isDatabaseSizeExceeded()) {
      throw Exception(
          'No se puede agregar más datos. La base de datos ha alcanzado su límite de tamaño.');
    } else {
      await _database.insert(
        'restaurants',
        {'docId': restaurantData['docId'], 'data': jsonEncode(restaurantData)},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getLocalRestaurants() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('restaurants');

    return List.generate(maps.length, (i) {
      return jsonDecode(maps[i]['data']);
    });
  }

  Future<void> deleteAllLocalRestaurants() async {
    await _database.delete('restaurants');
  }

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    try {
      List<Map<String, dynamic>> localRestaurants = await getLocalRestaurants();

      if (localRestaurants.isNotEmpty) {
        return localRestaurants;
      }

      final querySnapshot =
          await _firestoreServiceAdapter.getCollectionDocuments('restaurants');

      List<Map<String, dynamic>> restaurants = querySnapshot.docs.map((doc) {
        Map<String, dynamic> restaurantData = doc.data();
        restaurantData['docId'] = doc.id;
        return restaurantData;
      }).toList();

      restaurants.forEach((restaurant) {
        insertRestaurant(restaurant);
      });

      return restaurants;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurantById',
      };
      AnalyticsRepository().saveError(errorInfo);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getRestaurantById(String restaurantId) async {
    try {
      List<Map<String, dynamic>> localRestaurants = await getLocalRestaurants();
      final restaurant = localRestaurants.firstWhere(
          (restaurant) => restaurant['docId'] == restaurantId,
          orElse: () => {});

      if (restaurant.isNotEmpty) {
        return restaurant;
      }

      final docSnapshot = await _firestoreServiceAdapter.getDocumentById(
          'restaurants', restaurantId);

      if (docSnapshot.exists) {
        Map<String, dynamic> restaurantData = docSnapshot.data()!;
        restaurantData['docId'] = docSnapshot.id;

        insertRestaurant(restaurantData);
        print(
            'Obtenido restaurante por ID de Firestore y almacenado en la base de datos local');
        return docSnapshot.data();
      } else {
        print('No se encontró ningún restaurante con el ID: $restaurantId');
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
      print('Error al buscar restaurante por ID en el repositorio: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecommendedRestaurants(
      String userId, String categoryFilter) async {
    final String cacheKey = '$userId-$categoryFilter';
    try {
      // Try fetching data from the network
      final response = await http
          .get(Uri.parse(
              'http://3.22.0.19:5000//recommend/$userId/$categoryFilter'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse the response data
        final List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> restaurantsData =
            List<Map<String, dynamic>>.from(responseData);

        for (Map<String, dynamic> restaurantData in restaurantsData) {
          restaurantData['id'] = restaurantData['docId'];
        }

        // Cache the response
        _cache[cacheKey] = restaurantsData;

        return restaurantsData;
      } else {
         if (_cache.containsKey(cacheKey)) {
          print('Returning cached response for $cacheKey');
          return _cache[cacheKey]!;
        } else {
          // If no cached data available, return an empty list
          print(
              'Failed to load recommended restaurants. Status code: ${response.statusCode}');
          return [];
        }
      }
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchRecommendedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw ('Timeout while fetching recommended restaurants: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchRecommendedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching recommended restaurants in repository: $e');
      if (_cache.containsKey(cacheKey)) {
        print('Returning cached response for $cacheKey');
        return _cache[cacheKey]!;
      } else {
        rethrow;
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchLikedRestaurants(
      String userLat, String userLong) async {
    try {
      final response = await http
          .get(
              Uri.parse('http://3.22.0.19:5000//most_liked/$userLat/$userLong'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> restaurantsData =
            List<Map<String, dynamic>>.from(responseData);

        for (Map<String, dynamic> restaurantData in restaurantsData) {
          restaurantData['id'] = restaurantData['docId'];
        }

        return restaurantsData;
      } else {
        throw Exception(
            'Failed to load liked restaurants. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while fetching liked restaurants: $e');
    }
  }
}

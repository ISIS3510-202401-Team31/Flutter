import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  static final Map<String, List<Map<String, dynamic>>> _cache = {};

  late Database _database;

  RestaurantRepository()
      : _firestoreServiceAdapter = FirestoreServiceAdapter() {
    // Initialize database when the repository is created
    _initDatabase();
  }

  final int _maxDatabaseSizeInBytes = 50 * 1024 * 1024; // 50MB

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

  // Check if the size of the database exceeds the limit
  Future<bool> _isDatabaseSizeExceeded() async {
    final databasePath =
        join(await getDatabasesPath(), 'restaurant_database.db');
    final file = File(databasePath);
    final fileSize = await file.length();
    return fileSize >= _maxDatabaseSizeInBytes;
  }

  // Batch insert restaurants into the database
  Future<void> _insertRestaurants(List<Map<String, dynamic>> restaurants) async {
    if (await _isDatabaseSizeExceeded()) {
      throw Exception(
          'No se puede agregar más datos. La base de datos ha alcanzado su límite de tamaño.');
    } else {
      Batch batch = _database.batch();
      for (var restaurant in restaurants) {
        batch.insert(
          'restaurants',
          {'docId': restaurant['docId'], 'data': jsonEncode(restaurant)},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    }
  }

  Future<List<Map<String, dynamic>>> _getLocalRestaurants() async {
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
      bool isConnected = await _checkConnectivity();

      DateTime lastUpdate = await _getLastUpdateTimestamp();

      if (!isConnected) {
        List<Map<String, dynamic>> localRestaurants =
            await _getLocalRestaurants();
        if (localRestaurants.isNotEmpty) {
          return localRestaurants;
        } else {
          throw Exception('No local restaurants available');
        }
      }

      // Always update data from Firestore if it has not been updated within the last 24 hours
      if (DateTime.now().difference(lastUpdate) >= Duration(days: 1)) {
        final querySnapshot = await _firestoreServiceAdapter
            .getCollectionDocuments('restaurants');

        List<Map<String, dynamic>> restaurants = querySnapshot.docs.map((doc) {
          Map<String, dynamic> restaurantData = doc.data();
          restaurantData['docId'] = doc.id;
          return restaurantData;
        }).toList();

        await deleteAllLocalRestaurants(); // Clear local database
        await _insertRestaurants(restaurants); // Insert new data

        await _updateLastUpdateTimestamp();

        return restaurants;
      } else {
        List<Map<String, dynamic>> localRestaurants =
            await _getLocalRestaurants();
        if (localRestaurants.isNotEmpty) {
          return localRestaurants;
        } else {
          throw Exception('No local restaurants available');
        }
      }
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      rethrow;
    }
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<DateTime> _getLastUpdateTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('lastUpdateTimestamp');
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : DateTime(0);
  }

  Future<void> _updateLastUpdateTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'lastUpdateTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<Map<String, dynamic>?> getRestaurantById(String restaurantId) async {
    try {
      List<Map<String, dynamic>> localRestaurants = await _getLocalRestaurants();
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

        await _insertRestaurants([restaurantData]); // Batch insert with a single item
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
              'http://3.22.0.19:5000/recommend/$userId/$categoryFilter'))
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
    final String cacheKey = '$userLat-$userLong';
    try {
      final response = await http
          .get(
              Uri.parse('http://3.22.0.19:5000/most_liked/$userLat/$userLong'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> restaurantsData =
            List<Map<String, dynamic>>.from(responseData);

        for (Map<String, dynamic> restaurantData in restaurantsData) {
          restaurantData['id'] = restaurantData['docId'];
        }

       
        _cache[cacheKey] = restaurantsData;

        return restaurantsData;
      } else {
        if (_cache.containsKey(cacheKey)) {
          print('Returning cached response for $cacheKey');
          return _cache[cacheKey]!;
        } else {
          // If no cached data available, return an empty list
          print(
              'Failed to load liked restaurants. Status code: ${response.statusCode}');
          return [];
        }
      }
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchLikedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw ('Timeout while fetching liked restaurants: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchLikedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching liked restaurants in repository: $e');
      if (_cache.containsKey(cacheKey)) {
        print('Returning cached response for $cacheKey');
        return _cache[cacheKey]!;
      } else {
        rethrow;
      }
    }
  }
}

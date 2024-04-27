import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/location_repository.dart';
import 'package:unifood/repository/restaurant_repository.dart';
import 'package:unifood/utils/distance_calculator.dart';

class RestaurantController {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final LocationRepository _locationRepository = LocationRepository();
  static Map<String, List<Map<String, dynamic>>> _nearbyRestaurantCache = {};

  final StreamController<Restaurant?> _restaurantByIdController =
      StreamController<Restaurant?>.broadcast();

  final StreamController<List<Restaurant>> _restaurantsController =
      StreamController<List<Restaurant>>.broadcast();

  Stream<Restaurant?> get restaurantById => _restaurantByIdController.stream;

  Stream<List<Restaurant>> get restaurants => _restaurantsController.stream;

  void dispose() {
    _restaurantByIdController.close();
    _restaurantsController.close();
  }

  Future<List<Restaurant>> getRestaurants() async {
    return _getRestaurantData(await _getUserLocation());
  }

  Future<void> getRestaurantById(String restaurantName) async {
    final userLocation = await _getUserLocation();
    final data = await _restaurantRepository.getRestaurantById(restaurantName);
    final restaurant =
        data != null ? _mapSingleRestaurantData(data, userLocation) : null;
    _restaurantByIdController.sink.add(restaurant);
  }

  Future<void> fetchRestaurants() async {
    final userLocation = await _getUserLocation();
    final data = await _restaurantRepository.getRestaurants();
    final restaurants = _mapRestaurantData(data, userLocation);
    _restaurantsController.sink.add(restaurants);
  }

  Future<List<Restaurant>> getRestaurantsNearby() async {
    final String cacheKey = 'nearby_restaurants';
    try {
      // Intenta obtener los datos de la red
      final userLocation = await _getUserLocation();
      final data = await _restaurantRepository.getRestaurants();
      final nearbyRestaurants =
          await _filterNearbyRestaurants(data, userLocation);
      _nearbyRestaurantCache[cacheKey] = data;
      return nearbyRestaurants;
    } catch (e, stackTrace) {
      // Si falla la obtención de datos de la red, intenta obtenerlos de la caché
      if (_nearbyRestaurantCache.containsKey(cacheKey)) {
        print('Returning cached response for nearby restaurants: $cacheKey');
        final userLocation = await _getUserLocation();
        return _filterNearbyRestaurants(
            _nearbyRestaurantCache[cacheKey]!, userLocation);
      } else {
        final errorInfo = {
          'error': e.toString(),
          'stacktrace': stackTrace.toString(),
          'timestamp': DateTime.now(),
          'function': 'getRestaurantsNearby',
        };
        AnalyticsRepository().saveError(errorInfo);
        print('Error when fetching nearby restaurants in ViewModel: $e');
        rethrow;
      }
    }
  }

  Future<List<Restaurant>> getRecommendedRestaurants(
      String userId, String categoryFilter) async {
    try {
      final data = await _restaurantRepository.fetchRecommendedRestaurants(
          userId, categoryFilter);
      final userLocation = await _getUserLocation();
      return _mapRestaurantData(data, userLocation);
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRecommendedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw ('Timeout while fetching recommended restaurants: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRecommendedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching recommended restaurants in ViewModel: $e');
      rethrow;
    }
  }

  Future<List<Restaurant>> getLikedRestaurants() async {
    try {
      final userLocation = await _getUserLocation();
      final data = await _restaurantRepository.fetchLikedRestaurants(
          userLocation.latitude.toString(), userLocation.longitude.toString());

      return _mapRestaurantData(data, userLocation);
    } on TimeoutException catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getlikedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      throw ('Timeout while fetching liked restaurants: $e');
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getLikedRestaurants',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching liked restaurants in ViewModel: $e');
      rethrow;
    }
  }

  Future<Position> _getUserLocation() async {
    try {
      return await _locationRepository.getUserLocation();
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUserLocation',
      };
      AnalyticsRepository().saveError(errorInfo);
      print("Error getting users location: $e");
      rethrow;
    }
  }

  Future<List<Restaurant>> _getRestaurantData(Position userLocation) async {
    try {
      final data = await _restaurantRepository.getRestaurants();
      return _mapRestaurantData(data, userLocation);
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getRestaurantData',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching restaurants in view model: $e');
      rethrow;
    }
  }

  List<Restaurant> _mapRestaurantData(
      List<Map<String, dynamic>> data, Position userLocation) {
    return data
        .map((item) => _mapSingleRestaurantData(item, userLocation))
        .toList();
  }

  Restaurant _mapSingleRestaurantData(
      Map<String, dynamic> item, Position userLocation) {
    final restaurantLat = double.parse(item['latitud']);
    final restaurantLong = double.parse(item['longitud']);
    final distance = DistanceCalculator.calculateDistanceInKm(
        userLocation.latitude,
        userLocation.longitude,
        restaurantLat,
        restaurantLong);

    return Restaurant(
        id: item['docId'] ?? '',
        imageUrl: item['imageURL'] ?? '',
        logoUrl: item['logoURL'] ?? '',
        name: item['name'] ?? '',
        isOpen: item['isOpen'] ?? false,
        distance: distance,
        rating: item['rating']?.toDouble() ?? 0.0,
        avgPrice: item['avgPrice']?.toDouble() ?? 0.0,
        foodType: item['foodType'] ?? '',
        phoneNumber: item['phoneNumber'] ?? '',
        workingHours: item['workingHours'] ?? '',
        likes: item['likes']?.toInt() ?? 0,
        address: item['address'] ?? '',
        addressDetail: item['addressDetail'] ?? '',
        latitude: item['latitud'] ?? '',
        longitude: item['longitud'] ?? '');
  }

  List<Restaurant> _filterNearbyRestaurants(
      List<Map<String, dynamic>> data, Position userLocation) {
    return data
        .where((item) => _isNearbyRestaurant(item, userLocation))
        .map((item) => _mapSingleRestaurantData(item, userLocation))
        .toList();
  }

  bool _isNearbyRestaurant(Map<String, dynamic> item, Position userLocation) {
    final restaurantLat = double.parse(item['latitud']);
    final restaurantLong = double.parse(item['longitud']);
    final distance = DistanceCalculator.calculateDistanceInKm(
        userLocation.latitude,
        userLocation.longitude,
        restaurantLat,
        restaurantLong);
    return distance <= 7000;
  }
}

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/location_repository.dart';
import 'package:unifood/repository/restaurant_repository.dart';
import 'package:unifood/utils/distance_calculator.dart';

class RestaurantViewModel {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final LocationRepository _locationRepository = LocationRepository();

  Future<List<Restaurant>> getRestaurants() async {
    return _getRestaurantData(await _getUserLocation());
  }

  Future<Restaurant?> getRestaurantById(String restaurantName) async {
    final userLocation = await _getUserLocation();
    final data = await _restaurantRepository.getRestaurantById(restaurantName);
    return data != null ? _mapSingleRestaurantData(data, userLocation) : null;
  }

  Future<List<Restaurant>> getRestaurantsNearby() async {
    final userLocation = await _getUserLocation();
    final data = await _restaurantRepository.getRestaurants();
    return _filterNearbyRestaurants(data, userLocation);
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
        longitude: item['longitud'] ?? ''
        );
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
    return distance <= 1.5;
  }
}

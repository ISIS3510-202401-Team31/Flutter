import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/location_repository.dart';
import 'package:unifood/repository/restaurant_repository.dart';
import 'package:unifood/utils/distance_calculator.dart';

class RestaurantViewModel {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();
  final LocationRepository _locationRepository = LocationRepository();

  Future<List<Restaurant>> getRestaurants() async {
    return _getRestaurantData(await _getUserLocation());
  }

  Future<Restaurant?> getRestaurantByName(String restaurantName) async {
    final userLocation = await _getUserLocation();
    final data = await _restaurantRepository.getRestaurantByName(restaurantName);
    return data != null ? _mapSingleRestaurantData(data, userLocation) : null;
  }

  Future<List<Restaurant>> getRestaurantsNearby() async {
    final userLocation = await _getUserLocation();
    final data = await _restaurantRepository.getRestaurants();
    return _filterNearbyRestaurants(data, userLocation);
  }

  Future<Position> _getUserLocation() async {
    try {
      return await _locationRepository.getUserLocation();
    } catch (error) {
      print('Error getting user location: $error');
      rethrow;
    }
  }

  Future<List<Restaurant>> _getRestaurantData(Position userLocation) async {
    try {
      final data = await _restaurantRepository.getRestaurants();
      return _mapRestaurantData(data, userLocation);
    } catch (error) {
      print('Error fetching menu items: $error');
      rethrow;
    }
  }

  List<Restaurant> _mapRestaurantData(List<Map<String, dynamic>> data, Position userLocation) {
    return data.map((item) => _mapSingleRestaurantData(item, userLocation)).toList();
  }

  Restaurant _mapSingleRestaurantData(Map<String, dynamic> item, Position userLocation) {
    final restaurantLat = double.parse(item['latitud']);
    final restaurantLong = double.parse(item['longitud']);
    final distance = DistanceCalculator.calculateDistanceInKm(userLocation.latitude, userLocation.longitude, restaurantLat, restaurantLong);

    return Restaurant(
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
      longitude: item['longitud'] ?? '',
    );
  }

  List<Restaurant> _filterNearbyRestaurants(List<Map<String, dynamic>> data, Position userLocation) {
    return data
        .where((item) => _isNearbyRestaurant(item, userLocation))
        .map((item) => _mapSingleRestaurantData(item, userLocation))
        .toList();
  }

  bool _isNearbyRestaurant(Map<String, dynamic> item, Position userLocation) {
    final restaurantLat = double.parse(item['latitud']);
    final restaurantLong = double.parse(item['longitud']);
    final distance = DistanceCalculator.calculateDistanceInKm(userLocation.latitude, userLocation.longitude, restaurantLat, restaurantLong);
    return distance <= 30.5;
  }

  
}

import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'dart:math' as math;

import 'package:unifood/repository/restaurant_repository.dart';

class RestaurantViewModel {
  final RestaurantRepository _restaurantRepository = RestaurantRepository();

  Future<List<Restaurant>> getRestaurants() async {
    try {
      final List<Map<String, dynamic>> data =
          await _restaurantRepository.getRestaurants();

      return data
          .map(
            (item) => Restaurant(
              imageUrl: item['imageURL'] ?? '',
              logoUrl: item['logoURL'] ?? '',
              name: item['name'] ?? '',
              isOpen: item['isOpen'] ?? false,
              distance: item['distance']?.toDouble() ?? 0.0,
              rating: item['rating']?.toDouble() ?? 0.0,
              avgPrice: item['avgPrice']?.toDouble() ?? 0.0,
              foodType: item['foodType'] ?? '',
              phoneNumber: item['phoneNumber'] ?? '',
              workingHours: item['workingHours'] ?? '',
              likes: item['likes']?.toInt() ?? 0, // Cambiado a ?.toInt()
              address: item['address'] ?? '',
              addressDetail: item['addressDetail'] ?? '',
              latitude: item['latitud'] ?? '',
              longitude: item['longitud'] ?? '',
            ),
          )
          .toList();
    } catch (error) {
      print('Error fetching menu items in view model: $error');
      rethrow;
    }
  }

  Future<Restaurant?> getRestaurantByName(String restaurantName) async {
    try {
      final Map<String, dynamic>? data =
          await _restaurantRepository.getRestaurantByName(restaurantName);

      if (data != null) {
        return Restaurant(
          imageUrl: data['imageURL'] ?? '',
          logoUrl: data['logoURL'] ?? '',
          name: data['name'] ?? '',
          isOpen: data['isOpen'] ?? false,
          distance: data['distance']?.toDouble() ?? 0.0,
          rating: data['rating']?.toDouble() ?? 0.0,
          avgPrice: data['avgPrice']?.toDouble() ?? 0.0,
          foodType: data['foodType'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          workingHours: data['workingHours'] ?? '',
          likes: data['likes']?.toInt() ?? 0, // Cambiado a ?.toInt()
          address: data['address'] ?? '',
          addressDetail: data['addressDetail'] ?? '',
          latitude: data['latitud'] ?? '',
          longitude: data['longitud'] ?? '',
        );
      } else {
        return null;
      }
    } catch (error) {
      print('Error fetching restaurant by name in view model: $error');
      rethrow;
    }
  }

  Future<List<Restaurant>> getRestaurantsNearby() async {
    try {
      final Position userLocation =
          await _getUserLocation(); // Obtener la ubicación del usuario
      final List<Map<String, dynamic>> data = await _restaurantRepository
          .getRestaurants(); // Obtener los datos de los restaurantes
      // Filtrar los restaurantes por distancia
      final List<Restaurant> nearbyRestaurants = [];
      for (var item in data) {

        final restaurantLat = double.parse(item['latitud']);
        final restaurantLong = double.parse(item['longitud']);
        final distance = _calculateDistanceInMeters(
            userLocation.latitude, userLocation.longitude, restaurantLat, restaurantLong);
        print(userLocation.latitude);
        print(userLocation.longitude);
        print(restaurantLat);
        print(restaurantLong);
        print(distance);
        if (distance <= 1000000) {
          // Comparar después de esperar la finalización del cálculo de distancia
          nearbyRestaurants.add(
            Restaurant(
              imageUrl: item['imageURL'] ?? '',
              logoUrl: item['logoURL'] ?? '',
              name: item['name'] ?? '',
              isOpen: item['isOpen'] ?? false,
              distance: item['distance']?.toDouble() ?? 0.0,
              rating: item['rating']?.toDouble() ?? 0.0,
              avgPrice: item['avgPrice']?.toDouble() ?? 0.0,
              foodType: item['foodType'] ?? '',
              phoneNumber: item['phoneNumber'] ?? '',
              workingHours: item['workingHours'] ?? '',
              likes: item['likes']?.toInt() ?? 0, // Cambiado a ?.toInt()
              address: item['address'] ?? '',
              addressDetail: item['addressDetail'] ?? '',
              latitude: item['latitud'] ?? '',
              longitude: item['longitud'] ?? '',
            ),
          );
        }
      }

      return nearbyRestaurants;
    } catch (error) {
      print('Error fetching nearby restaurants in view model: $error');
      rethrow;
    }
  }

  // Método privado para obtener la ubicación del usuario
  Future<Position> _getUserLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (error) {
      print('Error getting user location: $error');
      rethrow;
    }
  }



  // Método privado para calcular la distancia en metros entre dos pares de coordenadas
  double _calculateDistanceInMeters(double userLat, double userLong,
      double restaurantLat, double restaurantLong) {
    const int radiusOfEarth = 6371000; // Radio de la Tierra en metros
    final double latDistance = _degreesToRadians(restaurantLat - userLat);
    final double longDistance = _degreesToRadians(restaurantLong - userLong);
    final double a = (math.sin(latDistance / 2) * math.sin(latDistance / 2)) +
        (math.cos(_degreesToRadians(userLat)) *
            math.cos(_degreesToRadians(restaurantLat)) *
            math.sin(longDistance / 2) *
            math.sin(longDistance / 2));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = radiusOfEarth * c;

    return distance;
  }

  // Método privado para convertir grados a radianes
  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

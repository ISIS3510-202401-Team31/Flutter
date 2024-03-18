import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/restaurant_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

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
              likes: item['likes'].toInt() ?? 0,
              address: item['address'] ?? '',
              addressDetail: item['addressDetail'] ?? '',
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
          likes: data['likes'].toInt() ?? 0,
          address: data['address'] ?? '',
          addressDetail: data['addressDetail'] ?? '',
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
        final distance = await _calculateDistance(
            userLocation.latitude, userLocation.longitude, item['address']);
        if (distance <= 2000) {
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
              likes: item['likes'].toInt() ?? 0,
              address: item['address'] ?? '',
              addressDetail: item['addressDetail'] ?? '',
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

  // Método privado para calcular la distancia entre la ubicación del usuario y la dirección del restaurante
  Future<double> _calculateDistance(
      double userLat, double userLong, String restaurantAddress) async {
    try {
      // Llamada a la API de geocodificación de Google para obtener las coordenadas de la dirección del restaurante
      final Uri uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$restaurantAddress&key=AIzaSyAHuj9dpFqM7DGHHE6uCbn4jlnQw86BY2g');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final location = decodedData['results'][0]['geometry']['location'];
        final restaurantLat = location['lat'];
        final restaurantLong = location['lng'];

        // Calcula la distancia entre las coordenadas del usuario y las del restaurante
        final distance = _calculateDistanceInMeters(
            userLat, userLong, restaurantLat, restaurantLong);
        return distance;
      } else {
        throw Exception('Failed to get coordinates for restaurant address');
      }
    } catch (error) {
      print('Error calculating distance: $error');
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

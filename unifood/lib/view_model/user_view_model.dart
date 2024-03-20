import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/location_repository.dart';
import 'package:unifood/repository/user_repository.dart';
import 'package:unifood/utils/distance_calculator.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  final LocationRepository _locationRepository = LocationRepository();
  late Users _user;

  Users get user => _user;

  Future<void> getUser(String userId) async {
    try {
      _user = await _repository.getUser(userId);
      notifyListeners();
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  Future<void> updateUserProfileImage(String userId, File imageFile) async {
    try {
      await _repository.updateUserProfileImage(userId, imageFile);
    } catch (error) {
      // Manejar el error según sea necesario
      print('Error al actualizar la imagen de perfil: $error');
      rethrow;
    }
  }

  Future<Position> _getUserLocation() async {
    try {
      return await _locationRepository.getUserLocation();
    } catch (error) {
      print('Error getting user location: $error');
      rethrow;
    }
  }

  Future<String> getDistanceFromCampus() async {
    final userLocation = await _getUserLocation();
    final campusLat = double.parse('4.6029417');
    final campusLong = double.parse('-74.0653178');
    final distance = DistanceCalculator.calculateDistanceInKm(
        userLocation.latitude, userLocation.longitude, campusLat, campusLong);
    return distance.toStringAsFixed(2);
  }
}

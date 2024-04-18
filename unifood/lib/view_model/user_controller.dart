import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/location_repository.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/user_repository.dart';
import 'package:unifood/utils/distance_calculator.dart';

class UserController extends ChangeNotifier {

  final UserRepository _repository = UserRepository();
  final LocationRepository _locationRepository = LocationRepository();
  late Users _user;

  Users get user => _user;

  Future<void> getUser(String userId) async {
    try {
      _user = await _repository.getUser(userId);
      notifyListeners();
    }  catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUser',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching user in view model: $e');
    }
  }

  Future<void> updateUserProfileImage(String userId, File imageFile) async {
    try {
      await _repository.updateUserProfileImage(userId, imageFile);
    }  catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'updateUserProfileImage',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when updating user profile image in view model: $e');
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
        'function': 'updateUserProfileImage',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when getting user location repository: $e');
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

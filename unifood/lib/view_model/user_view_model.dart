import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
  late Users _user;

  Users get user => _user;

  Future<void> getUser(String userId) async {
    try {
      _user = await _repository.getUser(userId);
      notifyListeners();
    }  catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUser',
      };
      ErrorRepository().saveError(errorInfo);
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
      ErrorRepository().saveError(errorInfo);
      print('Error when updating user profile image in view model: $e');
      rethrow;
    }
  }

}

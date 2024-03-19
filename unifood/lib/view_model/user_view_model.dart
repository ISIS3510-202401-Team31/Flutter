import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();
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

}

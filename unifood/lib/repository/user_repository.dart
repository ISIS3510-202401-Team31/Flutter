import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/shared_preferences.dart';

class UserRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;
  UserRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<Users?> getUserSession() async {
    try {
      final user = await _prefsService.getUser();
      return user;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUserSession',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching user session in repository: $e');
      rethrow;
    }
  }

  Future<Users> getUser(String userId) async {
    try {
      final docSnapshot = await _firestoreServiceAdapter.getDocumentById('users', userId);
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return Users(
          uid: userId,
          name: data['name'],
          email: data['email'],
          profileImageUrl: data['profileImageUrl'],
        );
      } else {
        throw Exception('User not found');
      }
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getUser',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching user in repository: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfileImage(String userId, File imageFile) async {
    try {
      String fileName = 'profile_$userId.jpg';
      Reference storageReference = _firestoreServiceAdapter.getStorageReference('profile_images/$fileName');
      TaskSnapshot uploadTask = await storageReference.putFile(imageFile);
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _updateImageUrlInDatabase(userId, imageUrl);
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'updateUserProfileImage',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when updating user profile image in repository: $e');
      rethrow;
    }
  }

  Future<void> _updateImageUrlInDatabase(String userId, String imageUrl) async {
    try {
      await _firestoreServiceAdapter.updateDocumentData('users', userId, {'profileImageUrl': imageUrl});
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'updateImageUrlInDatabase',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when updating image URL in database: $e');
      rethrow;
    }
  }
}

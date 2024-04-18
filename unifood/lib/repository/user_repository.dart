import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  UserRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<Users?> getUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid != null) {
      return getUser(uid);
    }
    return null;
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

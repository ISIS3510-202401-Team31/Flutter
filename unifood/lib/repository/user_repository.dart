import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifood/data/firebase_service.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';

class UserRepository {
  FirebaseFirestore databaseInstance = FirebaseService().database;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
      final snapshot =
          await databaseInstance.collection('users').doc(userId).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return Users(
        uid: userId,
        name: data['name'],
        email: data['email'],
        profileImageUrl: data['profileImageUrl'],
      );
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
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

      Reference storageReference =
          _storage.ref().child('profile_images').child(fileName);

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
      final userRef = databaseInstance.collection('users').doc(userId);
      await userRef.update({'profileImageUrl': imageUrl});
    }  catch (e, stackTrace) {
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

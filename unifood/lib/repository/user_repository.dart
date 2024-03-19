import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifood/data/firebase_service.dart';
import 'package:unifood/model/user_entity.dart';

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
      final snapshot = await databaseInstance.collection('users').doc(userId).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return Users(
        uid: userId,
        name: data['name'],
        email: data['email'],
        profileImageUrl: data['profileImageUrl'],
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUserProfileImage(String userId, File imageFile) async {
    try {
      // Subir la imagen al almacenamiento de Firebase
      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      await ref.putFile(imageFile);

      // Obtener la URL de descarga de la imagen
      final imageUrl = await ref.getDownloadURL();

      // Actualizar la URL de la imagen de perfil en la base de datos
      await databaseInstance.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    } catch (error) {
      // Manejar el error de manera apropiada
      print('Error al actualizar la imagen de perfil: $error');
      throw Exception('Error al actualizar la imagen de perfil');
    }
  }
}

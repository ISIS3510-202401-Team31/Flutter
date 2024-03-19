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
      // Genera un nombre de archivo único para la imagen
      String fileName = 'profile_$userId.jpg';

      // Referencia al almacenamiento de Firebase
      Reference storageReference = _storage.ref().child('profile_images').child(fileName);

      // Sube la imagen al almacenamiento de Firebase
      TaskSnapshot uploadTask = await storageReference.putFile(imageFile);
      String imageUrl = await uploadTask.ref.getDownloadURL();

      // Actualiza la URL de la imagen en la base de datos
      await _updateImageUrlInDatabase(userId, imageUrl);
    } catch (error) {
      print('Error al subir la imagen: $error');
      throw error;
    }
  }

  Future<void> _updateImageUrlInDatabase(String userId, String imageUrl) async {
    try {
      // Obtén la referencia al documento del usuario en Firestore
      final userRef = databaseInstance.collection('users').doc(userId);

      // Actualiza el campo de la URL de la imagen
      await userRef.update({'profileImageUrl': imageUrl});
    } catch (error) {
      print('Error al actualizar la URL de la imagen en la base de datos: $error');
      throw error;
    }
  }
}

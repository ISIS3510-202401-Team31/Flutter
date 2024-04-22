import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unifood/data/firebase_service.dart';

class FirestoreServiceAdapter {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static final FirebaseService _firebaseService = FirebaseService();
  static final FirestoreServiceAdapter _instance =
      FirestoreServiceAdapter._internal(_firebaseService);

  factory FirestoreServiceAdapter() {
    return _instance;
  }

  FirestoreServiceAdapter._internal(FirebaseService firebaseService)
      : _firestore = firebaseService.database;

  Future<QuerySnapshot<Map<String, dynamic>>> getCollectionDocuments(
      String collectionPath) async {
    return await _firestore.collection(collectionPath).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String collectionPath, String documentId) async {
    return await _firestore.collection(collectionPath).doc(documentId).get();
  }

  Future<void> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      throw Exception('Error adding document to $collectionPath: $e');
    }
  }

  Future<void> addUser(
      Map<String, dynamic> data, String id) async {
    try {
      await _firestore.collection("users").doc(id).set(data);
    } catch (e) {
      throw Exception('Error adding document to users: $e');
    }
  }

  Future<void> updateDocumentData(String collectionPath, String documentId,
      Map<String, dynamic> data) {
    return _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  Reference getStorageReference(String path) {
    return _storage.ref().child(path);
  }
}

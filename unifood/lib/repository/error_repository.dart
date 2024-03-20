import 'package:cloud_firestore/cloud_firestore.dart';

class ErrorRepository {
  final CollectionReference _errorsCollection =
      FirebaseFirestore.instance.collection('errors');

  Future<void> saveError(Map<String, dynamic> errorInfo) async {
    try {
      await _errorsCollection.add(errorInfo);
    } catch (e) {
      throw Exception('Error al guardar el error en la base de datos: $e');
    }
  }
}

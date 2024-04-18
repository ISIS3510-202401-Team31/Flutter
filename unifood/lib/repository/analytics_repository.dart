import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsRepository {
  final CollectionReference _errorsCollection =
      FirebaseFirestore.instance.collection('errors');

  final CollectionReference _featuresCollection =
      FirebaseFirestore.instance.collection('features');

  Future<void> saveError(Map<String, dynamic> errorInfo) async {
    try {
      await _errorsCollection.add(errorInfo);
    } catch (e) {
      throw Exception('Error al guardar el error en la base de datos: $e');
    }
  }

  Future<void> saveEvent(Map<String, dynamic> eventInfo) async {
    try {
      await _featuresCollection.add(eventInfo);
    } catch (e) {
      throw Exception('Error al guardar el evento en la base de datos: $e');
    }
  }
}

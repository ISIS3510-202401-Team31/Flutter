import 'package:unifood/data/firebase_service_adapter.dart';

class AnalyticsRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  AnalyticsRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<void> saveError(Map<String, dynamic> errorInfo) async {
    try {
      await _firestoreServiceAdapter.addDocument('errors', errorInfo);
    } catch (e) {
      throw Exception('Error saving error to the database: $e');
    }
  }

  Future<void> saveEvent(Map<String, dynamic> eventInfo) async {
    try {
      await _firestoreServiceAdapter.addDocument('features', eventInfo);
    } catch (e) {
      throw Exception('Error saving event to the database: $e');
    }
  }
}

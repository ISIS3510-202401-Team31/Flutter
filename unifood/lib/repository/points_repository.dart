import 'dart:async';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/data/firebase_service_adapter.dart';

class PointsRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  PointsRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<List<Map<String, dynamic>>> getPoints() async {
    try {
      final querySnapshot = await _firestoreServiceAdapter.getCollectionDocuments('points');
      List<Map<String, dynamic>> points = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return data;
        }).toList(); 
      return points;
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getPoints',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error fetching points: $e');
      rethrow; // Or handle the error appropriately.
    }
  }
}

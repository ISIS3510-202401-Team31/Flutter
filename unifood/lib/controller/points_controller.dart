import 'dart:async';
import 'package:unifood/model/points_entity.dart';
import 'package:unifood/repository/points_repository.dart';
import 'package:unifood/repository/analytics_repository.dart';

class PointsController {
  final PointsRepository _pointsRepository = PointsRepository();

  Future<List<Points>> fetchPoints() async {
    try {
      // Fetch the raw data from the repository
      List<Map<String, dynamic>> rawData = await _pointsRepository.getPoints();
      // Map the raw data to a list of Points objects
      List<Points> pointsList = rawData.map((data) {
        // Assuming all data fields are non-nullable and properly formatted
        return Points(
          url: data['url'] ?? '',
          available: data['available']?.toInt() ?? 0,
          earned: data['earned']?.toInt() ?? 0,
          redeemed: data['redeemed']?.toInt() ?? 0
        );
      }).toList();

      return pointsList;
    } catch (e, stackTrace) {
      // Log the error
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'fetchPoints',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching points: $e');
      rethrow; // Rethrow the error to be handled further up the chain
    }
  }
}

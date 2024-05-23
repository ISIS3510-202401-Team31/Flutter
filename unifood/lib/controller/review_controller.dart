import 'dart:async';

import 'package:unifood/model/review_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/review_repository.dart';

class ReviewController {
  final ReviewRepository _reviewRepository = ReviewRepository();

  final StreamController<List<Review?>> _reviewsByIdController =
      StreamController<List<Review?>>.broadcast();

  StreamController<List<Review?>> _reviewsByUserIdController =
      StreamController<List<Review?>>.broadcast();

  ReviewController() {
    _reviewsByUserIdController = StreamController<List<Review>>.broadcast();
    getReviewsByUserId();
  }

  Stream<List<Review?>> get reviewsByRestaurantId =>
      _reviewsByIdController.stream;

  Stream<List<Review?>> get reviewsByUserId =>
      _reviewsByUserIdController.stream;

  void dispose() {
    _reviewsByIdController.close();
  }

  Future<void> getReviewsByRestaurantId(String restaurantId) async {
    try {
      final List<Map<String, dynamic>> data =
          await _reviewRepository.getReviewsByRestaurantId(restaurantId);

      final reviews = data
          .map(
            (item) => Review(
              id: item['docId'],
              userImage: item['userImage'],
              name: item['name'],
              comment: item['comment'],
              rating: item['rating'].toDouble(),
            ),
          )
          .toList();
      _reviewsByIdController.sink.add(reviews);
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by id in view model: $e');
      rethrow;
    }
  }

  Future<List<Review>> getReviewsByPlateId(
      String plateId, String restaurantId) async {
    try {
      final List<Map<String, dynamic>> data =
          await _reviewRepository.getReviewsByPlateId(plateId, restaurantId);

      return data
          .map(
            (item) => Review(
              id: item['docId'],
              userImage: item['userImage'],
              name: item['name'],
              comment: item['comment'],
              rating: item['rating'].toDouble(),
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByPlateId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by plate id in view model: $e');
      rethrow;
    }
  }

  Future<void> saveReview(String restaurantId, String restaurantImage,
      String restaurantName, int rating, String review) async {
    try {
      await _reviewRepository.saveReview(
          restaurantId, restaurantImage, restaurantName, rating, review);
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'saveReview',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when saving review: $e');
      rethrow;
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      // Lógica para eliminar el review
      await _reviewRepository.deleteReview(reviewId);
      // Actualizar la lista de reviews
      await getReviewsByUserId();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'deleteReview',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when deleting review: $e');
      rethrow;
    }
  }

  Future<void> getReviewsByUserId() async {
    try {
      final List<Map<String, dynamic>> data =
          await _reviewRepository.getReviewsByUserId();

      List<Review> reviews = data
          .map(
            (item) => Review(
              id: item['docId'],
              userImage: item['userImage'] ?? "",
              name: item['name'] ?? "",
              comment: item['comment'] ?? "",
              rating: item['rating'].toDouble() ?? 0.0,
            ),
          )
          .toList();
      _reviewsByUserIdController.sink.add(reviews);
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByUserId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by user id in view model: $e');
      rethrow;
    }
  }
}

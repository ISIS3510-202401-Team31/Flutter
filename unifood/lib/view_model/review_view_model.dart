import 'package:unifood/model/review_entity.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/review_repository.dart';

class ReviewViewModel {
  final ReviewRepository _reviewRepository = ReviewRepository();

  Future<List<Review>> getReviewsByRestaurantId(String restaurantId) async {
    try {
      final List<Map<String, dynamic>> data =
          await _reviewRepository.getReviewsByRestaurantId(restaurantId);
      

      return data
          .map(
            (item) => Review(
              userImage: item['userImage'],
              name: item['name'],
              comment: item['comment'],
              rating: item['rating'].toDouble(),
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      // Guardar la información del error en la base de datos
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByRestaurantId',
      };
      ErrorRepository().saveError(errorInfo);
      print('Error when fetching reviews by id in view model: $e');
      rethrow;
    }
  }
}

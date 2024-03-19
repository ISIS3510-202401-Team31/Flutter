import 'package:unifood/model/review_entity.dart';
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
    } catch (error) {
      print('Error fetching menu items in view model: $error');
      rethrow;
    }
  }
}

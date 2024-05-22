import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/shared_preferences.dart';

class ReviewRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  ReviewRepository() : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<List<Map<String, dynamic>>> getReviewsByRestaurantId(
      String restaurantId) async {
    try {
      final querySnapshot = await _firestoreServiceAdapter
          .getCollectionDocuments('restaurants/$restaurantId/reviews');
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByRestaurantId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by restaurant id in repository: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getReviewsByPlateId(
      String plateId, String restaurantId) async {
    try {
      final querySnapshot =
          await _firestoreServiceAdapter.getCollectionDocuments(
              'restaurants/$restaurantId/plates/$plateId/reviews');
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByPlateId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by plate id in repository: $e');
      rethrow;
    }
  }

  Future<void> saveReview(
      String restaurantId, String restaurantImage, String restaurantName, int rating, String review) async {
    try {
      Users? user = await SharedPreferencesService().getUser();

      Map<String, dynamic> reviewData = {
        'restaurantId': restaurantId,
        'rating': rating,
        'review': review,
      };

      await SharedPreferencesService().saveReview(user!.uid, reviewData);

      await _firestoreServiceAdapter.addDocument('users/${user.uid}/reviews', {
        'restaurantId': restaurantId,
        'comment': review,
        'rating': rating,
        'name' : restaurantName,
        'userImage' : restaurantImage,
      });

      await _firestoreServiceAdapter
          .addDocument('restaurants/$restaurantId/reviews', {
        'name': user.name,
        'comment': review,
        'rating': rating,
        'userImage': user.profileImageUrl,
      });
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

  Future<List<Map<String, dynamic>>> getReviewsByUserId() async {
    try {
      Users? user = await SharedPreferencesService().getUser();
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final querySnapshot = await _firestoreServiceAdapter
          .getCollectionDocuments('users/${user.uid}/reviews');
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      final errorInfo = {
        'error': e.toString(),
        'stacktrace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        'function': 'getReviewsByUserId',
      };
      AnalyticsRepository().saveError(errorInfo);
      print('Error when fetching reviews by user id in repository: $e');
      rethrow;
    }
  }
}

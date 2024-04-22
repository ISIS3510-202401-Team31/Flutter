import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/data/firebase_service_adapter.dart';
import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/user_repository.dart';

class PreferencesRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;

  PreferencesRepository()
      : _firestoreServiceAdapter = FirestoreServiceAdapter();

  Future<PreferencesEntity?> getUserPreferences() async {
    try {
      final user = await UserRepository().getUserSession();
      if (user != null) {
        final querySnapshot = await _firestoreServiceAdapter
            .getCollectionDocuments('users/${user.uid}/preferences', limit: 1);

        if (querySnapshot.docs.isNotEmpty) {
          final docSnapshot = querySnapshot.docs.first;

          if (docSnapshot.exists) {
            return PreferencesEntity.fromMap(docSnapshot.data(),
                isUserPreferences: true);
          } else {
            print(
                "User preferences document is empty for user id: ${user.uid}");
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'getUserPreferences');
      return null;
    }
  }

  Future<void> updateUserPreferences(PreferencesEntity preferences) async {
    try {
      final user = await UserRepository().getUserSession();
      if (user != null) {
        await _firestoreServiceAdapter.setOrUpdateDocument(
            'users/${user.uid}/preferences',
            'preferences',
            {
              'tastes': preferences.tastes.map((item) => item.text).toList(),
              'restrictions':
                  preferences.restrictions.map((item) => item.text).toList(),
              'priceRange': preferences.priceRange.toMap(),
            },
            createIfMissing: true);
        print('Preferences updated for user id: ${user.uid}');
      } else {
        throw Exception('User session not found');
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'updateUserPreferences');
      rethrow;
    }
  }

  void _handleError(dynamic e, StackTrace stackTrace, String functionContext) {
    final errorInfo = {
      'error': e.toString(),
      'stacktrace': stackTrace.toString(),
      'timestamp': DateTime.now(),
      'function': functionContext,
    };

    AnalyticsRepository().saveError(errorInfo);
    print('Error in PreferencesRepository - $functionContext: $e');
  }
}

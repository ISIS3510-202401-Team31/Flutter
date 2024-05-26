import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/user_repository.dart';
import 'package:unifood/data/firebase_service_adapter.dart';

class PreferencesRepository {
  final FirestoreServiceAdapter _firestoreServiceAdapter;
  final UserRepository _userRepository;
  final AnalyticsRepository _analyticsRepository;

  PreferencesRepository()
      : _firestoreServiceAdapter = FirestoreServiceAdapter(),
        _userRepository = UserRepository(),
        _analyticsRepository = AnalyticsRepository();

  Future<PreferencesEntity?> getCommonPreferences() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestoreServiceAdapter.getDocumentById(
              'preferences', 'oqwTeOFRkxL6VPPrO9vH');

      if (docSnapshot.exists && docSnapshot.data() != null) {
        return PreferencesEntity.fromMap(docSnapshot.data()!);
      } else {
        print("Document 'common_preferences' not found or is empty.");
        return null;
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'getCommonPreferences');
      rethrow;
    }
  }

  Future<PreferencesEntity?> getUserPreferences() async {
    try {
      final user = await _userRepository.getUserSession();
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
      final user = await _userRepository.getUserSession();
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

    _analyticsRepository.saveError(errorInfo);
    print('Error in PreferencesRepository - $functionContext: $e');
  }
}

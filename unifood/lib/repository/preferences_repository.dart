import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/data/firebase_service.dart';
import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/repository/error_repository.dart';

class PreferencesRepository {
  final FirebaseFirestore databaseInstance = FirebaseService().database;

  Future<PreferencesEntity?> getCommonPreferences() async {
    try {
      // Assuming 'common_preferences' is your document ID or use the first document's ID.
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await databaseInstance
              .collection('preferences')
              .doc('oqwTeOFRkxL6VPPrO9vH')
              .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        // Directly parse the document's data into a PreferencesEntity
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

  Future<void> updatePreferencesByUserId(
      String userId, PreferencesEntity preferences) async {
    try {
      DocumentReference userPreferencesRef = databaseInstance
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('your_preferences_doc_id'); // Use the correct document ID here

      Map<String, dynamic> updateData = {
        'tastes': preferences.tastes.map((item) => item.text).toList(),
        'priceRange': preferences.priceRange.toMap(),
        // Add other fields if needed
      };

      await userPreferencesRef.update(updateData);
      print('Preferences updated for user id: $userId');
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'updatePreferencesByUserId');
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

    ErrorRepository().saveError(errorInfo);
    print('Error in PreferencesRepository - $functionContext: $e');
  }
}

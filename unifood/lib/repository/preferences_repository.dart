import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifood/data/firebase_service.dart';
import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/user_repository.dart';

class PreferencesRepository {
  final FirebaseFirestore databaseInstance = FirebaseService().database;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<PreferencesEntity?> getUserPreferences() async {
    try {
      final user = await UserRepository().getUserSession();
      if (user != null) {
        // Fetch the user preferences subcollection
        final preferencesCollection = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('preferences');
        // Query the subcollection to get the single document snapshot
        final querySnapshot = await preferencesCollection.limit(1).get();

        // Check if there's at least one document in the collection
        if (querySnapshot.docs.isNotEmpty) {
          final docSnapshot = querySnapshot.docs.first;

          if (docSnapshot.exists && docSnapshot.data() != null) {
            return PreferencesEntity.fromMap(docSnapshot.data()!,
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
        // Reference to the user's preferences document
        DocumentReference preferencesDocRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('preferences')
            .doc(
                'preferences'); // Assuming a single document called 'preferences'

        // Check if the document already exists
        DocumentSnapshot docSnapshot = await preferencesDocRef.get();
        if (!docSnapshot.exists) {
          // Document does not exist, create a new one with the provided preferences
          await preferencesDocRef.set({
            'tastes': preferences.tastes.map((item) => item.text).toList(),
            'restrictions':
                preferences.restrictions.map((item) => item.text).toList(),
            'priceRange': preferences.priceRange.toMap(),
          });
          print('New preferences document created for user id: ${user.uid}');
        } else {
          // Document exists, update it with the provided preferences
          await preferencesDocRef.update({
            'tastes': preferences.tastes.map((item) => item.text).toList(),
            'restrictions':
                preferences.restrictions.map((item) => item.text).toList(),
            'priceRange': preferences.priceRange.toMap(),
          });
          print('Preferences updated for user id: ${user.uid}');
        }
      } else {
        throw Exception('User session not found');
      }
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

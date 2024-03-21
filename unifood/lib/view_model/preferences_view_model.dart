import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/repository/preferences_repository.dart';
import 'package:unifood/repository/error_repository.dart';

class PreferencesViewModel {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();

  Future<PreferencesEntity?> loadCommonPreferences() async {
    try {
      return await _preferencesRepository.getCommonPreferences();
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'loadCommonPreferences');
      rethrow;
    }
  }

  void _handleError(dynamic e, StackTrace stackTrace, String functionContext) {
    // Log or save the error information in the database
    final errorInfo = {
      'error': e.toString(),
      'stacktrace': stackTrace.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'function': functionContext,
    };
    ErrorRepository().saveError(errorInfo);
    print('Error in PreferencesViewModel - $functionContext: $e');
  }

  Future<void> updateUserPreferences(
      String userId, PreferencesEntity preferences) async {
    try {
      await _preferencesRepository.updatePreferencesByUserId(
          userId, preferences);
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'updateUserPreferences');
      rethrow;
    }
  }
}

import 'package:unifood/model/preferences_entity.dart';
import 'package:unifood/repository/preferences_repository.dart';
import 'package:unifood/repository/error_repository.dart';
import 'package:unifood/repository/user_repository.dart';

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

  Future<PreferencesEntity?> loadUserPreferences() async {
    try {
      return await _preferencesRepository.getUserPreferences();
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'loadUserPreferences');
      return null;
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

  Future<void> updateUserPreferences(PreferencesEntity preferences) async {
    try {
      final user = await UserRepository().getUserSession();
      if (user != null) {
        await _preferencesRepository.updateUserPreferences(preferences);
      } else {
        throw Exception('User session not found');
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'updateUserPreferences');
      rethrow;
    }
  }
}

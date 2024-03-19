import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifood/model/user_entity.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _prefs;

  static Future<SharedPreferencesService> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesService();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveUser(Users user) async {
    _prefs!.setString('uid', user.uid);
    _prefs!.setString('email', user.email);
    _prefs!.setString('name', user.name);
    _prefs!.setString('profileImageUrl', user.profileImageUrl ?? '');
  }

  Future<void> clearUser() async {
    await _prefs!.clear();
  }
}

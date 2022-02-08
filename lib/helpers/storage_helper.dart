import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static SharedPreferences? _prefs;

  static Future<dynamic> _getInstance() async =>
      _prefs = await SharedPreferences.getInstance();

  static Future<String?> getString(String key) async {
    await _getInstance();
    return _prefs!.getString(key);
  }

  static Future<bool> getBoolean(String key, bool defaultValue) async {
    try {
      final SharedPreferences sharedPreferences = await _getInstance();
      final value = sharedPreferences.getBool(key);
      if (value == null) {
        return defaultValue;
      }
      return value;
    } catch (_) {
      return defaultValue;
    }
  }

  static void setString(String key, String value) async {
    // if (key.isEmpty || value.isEmpty) return;
    final SharedPreferences preferences = await _getInstance();
    preferences.setString(key, value);
  }

  static Future<void> setBoolean(String key, bool value) async {
    final SharedPreferences preferences = await _getInstance();
    await preferences.setBool(key, value);
  }

  static void remove(String key) async {
    final SharedPreferences preferences = await _getInstance();
    if (preferences.containsKey(key)) {
      preferences.remove(key);
    }
  }
}

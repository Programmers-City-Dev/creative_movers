import 'dart:developer';

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
        log('BOOL:$value');
        return defaultValue;
      }
      return value;

    } catch (_) {
      log('ON ERROR $_');
      return defaultValue;
    }
  }

  static void setString(String key, String value) async {
    // if (key.isEmpty || value.isEmpty) return;
    final SharedPreferences preferences = await _getInstance();
    var succes = await preferences.setString(key, value);
    log('TOKEN SET $succes');
  }

  static Future<void> setBoolean(String key, bool value) async {
    final SharedPreferences preferences = await _getInstance();

    await preferences.setBool(key, value);

    // TODO
  }

  static void remove(String key) async {
    final SharedPreferences preferences = await _getInstance();
    if (preferences.containsKey(key)) {
      preferences.remove(key);
    }
  }

  static void clear() async {
    final SharedPreferences preferences = await _getInstance();
      preferences.clear();

  }

}

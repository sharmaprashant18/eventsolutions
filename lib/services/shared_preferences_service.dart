import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Factory constructor for global access
  factory SharedPreferencesService() {
    // Lazily initialize the instance
    _instance ??= SharedPreferencesService._internal();
    return _instance!;
  }
  SharedPreferencesService._internal();

  // Static instance variable (lazily initialized)
  static SharedPreferencesService? _instance;

  // SharedPreferences instance
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences (lazily)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> clearAll() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Method to get the instance of SharedPreferences
  SharedPreferences get prefs {
    return _prefs;
  }

  // Method to set a string value
  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await prefs.setDouble(key, value);
  }

  // Method to get a string value
  String? getString(String key) => prefs.getString(key);

  // Method to set an integer value
  Future<void> setInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  // Method to get an integer value
  int? getInt(String key) => prefs.getInt(key);

  // Method to set a boolean value
  Future<void> setBool(String key, {required bool value}) async {
    await prefs.setBool(key, value);
  }

  // Method to get a boolean value
  bool? getBool(String key) => prefs.getBool(key);

  double? getDouble(String key) => prefs.getDouble(key);
  // Method to set dynamic data (can be String, int, bool, double)
  Future<void> setDynamic(String key, dynamic value) async {
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }

  // Method to get dynamic data (returns any type)
  dynamic get(String key) =>
      prefs.get(key); // This returns the type based on what was stored

  // Method to remove a specific key
  Future<void> remove(String key) async {
    await prefs.remove(key);
  }

  // Method to clear all preferences
  Future<void> clear() async {
    await prefs.clear();
  }
}

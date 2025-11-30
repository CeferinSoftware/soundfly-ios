import 'package:shared_preferences/shared_preferences.dart';

/// Storage Helper utility class
/// 
/// Provides methods for storing and retrieving data from SharedPreferences.
class StorageHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageHelper not initialized. Call StorageHelper.init() first.');
    }
    return _prefs!;
  }

  // ===========================================
  // STRING OPERATIONS
  // ===========================================

  /// Save string value
  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  /// Get string value
  static String? getString(String key) {
    return prefs.getString(key);
  }

  // ===========================================
  // INT OPERATIONS
  // ===========================================

  /// Save int value
  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  /// Get int value
  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  // ===========================================
  // DOUBLE OPERATIONS
  // ===========================================

  /// Save double value
  static Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  /// Get double value
  static double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // ===========================================
  // BOOL OPERATIONS
  // ===========================================

  /// Save bool value
  static Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  /// Get bool value
  static bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // ===========================================
  // STRING LIST OPERATIONS
  // ===========================================

  /// Save string list
  static Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  /// Get string list
  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // ===========================================
  // UTILITY OPERATIONS
  // ===========================================

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  /// Clear all data
  static Future<bool> clear() async {
    return await prefs.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  /// Get all keys
  static Set<String> getKeys() {
    return prefs.getKeys();
  }
}

/// Storage keys constants
class StorageKeys {
  static const String fcmToken = 'fcm_token';
  static const String isFirstLaunch = 'is_first_launch';
  static const String lastVisitedUrl = 'last_visited_url';
  static const String userPreferences = 'user_preferences';
  static const String darkModeEnabled = 'dark_mode_enabled';
  static const String notificationsEnabled = 'notifications_enabled';
}

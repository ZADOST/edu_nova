import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthDb {
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';

  final SharedPreferences _prefs;

  LocalAuthDb(this._prefs);

  // Initialize DB instance
  static Future<LocalAuthDb> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalAuthDb(prefs);
  }

  // Save user session after successful API login
  Future<void> saveSession({
    required String token,
    required String role,
    required String userId,
  }) async {
    await _prefs.setString(_tokenKey, token);
    await _prefs.setString(_roleKey, role);
    await _prefs.setString(_userIdKey, userId);
  }

  // Retrieve current role for routing
  String? get userRole => _prefs.getString(_roleKey);

  // Retrieve auth token for API requests
  String? get authToken => _prefs.getString(_tokenKey);

  // Check if user is logged in
  bool get isLoggedIn => _prefs.getString(_tokenKey) != null && _prefs.getString(_tokenKey)!.isNotEmpty;

  // Clear DB on logout
  Future<void> clearSession() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_roleKey);
    await _prefs.remove(_userIdKey);
  }
}
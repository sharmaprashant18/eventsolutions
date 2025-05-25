import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class TokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  Future<void> saveAccessToken(String token,
      {int expiresInSeconds = 3600}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    // final expiryTimestamp = DateTime.now()
    //     .add(Duration(seconds: expiresInSeconds))
    //     .millisecondsSinceEpoch;
    // await prefs.setInt(_tokenExpiryKey, expiryTimestamp);
    debugPrint('Token saved. Expires in $expiresInSeconds seconds');
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
    debugPrint('Refresh token saved');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    if (token == null) {
      debugPrint('No access token found');
      return null;
    }
    // if (await isTokenExpired()) {
    //   debugPrint('Access token has expired');
    //   return null;
    // }
    debugPrint('Token retrieved: $token');
    return token;
  }

  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimestamp = prefs.getInt(_tokenExpiryKey);
    if (expiryTimestamp == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch;
    return now >= expiryTimestamp;
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_tokenExpiryKey);
    debugPrint('Access token cleared');
  }

  Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshTokenKey);
    debugPrint('Refresh token cleared');
  }

  Future<void> clearAllTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
    debugPrint('All tokens cleared');
  }
}

import 'package:vocary/core/storage.dart';

class AuthController {
  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await Storage.save(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    return Storage.get(_tokenKey);
  }

  static Future<void> clearToken() async {
    await Storage.remove(_tokenKey);
  }

  static Future<bool> isAuthenticated() async {
    return (await getToken()) != null;
  }
}

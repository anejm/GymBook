import '../services/auth_service.dart';

class CurrentUser {
  static String? _cachedId;

  static Future<String> get id async {
    if (_cachedId != null) return _cachedId!;

    final id = await AuthService.getUserId();

    if (id == null) {
      throw Exception('No user logged in');
    }

    _cachedId = id;
    return id;
  }

  static void clear() {
    _cachedId = null;
  }
}
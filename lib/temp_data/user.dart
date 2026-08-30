import '../services/auth_service.dart';

class CurrentUser {
  static Future<String>? _future;

  static Future<String> get id {
    return _future ??= _load();
  }

  static Future<String> _load() async {
    final id = await AuthService.getUserId();
    if (id == null) {
      _future = null;
      throw Exception('No user logged in');
    }
    return id;
  }

  static void clear() {
    _future = null;
  }
}
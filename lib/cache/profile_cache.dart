import 'package:flutter/foundation.dart';

import '../../models/profile.dart';
import '../services/profile_service.dart';
import '../temp_data/user.dart';

class ProfileCache extends ChangeNotifier {
  ProfileCache._();
  static final instance = ProfileCache._();

  UserProfile? profile;
  bool isLoading = false;
  Object? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userId = await CurrentUser.id;
      profile = await ProfileService.getProfile(userId: userId);
    } catch (e) {
      error = e;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load();

  void clear() {
    profile = null;
    isLoading = false;
    error = null;
    notifyListeners();
  }
}
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
  String? email;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final userId = await CurrentUser.id;

      final profileFuture = ProfileService.getProfile(userId: userId);
      final emailFuture = ProfileService.getEmail(userId: userId);

      profile = await profileFuture;
      email = await emailFuture;
    } catch (e) {
      error = e;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load();

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required double? weightKg,
    required double? heightCm,
    required DateTime? birthDate,
  }) async {
    final userId = await CurrentUser.id;
    profile = await ProfileService.updateProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      weightKg: weightKg,
      heightCm: heightCm,
      birthDate: birthDate,
    );
    notifyListeners();
  }

  Future<void> updateEmail(String email) async {
    final userId = await CurrentUser.id;
    await ProfileService.updateEmail(userId: userId, email: email);
    notifyListeners();
  }


  void clear() {
    profile = null;
    isLoading = false;
    error = null;
    notifyListeners();
  }
}
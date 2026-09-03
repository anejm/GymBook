import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WorkoutDraftService {
  static const String _draftKey = 'active_workout';

  static Future<void> saveDraft({
    required String workoutName,
    required DateTime startedAt,
    required List<Map<String, dynamic>> exercises,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final draft = {
      'workoutName': workoutName,
      'startedAt': startedAt.toIso8601String(),
      'exercises': exercises,
    };

    await prefs.setString(
      _draftKey,
      jsonEncode(draft),
    );
  }

  static Future<Map<String, dynamic>?> loadDraft() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(_draftKey);

    if (json == null) {
      return null;
    }

    try {
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      await clearDraft();
      return null;
    }
  }

  static Future<bool> hasDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_draftKey);
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_draftKey);
  }
}
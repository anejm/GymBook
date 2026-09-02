import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCache extends ChangeNotifier {
  SettingsCache._();

  static final instance = SettingsCache._();

  bool darkMode = false;
  double textScale = 1.0;

  static const String _darkModeKey = 'dark_mode';
  static const String _textScaleKey = 'text_scale';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    darkMode = prefs.getBool(_darkModeKey) ?? false;
    textScale = prefs.getDouble(_textScaleKey) ?? 1.0;

    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);

    notifyListeners();
  }

  Future<void> setTextScale(double value) async {
    textScale = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, value);

    notifyListeners();
  }
}
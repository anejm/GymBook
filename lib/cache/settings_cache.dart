import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCache extends ChangeNotifier {
  SettingsCache._();
  static final instance = SettingsCache._();

  bool _darkMode = false;
  double _textScale = 1.0;

  bool get darkMode => _darkMode;
  double get textScale => _textScale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('dark_mode') ?? false;
    _textScale = prefs.getDouble('text_scale') ?? 1.0;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();
    (await SharedPreferences.getInstance()).setBool('dark_mode', value);
  }

  Future<void> setTextScale(double value) async {
    _textScale = value;
    notifyListeners();
    (await SharedPreferences.getInstance()).setDouble('text_scale', value);
  }

  void clear() {
    _darkMode = false;
    _textScale = 1.0;
    notifyListeners();
  }
}
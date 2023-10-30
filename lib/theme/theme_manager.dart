import 'package:flutter/material.dart';

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeModeNotifier({ThemeMode initialThemeMode = ThemeMode.system})
      : _themeMode = initialThemeMode;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode newThemeMode) {
    _themeMode = newThemeMode;
    notifyListeners();
  }
}


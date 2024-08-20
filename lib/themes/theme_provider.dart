import 'package:flutter/material.dart';
import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  // Default to dark mode
  ThemeProvider({bool isDarkMode = true})
      : _themeData = isDarkMode ? darkMode : lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners(); // This ensures the UI updates when the theme changes
  }
}

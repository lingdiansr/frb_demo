import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}

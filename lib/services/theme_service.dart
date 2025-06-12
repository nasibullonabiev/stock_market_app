import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeService {
  static const _themeBox = 'themeBox';
  static const _isDarkKey = 'isDarkMode';

  final Box _box = Hive.box(_themeBox);

  bool get isDarkMode => _box.get(_isDarkKey, defaultValue: false);

  ThemeMode get currentTheme =>
      isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    _box.put(_isDarkKey, !isDarkMode);
  }
}

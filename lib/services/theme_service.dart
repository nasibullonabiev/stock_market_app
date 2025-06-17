import 'package:hive/hive.dart';

class ThemeService {
  static const String _themeBox = 'themeBox';
  static const String _isDarkKey = 'isDarkMode';

  final Box _box = Hive.box(_themeBox);

  bool get isDarkMode => _box.get(_isDarkKey, defaultValue: false) as bool;

  void switchTheme() {
    bool newMode = !isDarkMode;
    _box.put(_isDarkKey, newMode);
  }
}

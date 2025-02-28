import 'package:vocary/app/signals/theme_signal.dart';
import 'package:vocary/core/storage.dart';

class ThemeController {
  static const String _themeKey = 'themeId';

  static Future<void> loadTheme() async {
    final savedTheme = await Storage.get<String>(_themeKey);
    if (savedTheme != null) {
      ThemeSignals.themeId.value = savedTheme;
    }
  }

  void onSwitchTheme() {
    ThemeSignals.themeId.value = ThemeSignals.isDark() ? lightMode : darkMode;
    Storage.save(_themeKey, ThemeSignals.themeId.value);
  }
}

import 'package:vocary/app/signals/theme_signal.dart';
import 'package:vocary/core/storage.dart';

const String themeStorageKey = 'themeId';

class ThemeController {
  static Future<void> loadTheme() async {
    final savedTheme = await Storage.get<String>(themeStorageKey);
    if (savedTheme != null) {
      ThemeSignals.themeId.value = savedTheme;
    }
  }

  void onSwitchTheme() {
    ThemeSignals.themeId.value = ThemeSignals.isDark() ? lightMode : darkMode;
    Storage.save(themeStorageKey, ThemeSignals.themeId.value);
  }
}
